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

type alias Position = 
    { x : Float, y : Float }

type alias Character = 
    { logicPosition : Position , renderPosition : Position, direction : Direction }

type alias Game = 
    { pacman : Character , phantom : Character }

currentGame : Game
currentGame = { pacman = { logicPosition = { x = mininumX, y = mininumY}, renderPosition = { x = 1, y = 1}, direction = Right},
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

updateGamePosition : Time.Time -> Game -> Game
updateGamePosition dt game =
    { game | pacman <- updateCharacterPosition game.pacman dt }

-- VIEW
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
      (Graphics.Collage.collage (floor (numXBlocks*tileSize)) (floor (numYBlocks*tileSize)) ((getPacmanForm game.pacman)::[]))::[])

-- SIGNALS

main : Signal Graphics.Element.Element
main =
    Signal.map render (Signal.foldp update currentGame input)


input : Signal (Time.Time, { x:Int, y:Int })
input =
    Signal.sampleOn delta (Signal.map2 (,) delta Keyboard.arrows)


delta : Signal Time.Time
delta =
    Signal.map (\t -> t / 20) (Time.fps 25)
