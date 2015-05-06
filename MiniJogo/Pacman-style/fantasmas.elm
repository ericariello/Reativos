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
    { logicPosition : Position , renderPosition : Position, direction : Direction, seed : Random.Seed }

type alias Game = 
    { phantoms : List Character }

currentGame : Game
currentGame = { phantoms = phantom1::[]}

piSeed : Random.Seed
piSeed = Random.initialSeed 31415

phantom1 : Character
phantom1 = { logicPosition = { x = 20, y = 20}, renderPosition = {x = 20, y = 20}, direction = Left, seed = piSeed}

update : (Time.Time, { x:Int, y:Int }, Bool) -> Game -> Game
update (delta, direction, spawn) game =
    game
    |> changeGamePhantomsDirection
    |> spawnGhosts spawn
    |> moveGamePhantoms

changeGamePhantomsDirection : Game -> Game
changeGamePhantomsDirection game = { game | phantoms <- (changePhantomsDirection game.phantoms)}

changePhantomsDirection : List Character -> List Character
changePhantomsDirection phantoms =
    case phantoms of
        [] -> []
        hd::tl -> changePhantomDirection hd :: changePhantomsDirection tl

changePhantomDirection : Character -> Character
changePhantomDirection phantom =
    let (newDir, newSeed) = Random.generate (Random.int 1 4) phantom.seed
    in phantom
        |> updatePhantomSeed newSeed
        |> updatePhantomDirection newDir

updatePhantomSeed : Random.Seed -> Character -> Character
updatePhantomSeed newSeed phantom = { phantom | seed <- newSeed}

updatePhantomDirection : Int -> Character -> Character
updatePhantomDirection newDir phantom = { phantom | direction <- decodeDir newDir}

decodeDir : Int -> Direction
decodeDir i =
    case i of 
        1 -> Up
        2 -> Down
        3 -> Left
        4 -> Right

moveGamePhantoms : Game -> Game
moveGamePhantoms game = {game | phantoms <- movePhantoms game.phantoms}

movePhantoms : List Character -> List Character
movePhantoms phantoms = 
    case phantoms of
        [] -> []
        hd::tl -> movePhantom hd :: movePhantoms tl

movePhantom : Character -> Character
movePhantom phantom = updateCharacterPosition phantom 0

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
    if spawn then { game | phantoms <- spawnNewGhosts game.phantoms } else game

spawnNewGhosts : List Character -> List Character
spawnNewGhosts ghosts = 
    case ghosts of
        [] -> []
        hd::tl -> hd::(createTwinGhost hd)::(spawnNewGhosts tl)

createTwinGhost : Character -> Character
createTwinGhost ghost =
    ghost 
    |> setCharDir (oppositeDirection ghost.direction)
    |> updatePhantomSeed piSeed 

setCharDir : Direction -> Character -> Character
setCharDir dir char = { char | direction <- dir}

oppositeDirection : Direction -> Direction
oppositeDirection dir =
    case dir of
        Up    -> Down
        Down  -> Up
        Left  -> Right
        Right -> Left

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
      (Graphics.Collage.collage (floor (numXBlocks*tileSize)) (floor (numYBlocks*tileSize)) (getGhostsForms game.phantoms))::[])

-- SIGNALS
main : Signal Graphics.Element.Element
main = Signal.map render (Signal.foldp update currentGame input)

input : Signal (Time.Time, { x:Int, y:Int }, Bool)
input = Signal.sampleOn delta (Signal.map3 (,,) delta Keyboard.arrows Keyboard.shift)


delta : Signal Time.Time
delta = Signal.map (\t -> t / 20) (Time.fps 20)
