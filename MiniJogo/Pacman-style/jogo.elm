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

gapSize : Float
gapSize = 0.5

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

map: List (List Int)
map = [[ -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [ -1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, -1, -1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, -1],
    [ -1,  1, -1, -1, -1, -1,  1, -1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1, -1,  1, -1, -1, -1, -1,  1, -1],
    [ -1,  2, -1, -1, -1, -1,  1, -1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1, -1,  1, -1, -1, -1, -1,  2, -1],
    [ -1,  1, -1, -1, -1, -1,  1, -1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1, -1,  1, -1, -1, -1, -1,  1, -1],
    [ -1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, -1],
    [ -1,  1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1,  1, -1],
    [ -1,  1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1,  1, -1],
    [ -1,  1,  1,  1,  1,  1,  1, -1, -1,  1,  1,  1,  1, -1, -1,  1,  1,  1,  1, -1, -1,  1,  1,  1,  1,  1,  1, -1],
    [ -1, -1, -1, -1, -1, -1,  1, -1, -1, -1, -1, -1,  0, -1, -1,  0, -1, -1, -1, -1, -1,  1, -1, -1, -1, -1, -1, -1],
    [ -1, -1, -1, -1, -1, -1,  1, -1, -1, -1, -1, -1,  0, -1, -1,  0, -1, -1, -1, -1, -1,  1, -1, -1, -1, -1, -1, -1],
    [ -1, -1, -1, -1, -1, -1,  1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1,  1, -1, -1, -1, -1, -1, -1],
    [ -1, -1, -1, -1, -1, -1,  1, -1, -1,  0, -1, -1,  3,  3,  3,  3, -1, -1,  0, -1, -1,  1, -1, -1, -1, -1, -1, -1],
    [ -1, -1, -1, -1, -1, -1,  1, -1, -1,  0, -1,  4,  4,  4,  4,  4,  4, -1,  0, -1, -1,  1, -1, -1, -1, -1, -1, -1],
    [  0,  0,  0,  0,  0,  0,  1,  0,  0,  0, -1,  4,  4,  4,  4,  4,  4, -1,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0],
    [ -1, -1, -1, -1, -1, -1,  1, -1, -1,  0, -1,  4,  4,  4,  4,  4,  4, -1,  0, -1, -1,  1, -1, -1, -1, -1, -1, -1],
    [ -1, -1, -1, -1, -1, -1,  1, -1, -1,  0, -1, -1, -1, -1, -1, -1, -1, -1,  0, -1, -1,  1, -1, -1, -1, -1, -1, -1],
    [ -1, -1, -1, -1, -1, -1,  1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1,  1, -1, -1, -1, -1, -1, -1],
    [ -1, -1, -1, -1, -1, -1,  1, -1, -1,  0, -1, -1, -1, -1, -1, -1, -1, -1,  0, -1, -1,  1, -1, -1, -1, -1, -1, -1],
    [ -1, -1, -1, -1, -1, -1,  1, -1, -1,  0, -1, -1, -1, -1, -1, -1, -1, -1,  0, -1, -1,  1, -1, -1, -1, -1, -1, -1],
    [ -1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, -1, -1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, -1],
    [ -1,  1, -1, -1, -1, -1,  1, -1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1, -1,  1, -1, -1, -1, -1,  1, -1],
    [ -1,  1, -1, -1, -1, -1,  1, -1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1, -1,  1, -1, -1, -1, -1,  1, -1],
    [ -1,  2,  1,  1, -1, -1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, -1, -1,  1,  1,  2, -1],
    [ -1, -1, -1,  1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1,  1, -1, -1, -1],
    [ -1, -1, -1,  1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1,  1, -1, -1, -1],
    [ -1,  1,  1,  1,  1,  1,  1, -1, -1,  1,  1,  1,  1, -1, -1,  1,  1,  1,  1, -1, -1,  1,  1,  1,  1,  1,  1, -1],
    [ -1,  1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  1, -1],
    [ -1,  1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  1, -1, -1,  1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  1, -1],
    [ -1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, -1],
    [ -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]]

createpointsArray: List (Int) -> List (Int)
createpointsArray lst =
    case lst of
        [] -> []
        hd::tl -> (if hd==1 || hd ==2 then hd else 0)::createpointsArray tl 

createPointsMatrix : List (List Int) -> List (List Int)
createPointsMatrix m =
    case m of
        [] -> []
        hd::tl -> (createpointsArray hd)::createPointsMatrix tl

type alias Position = 
    { x : Float, y : Float }

type alias Character = 
    { logicPosition : Position , renderPosition : Position, direction : Direction, seed : Random.Seed, indexSeed : Int, color : Int }

type alias Game = 
    { pacman : Character , ghosts : List Character , points : List (List Int), won : Bool, spawn : Bool, lost : Bool }

newPacman : Character
newPacman = { logicPosition = {x = mininumX, y = 1}, renderPosition = {x = mininumX, y = 1}, direction = Right, seed = (piSeed 0), indexSeed = 0, color = 0}

minNumGhosts : Int
minNumGhosts = 4

originalGhostList : List Character
originalGhostList = ghost1::ghost2::ghost3::ghost4::[]

ghost1 : Character
ghost1 = { logicPosition = {x = 2.5, y = 2}, renderPosition = {x = 2.5, y = 2}, direction = Right, seed = (piSeed 1), indexSeed = 1, color = 0}

ghost2 : Character
ghost2 = { logicPosition = {x = 2.5, y = 0}, renderPosition = {x = 2.5, y = 0}, direction = Left, seed = (piSeed 2), indexSeed = 2, color = 0}

ghost3 : Character
ghost3 = { logicPosition = {x = -2.5, y = 2}, renderPosition = {x = -2.5, y = 2}, direction = Up, seed = (piSeed 3), indexSeed = 3, color = 1}

ghost4 : Character
ghost4 = { logicPosition = {x = -2.5, y = 0}, renderPosition = {x = -2.5, y = 0}, direction = Up, seed = (piSeed 4), indexSeed = 4, color = 1}

currentGame : Game
currentGame = { pacman = newPacman,
    ghosts = originalGhostList,
    points = (createPointsMatrix map), 
    won = False,
    spawn = False,
    lost = False }

piSeed : Int -> Random.Seed
piSeed i = Random.initialSeed (31415*i)

update : (Time.Time, { x:Int, y:Int }, Bool) -> Game -> Game
update (delta, direction, restart) game =
    (if not game.won && not game.lost then updateGame game delta direction else game)
    |> checkRestart restart
    
checkRestart : Bool -> Game -> Game
checkRestart restart game =
    if not restart then game else currentGame
    
updateGame : Game -> Time.Time -> { x:Int, y:Int } -> Game
updateGame game delta direction =
    changeDirection direction game
    |> updateGameLogicPosition delta
    |> updateGameRenderPosition
    |> updateGamePoints
    |> changeGameghostsDirection
    |> spawnGhosts
    |> moveGameghosts
    |> updateGameGhostRender
    |> removeGameCollidedghosts
    |> removeGhostDeficit
    |> changeGameGhostColors
    |> checkWinner
    |> checkLooser

changeGameghostsDirection : Game -> Game
changeGameghostsDirection game = { game | ghosts <- (changeghostsDirection game.ghosts)}

changeghostsDirection : List Character -> List Character
changeghostsDirection ghosts =
    case ghosts of
        [] -> []
        hd::tl -> changeghostDirection hd :: changeghostsDirection tl

possibleDirections : Character -> List Direction
possibleDirections char = 
    getInitialPossibleDirections char.direction
    |> removeDirectionsToWall char []

removeDirectionsToWall : Character -> List Direction -> List Direction -> List Direction
removeDirectionsToWall char acc lst =
    case lst of
        [] -> acc
        hd::tl -> 
            let position = updateBasicLogicPosition char.logicPosition hd
            in if (positionIsWall position.x position.y) then (removeDirectionsToWall char acc tl) else (removeDirectionsToWall char (hd::acc) tl)

getInitialPossibleDirections : Direction -> List Direction
getInitialPossibleDirections dir = 
    case dir of
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

spawnGhosts : Game -> Game
spawnGhosts game = 
    (if game.spawn then { game | ghosts <- spawnNewGhosts game.ghosts } else game)
    |> updateSpawn False

spawnNewGhosts : List Character -> List Character
spawnNewGhosts ghosts = 
    case ghosts of
        [] -> []
        hd::tl -> if canUpdateLogicPositionCharacter hd then hd::(createTwinGhost hd)::(spawnNewGhosts tl) else hd::(spawnNewGhosts tl)

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

moveGameghosts : Game -> Game
moveGameghosts game = {game | ghosts <- moveghosts game.ghosts}

moveghosts : List Character -> List Character
moveghosts ghosts = 
    case ghosts of
        [] -> []
        hd::tl -> moveghost hd :: moveghosts tl

moveghost : Character -> Character
moveghost ghost = updateCharacterLogicPosition ghost 0

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
    g1.renderPosition.x == g2.renderPosition.x && g1.renderPosition.y == g2.renderPosition.y

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

updateghostSeed : Random.Seed -> Character -> Character
updateghostSeed newSeed ghost = { ghost | seed <- newSeed}

updateghostDirection : Int -> Character -> Character
updateghostDirection newDir ghost = changeCharacterDirection ghost (findIndex (possibleDirections ghost) (toFloat newDir) 1 1 Up) 

oppositeDirection : Direction -> Direction
oppositeDirection dir =
    case dir of
        Up    -> Down
        Down  -> Up
        Left  -> Right
        Right -> Left

updateCharacterPosition: Character -> Time.Time -> Character
updateCharacterPosition char dt =
    { char | logicPosition <- updateLogicPosition char.logicPosition char.direction}

getDirection : { x:Int, y:Int } -> Direction -> Direction
getDirection {x, y} prev = 
    if  | x > 0 -> Right
        | x < 0 -> Left
        | y < 0 -> Down
        | y > 0 -> Up
        | otherwise -> prev

setAccordingToWall : Float -> Float -> a -> a -> a
setAccordingToWall x y wallVal otherVal = if (positionIsWall x y) then wallVal else otherVal

changeCharacterDirection: Character -> Direction -> Character
changeCharacterDirection char dir = 
    if canUpdateLogicPositionCharacter char then
        case dir of 
            Up    -> { char | direction <- (setAccordingToWall char.logicPosition.x (char.logicPosition.y+1)) char.direction dir }
            Down  -> { char | direction <- (setAccordingToWall char.logicPosition.x (char.logicPosition.y-1)) char.direction dir }
            Left  -> { char | direction <- (setAccordingToWall (char.logicPosition.x-1) char.logicPosition.y) char.direction dir }
            Right -> { char | direction <- (setAccordingToWall (char.logicPosition.x+1) char.logicPosition.y) char.direction dir }
    else
        char

changeDirection : { x:Int, y:Int } -> Game -> Game
changeDirection {x,y} game = { game | pacman <- (changeCharacterDirection game.pacman (getDirection {x=x, y=y} game.pacman.direction)) }

findIndex : List a -> Float -> Float -> Float -> a -> a
findIndex list index curr step nilVal =
    case list of
        [] -> nilVal
        hd::tl -> if curr == index then hd else (findIndex tl index (curr+step) step nilVal)

subsValArray : List a -> Float -> Float -> Float -> a -> List a
subsValArray list index curr step val =
    case list of
        [] -> []
        hd::tl -> if curr == index then val::tl else hd::(subsValArray tl index (curr+step) step val)

countOccurencesArray : List a -> a -> Int
countOccurencesArray list val =
    case list of
        [] -> 0
        hd::tl -> (if hd==val then 1 else 0) + (countOccurencesArray tl val)
        
countOcurrencesMatrix : List (List a) -> a -> Int
countOcurrencesMatrix m val =
    case m of 
        [] -> 0
        hd::tl -> (countOccurencesArray hd val) + (countOcurrencesMatrix tl val)

positionIsWall : Float -> Float -> Bool
positionIsWall x y = (findIndex (findIndex map y maximumY -1 []) x mininumX 1 0) == -1

oppositeExtreme : number -> number -> number -> number
oppositeExtreme min max val =
    if | val < min -> max
       | val > max -> min
       | otherwise -> val

updateLogicPosition : Position -> Direction -> Position
updateLogicPosition pos dir = 
    case dir of
        Up    -> { pos | y <- (oppositeExtreme mininumY maximumY (setAccordingToWall pos.x (pos.y+1) pos.y (pos.y+1))) }
        Down  -> { pos | y <- (oppositeExtreme mininumY maximumY (setAccordingToWall pos.x (pos.y-1) pos.y (pos.y-1))) }
        Left  -> { pos | x <- (oppositeExtreme mininumX maximumX (setAccordingToWall (pos.x-1) pos.y pos.x (pos.x-1))) }
        Right -> { pos | x <- (oppositeExtreme mininumX maximumX (setAccordingToWall (pos.x+1) pos.y pos.x (pos.x+1))) }

updateBasicLogicPosition : Position -> Direction -> Position
updateBasicLogicPosition pos dir = 
    case dir of
        Up    -> { pos | y <- oppositeExtreme mininumY maximumY (pos.y+1) }
        Down  -> { pos | y <- oppositeExtreme mininumY maximumY (pos.y-1) }
        Left  -> { pos | x <- oppositeExtreme mininumX maximumX (pos.x-1) }
        Right -> { pos | x <- oppositeExtreme mininumX maximumX (pos.x+1) }
        
canUpdateRenderPositionCharacter : Character -> Bool
canUpdateRenderPositionCharacter char = not(char.renderPosition.x == char.logicPosition.x && char.renderPosition.y==char.logicPosition.y)

canUpdateLogicPositionCharacter : Character -> Bool
canUpdateLogicPositionCharacter char = char.renderPosition.x == char.logicPosition.x && char.renderPosition.y==char.logicPosition.y

updateCharacterLogicPosition: Character -> Time.Time -> Character
updateCharacterLogicPosition char dt = { char | logicPosition <- if (canUpdateLogicPositionCharacter char) then updateLogicPosition char.logicPosition char.direction else char.logicPosition}

updateGameLogicPosition : Time.Time -> Game -> Game
updateGameLogicPosition dt game = { game | pacman <- updateCharacterLogicPosition game.pacman dt }

updateRenderPosition :  Position -> Direction -> Position
updateRenderPosition pos dir = 
    case dir of
        Up    -> { pos | y <- (oppositeExtreme mininumY maximumY (setAccordingToWall pos.x (pos.y+gapSize) pos.y (pos.y+gapSize))) }
        Down  -> { pos | y <- (oppositeExtreme mininumY maximumY (setAccordingToWall pos.x (pos.y-gapSize) pos.y (pos.y-gapSize))) }
        Left  -> { pos | x <- (oppositeExtreme mininumX maximumX (setAccordingToWall (pos.x-gapSize) pos.y pos.x (pos.x-gapSize))) }
        Right -> { pos | x <- (oppositeExtreme mininumX maximumX (setAccordingToWall (pos.x+gapSize) pos.y pos.x (pos.x+gapSize))) }

updateCaracterRenderPosition: Character -> Character
updateCaracterRenderPosition char = { char | renderPosition <- if (canUpdateRenderPositionCharacter char) then updateRenderPosition char.renderPosition char.direction else char.renderPosition}

updateGameRenderPosition : Game -> Game
updateGameRenderPosition game = { game | pacman <- updateCaracterRenderPosition game.pacman }

updateGamePoints: Game -> Game
updateGamePoints game = 
    game
    |> updateSpawn2
    |> updateGamePointsMatrix

updateGamePointsMatrix: Game -> Game
updateGamePointsMatrix game =
    { game | points <- subsValArray game.points game.pacman.logicPosition.y maximumY -1 (subsValArray (findIndex game.points game.pacman.logicPosition.y maximumY -1 []) game.pacman.logicPosition.x mininumX 1 0) }

updateSpawn2: Game -> Game
updateSpawn2 game = 
    let point = (findIndex (findIndex game.points game.pacman.logicPosition.y maximumY -1 []) game.pacman.logicPosition.x mininumX 1 0)
    in { game | spawn <- (point == 2) }

updateSpawn : Bool -> Game -> Game
updateSpawn b game =
    { game | spawn <- b}

checkWinner: Game -> Game
checkWinner game =
    { game | won <- ((countOcurrencesMatrix game.points 1)+(countOcurrencesMatrix game.points 2))==0 }

checkLooser: Game -> Game
checkLooser game =
    { game | lost <- isGameLost game }

isGameLost: Game -> Bool
isGameLost game =
    didPacmanCollidedWithGosht game.pacman game.ghosts

didPacmanCollidedWithGosht: Character -> List Character -> Bool
didPacmanCollidedWithGosht pacman ghosts =
    case ghosts of
        [] -> False
        hd::tl -> if hd.renderPosition.x == pacman.renderPosition.x && hd.renderPosition.y == pacman.renderPosition.y then True else didPacmanCollidedWithGosht pacman tl

updateGameGhostRender: Game -> Game
updateGameGhostRender game =
    { game | ghosts <- updateGhostsRender game.ghosts }

updateGhostsRender: List Character -> List Character
updateGhostsRender ghosts =
    case ghosts of
        [] -> []
        hd::tl -> (updateGhostRender hd)::(updateGhostsRender tl)

updateGhostRender: Character -> Character
updateGhostRender ghost = updateCaracterRenderPosition ghost

changeGameGhostColors: Game -> Game
changeGameGhostColors game  = { game | ghosts <- changeGhostsColor game.ghosts }

changeGhostsColor: List Character -> List Character
changeGhostsColor ghosts = 
    case ghosts of
        [] -> []
        hd::tl -> (changeGhostColor hd)::changeGhostsColor tl

changeGhostColor : Character -> Character
changeGhostColor ghost = { ghost | color <- 1 - ghost.color }

--Here

-- VIEW
getGhostsForms : List Character -> List Graphics.Collage.Form
getGhostsForms ghosts =
    case ghosts of
        [] -> []
        hd::tl -> getGhostForm hd :: getGhostsForms tl

getGhostForm : Character -> Graphics.Collage.Form
getGhostForm char =
    Graphics.Collage.move (char.renderPosition.x*tileSize, char.renderPosition.y*tileSize) (Graphics.Collage.toForm (Graphics.Element.image 15 15 (ghostImagePath char)))

ghostImagePath : Character -> String
ghostImagePath char = 
    case char.color of
        0 -> "./images/blueghost_0.gif"
        1 -> "./images/blueghost_1.gif"

getCircle : Int -> Float -> Float -> List Graphics.Collage.Form
getCircle i x y =
    if | i == 1 -> (Graphics.Collage.move (x, y) (Graphics.Collage.filled white (Graphics.Collage.circle 1.5)))::[]
       | i == 2 -> (Graphics.Collage.move (x, y) (Graphics.Collage.filled white (Graphics.Collage.circle 4)))::[]
       | otherwise -> []

getCirclesFromArray : List Int -> Float -> Float -> List Graphics.Collage.Form
getCirclesFromArray lst x y = 
    case lst of 
        [] -> []
        hd::tl -> (getCircle hd x y) ++ (getCirclesFromArray tl (x+tileSize) y)

getCirclesFromMatrix : List (List Int) -> Float -> Float -> List Graphics.Collage.Form
getCirclesFromMatrix m x y =
    case m of
        [] -> []
        hd::tl -> (getCirclesFromArray hd x y) ++ (getCirclesFromMatrix tl x (y-tileSize))

getCircles : Game -> List Graphics.Collage.Form
getCircles game = getCirclesFromMatrix game.points (mininumX*tileSize) (maximumY*tileSize)

getSquaresFromArray : List Int -> Float -> Float -> List Graphics.Collage.Form 
getSquaresFromArray xs x y = 
    case xs of
        [] -> []
        hd::tl -> (Graphics.Collage.move (x, y) (Graphics.Collage.filled (getBlockColor hd) (Graphics.Collage.rect tileSize tileSize))) :: (getSquaresFromArray tl (x+tileSize) y)

getSquaresFromMatrix : List (List Int) -> Float -> Float -> List Graphics.Collage.Form
getSquaresFromMatrix xs x y = 
    case xs of
        [] -> []
        hd::tl -> (getSquaresFromArray hd x y) ++ (getSquaresFromMatrix tl x (y-tileSize))

getAllForms : List Graphics.Collage.Form
getAllForms = (getSquaresFromMatrix map (mininumX*tileSize) (maximumY*tileSize))
 
getBlockColor : Int -> Color.Color
getBlockColor i =
    case i of
        -1 -> grey
        0 -> black
        1 -> black
        2 -> black
        3 -> black
        4 -> black

black : Color.Color
black = Color.rgba 0 0 0 1
  
grey : Color.Color
grey = Color.rgba 55 55 55 1

white : Color.Color
white = Color.rgba 255 255 255 1

getPacmanForm : Character -> Graphics.Collage.Form
getPacmanForm char =
    Graphics.Collage.move (char.renderPosition.x*tileSize, char.renderPosition.y*tileSize) (Graphics.Collage.toForm (Graphics.Element.image 15 15 (pacmanImagePath char.direction)))

pacmanImagePath : Direction -> String
pacmanImagePath dir =
    case dir of
        Up -> "./images/pacman_up.png"
        Down -> "./images/pacman_down.png"
        Left -> "./images/pacman_left.png"
        Right -> "./images/pacman_right.png"
        
getMessage: Game -> String 
getMessage game =
    if game.won then "You Won! Press Shift to Restart :-)"
    else
        if game.lost then "You Lost! Press Shift to Restart :-("
        else ""
    
getMessageElements: Game -> List Graphics.Element.Element
getMessageElements game =
    let msg = getMessage game in
    if msg=="" then [] else (Graphics.Element.show msg)::[]

render: Game -> Graphics.Element.Element
render game = 
    let gameMapFlow = Graphics.Element.flow Graphics.Element.outward (
        (Graphics.Collage.collage (floor (numXBlocks*tileSize)) (floor (numYBlocks*tileSize)) (getAllForms++(getCircles game)++((getPacmanForm game.pacman)::[])++(getGhostsForms game.ghosts)))::[])
    in Graphics.Element.flow Graphics.Element.down (gameMapFlow::(getMessageElements game))

-- SIGNALS
main : Signal Graphics.Element.Element
main = Signal.map render (Signal.foldp update currentGame input)

input : Signal (Time.Time, { x:Int, y:Int }, Bool)
input = Signal.sampleOn delta (Signal.map3 (,,) delta Keyboard.arrows Keyboard.shift)


delta : Signal Time.Time
delta = Signal.map (\t -> t / 20) (Time.fps 15)
