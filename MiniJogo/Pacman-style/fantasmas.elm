import Color
import Graphics.Collage 
import Graphics.Element
import Keyboard
import Random
import Signal
import Time

type Direction = Up | Down | Right | Left 

roundDown : Float -> Float
roundDown f = toFloat (floor f)

tileSize : Float
tileSize = 15

numXBlocks : Float
numXBlocks = 28
mininumX : Float
mininumX = -(numXBlocks-1)/2
maximumX : Float
maximumX = numXBlocks + mininumX - 1

numYBlocks : Float
numYBlocks = 31
mininumY : Float
mininumY = -(numYBlocks-1)/2
maximumY : Float
maximumY = numYBlocks + mininumY - 1

type alias Position = 
    { x : Float, y : Float }

type alias Character = 
    { logicPosition : Position , renderPosition : Position, direction : Direction, seed : Random.Seed, indexSeed : Int }

type alias Game = 
    { ghosts : List Character }

currentGame : Game
currentGame = { ghosts = originalGhostList}

piSeed : Int -> Random.Seed
piSeed i = Random.initialSeed (31415*i)

originalGhostList : List Character
originalGhostList = ghost1::ghost2::ghost3::ghost4::[]

ghost1 : Character
ghost1 = { logicPosition = { x = 20, y = 20}, renderPosition = {x = 20, y = 20}, direction = Left, seed = (piSeed 1), indexSeed = 1}

ghost2 : Character
ghost2 = { logicPosition = { x = -20, y = 20}, renderPosition = {x = -20, y = 20}, direction = Left, seed = (piSeed 2), indexSeed = 2}

ghost3 : Character
ghost3 = { logicPosition = { x = 20, y = -20}, renderPosition = {x = 20, y = -20}, direction = Left, seed = (piSeed 3), indexSeed = 3}

ghost4 : Character
ghost4 = { logicPosition = { x = -20, y = -20}, renderPosition = {x = -20, y = -20}, direction = Left, seed = (piSeed 4), indexSeed = 4}

minNumGhosts : Int
minNumGhosts = 4

update : (Time.Time, { x:Int, y:Int }, Bool) -> Game -> Game
update (delta, direction, spawn) game =
    game
    |> changeGameghostsDirection
    |> spawnGhosts spawn
    |> moveGameghosts
    |> removeGameCollidedghosts
    |> removeGhostDeficit

changeGameghostsDirection : Game -> Game
changeGameghostsDirection game = { game | ghosts <- (changeghostsDirection game.ghosts)}

changeghostsDirection : List Character -> List Character
changeghostsDirection ghosts =
    case ghosts of
        [] -> []
        hd::tl -> changeghostDirection hd :: changeghostsDirection tl

possibleDirections : Character -> List Direction
possibleDirections char = 
    case char.direction of
        Up    -> Up   :: Left :: Right :: []
        Down  -> Down :: Left :: Right :: []
        Left  -> Up   :: Down :: Left  :: []
        Right -> Up   :: Down :: Right :: []

changeghostDirection : Character -> Character
changeghostDirection ghost =
    let (newDir, newSeed) = Random.generate (Random.int 1 (countElements (possibleDirections ghost))) ghost.seed
    in ghost
        |> updateghostSeed newSeed
        |> updateghostDirection newDir

findIndex : List a -> Float -> Float -> Float -> a -> a
findIndex list index curr step nilVal =
    case list of
        [] -> nilVal
        hd::tl -> if curr == index then hd else (findIndex tl index (curr+step) step nilVal)

updateghostSeed : Random.Seed -> Character -> Character
updateghostSeed newSeed ghost = { ghost | seed <- newSeed}

updateghostDirection : Int -> Character -> Character
updateghostDirection newDir ghost = { ghost | direction <- findIndex (possibleDirections ghost) (toFloat newDir) 1 1 Up }

decodeDir : Int -> Direction
decodeDir i =
    case i of 
        1 -> Up
        2 -> Down
        3 -> Left
        4 -> Right

moveGameghosts : Game -> Game
moveGameghosts game = {game | ghosts <- moveghosts game.ghosts}

moveghosts : List Character -> List Character
moveghosts ghosts = 
    case ghosts of
        [] -> []
        hd::tl -> moveghost hd :: moveghosts tl

moveghost : Character -> Character
moveghost ghost = updateCharacterPosition ghost 0

changeCharacterDirection: Character -> Direction -> Character
changeCharacterDirection char dir = 
    { char | direction <- dir }

