import Color
import Graphics.Collage 
import Graphics.Element
import Keyboard
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

speed : Float
speed = 0.25

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

type alias Position = 
    { x : Float, y : Float }

type alias Character = 
    { logicPosition : Position , renderPosition : Position, direction : Direction }

type alias Game = 
    { pacman : Character , phantom : Character }

currentGame : Game
currentGame = { pacman = { logicPosition = { x = mininumX, y = 1}, renderPosition = { x = 1, y = 1}, direction = Right},
    phantom = { logicPosition = { x = 20, y = 20}, renderPosition = { x = 20, y = 20}, direction = Left}}

update : (Time.Time, { x:Int, y:Int }) -> Game -> Game
update (delta, direction) game =
    changeDirection direction game
    |> updateGamePosition delta

getDirection : { x:Int, y:Int } -> Direction -> Direction
getDirection {x, y} prev = 
    if  | x > 0 -> Right
        | x < 0 -> Left
        | y < 0 -> Down
        | y > 0 -> Up
        | otherwise -> prev

changeCharacterDirection: Character -> Direction -> Character
changeCharacterDirection char dir = 
    { char | direction <- dir }

changeDirection : { x:Int, y:Int } -> Game -> Game
changeDirection {x,y} game =
    { game | pacman <- (changeCharacterDirection game.pacman (getDirection {x=x, y=y} game.pacman.direction)) }

findIndex : List a -> Float -> Float -> Float -> a -> a
findIndex list index curr step nilVal =
    case list of
        [] -> nilVal
        hd::tl -> if curr == index then hd else (findIndex tl index (curr+step) step nilVal)

positionIsWall : Float -> Float -> Bool
positionIsWall x y =
    (findIndex (findIndex map y maximumY -1 []) x mininumX 1 0) == -1

oppositeExtreme : number -> number -> number -> number
oppositeExtreme min max val =
    if | val < min -> max
       | val > max -> min
       | otherwise -> val

updatePosition : Position -> Direction -> Position
updatePosition pos dir = 
    case dir of
        Up    -> { pos | y <- (oppositeExtreme mininumY maximumY (if (positionIsWall pos.x (pos.y+1)) then pos.y else (pos.y+1))) }
        Down  -> { pos | y <- (oppositeExtreme mininumY maximumY (if (positionIsWall pos.x (pos.y-1)) then pos.y else (pos.y-1))) }
        Left  -> { pos | x <- (oppositeExtreme mininumX maximumX (if (positionIsWall (pos.x-1) pos.y) then pos.x else (pos.x-1))) }
        Right -> { pos | x <- (oppositeExtreme mininumX maximumX (if (positionIsWall (pos.x+1) pos.y) then pos.x else (pos.x+1))) }

updateCharacterPosition: Character -> Time.Time -> Character
updateCharacterPosition char dt =
    { char | logicPosition <- updatePosition char.logicPosition char.direction}

updateGamePosition : Time.Time -> Game -> Game
updateGamePosition dt game =
    { game | pacman <- updateCharacterPosition game.pacman dt }

-- VIEW
getCircle : Int -> Float -> Float -> List Graphics.Collage.Form
getCircle i x y =
    case i of
        -1 -> []
        0 -> []
        1 -> (Graphics.Collage.move (x, y) (Graphics.Collage.filled white (Graphics.Collage.circle 1.5)))::[]
        2 -> (Graphics.Collage.move (x, y) (Graphics.Collage.filled white (Graphics.Collage.circle 4)))::[]
        3 -> []
        4 -> []

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
getAllForms = 
    (getSquaresFromMatrix map (mininumX*tileSize) (maximumY*tileSize))
 
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
    Graphics.Collage.move (char.logicPosition.x*tileSize, char.logicPosition.y*tileSize) (Graphics.Collage.toForm (Graphics.Element.image 15 15 (pacmanImagePath char.direction)))

pacmanImagePath : Direction -> String
pacmanImagePath dir =
    case dir of
        Up -> "./images/pacman_up.png"
        Down -> "./images/pacman_down.png"
        Left -> "./images/pacman_left.png"
        Right -> "./images/pacman_right.png"

render: Game -> Graphics.Element.Element
render game = 
  Graphics.Element.flow Graphics.Element.outward (
      (Graphics.Collage.collage (floor (numXBlocks*tileSize)) (floor (numYBlocks*tileSize)) (getAllForms++((getPacmanForm game.pacman)::[])))::[])

-- SIGNALS
main : Signal Graphics.Element.Element
main =
    Signal.map render (Signal.foldp update currentGame input)


input : Signal (Time.Time, { x:Int, y:Int })
input =
    Signal.sampleOn delta (Signal.map2 (,) delta Keyboard.arrows)


delta : Signal Time.Time
delta =
    Signal.map (\t -> t / 20) (Time.fps 10)