updatePosition : Position -> Direction -> Position
updatePosition pos dir = 
    case dir of
        Up    -> { pos | y <- (clamp mininumY maximumY (pos.y+1)) }
        Down  -> { pos | y <- (clamp mininumY maximumY (pos.y-1)) }
        Left  -> { pos | x <- (clamp mininumX maximumX (pos.x-1)) }
        Right -> { pos | x <- (clamp mininumX maximumX (pos.x+1)) }

updateCharacterPosition: Character -> Time.Time -> Character
updateCharacterPosition char dt =
    { char | logicPosition <- updatePosition char.logicPosition char.direction}

spawnGhosts : Bool -> Game -> Game
spawnGhosts spawn game = 
    if spawn then { game | ghosts <- spawnNewGhosts game.ghosts } else game

spawnNewGhosts : List Character -> List Character
spawnNewGhosts ghosts = 
    case ghosts of
        [] -> []
        hd::tl -> hd::(createTwinGhost hd)::(spawnNewGhosts tl)

createTwinGhost : Character -> Character
createTwinGhost ghost =
    ghost 
    |> setCharDir (oppositeDirection ghost.direction)
    |> updateghostindexSeed (ghost.indexSeed*2)
    |> updateghostSeed (piSeed (ghost.indexSeed*2)) 

updateghostindexSeed : Int -> Character -> Character
updateghostindexSeed i ghost = { ghost | indexSeed <- i}

setCharDir : Direction -> Character -> Character
setCharDir dir char = { char | direction <- dir}

oppositeDirection : Direction -> Direction
oppositeDirection dir =
    case dir of
        Up    -> Down
        Down  -> Up
        Left  -> Right
        Right -> Left

removeGameCollidedghosts: Game -> Game
removeGameCollidedghosts game = { game | ghosts <- removeCollidedghosts game.ghosts}

removeCollidedghosts : List Character -> List Character
removeCollidedghosts ghosts =
    case ghosts of
        [] -> []
        hd::tl -> hd::removeCollidedghosts(removeGhostCopies hd tl)

removeGhostCopies : Character -> List Character -> List Character
removeGhostCopies char lst =
    case lst of
        [] -> []
        hd::tl -> if (samePositionGhosts char hd) then removeGhostCopies char tl else hd::(removeGhostCopies char tl)

samePositionGhosts : Character -> Character -> Bool
samePositionGhosts g1 g2 =
    g1.logicPosition.x == g2.logicPosition.x && g1.logicPosition.y == g2.logicPosition.y

removeGhostDeficit : Game -> Game
removeGhostDeficit game = 
    let deficit = 4 - (countElements game.ghosts)
    in if deficit>0 then { game | ghosts <- addMissingGhosts game.ghosts deficit} else game

countElements : List a -> Int
countElements lst =
    case lst of
        [] -> 0
        hd::tl -> 1 + countElements tl

addMissingGhosts : List Character -> Int -> List Character
addMissingGhosts ghosts i =
    ghosts ++ (copyGhosts originalGhostList i)

copyGhosts : List Character -> Int -> List Character
copyGhosts ghosts i =
    case ghosts of
        [] -> []
        hd::tl -> if i>0 then hd::(copyGhosts tl (i-1)) else []


-- VIEW
getGhostsForms : List Character -> List Graphics.Collage.Form
getGhostsForms ghosts =
    case ghosts of
        [] -> []
        hd::tl -> getGhostForm hd :: getGhostsForms tl

getGhostForm : Character -> Graphics.Collage.Form
getGhostForm char =
    Graphics.Collage.move (char.logicPosition.x*tileSize, char.logicPosition.y*tileSize) (Graphics.Collage.toForm (Graphics.Element.image 15 15 ghostImagePath))

ghostImagePath : String
ghostImagePath = "./images/blueghost_0.gif"

render: Game -> Graphics.Element.Element
render game = 
  Graphics.Element.flow Graphics.Element.outward (
      (Graphics.Collage.collage (floor (numXBlocks*tileSize)) (floor (numYBlocks*tileSize)) (getGhostsForms game.ghosts))::[])

-- SIGNALS
main : Signal Graphics.Element.Element
main = Signal.map render (Signal.foldp update currentGame input)

input : Signal (Time.Time, { x:Int, y:Int }, Bool)
input = Signal.sampleOn delta (Signal.map3 (,,) delta Keyboard.arrows Keyboard.shift)


delta : Signal Time.Time
delta = Signal.map (\t -> t / 20) (Time.fps 20)
