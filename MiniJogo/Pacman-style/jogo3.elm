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

type alias Position = { x : Float, y : Float }
type alias Character = { logicPosition : Position , renderPosition : Position, direction : Direction }
type alias Game = { pacman : Character , phantom : Character , points : List (List Int), won : Bool }

currentGame : Game
currentGame = { pacman = { logicPosition = { x = mininumX, y = 1}, renderPosition = { x = mininumX, y = 1}, direction = Right},
    phantom = { logicPosition = { x = 20, y = 20}, renderPosition = { x = 20, y = 20}, direction = Left},
    points = (createPointsMatrix map), won = False}

update : (Time.Time, { x:Int, y:Int }, Bool) -> Game -> Game
update (delta, direction, restart) game =
    (if not game.won then updateGame game delta direction else game)
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
    |> checkWinner

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
    { game | points <- subsValArray game.points game.pacman.logicPosition.y maximumY -1 (subsValArray (findIndex game.points game.pacman.logicPosition.y maximumY -1 []) game.pacman.logicPosition.x mininumX 1 0) }

checkWinner: Game -> Game
checkWinner game =
    { game | won <- ((countOcurrencesMatrix game.points 1)+(countOcurrencesMatrix game.points 2))==0 }

-- VIEW
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
    if game.won then "You Won! Press Shift to Restart"
    else ""
    
getMessageElements: Game -> List Graphics.Element.Element
getMessageElements game =
    let msg = getMessage game in
    if msg=="" then [] else (Graphics.Element.show msg)::[]

render: Game -> Graphics.Element.Element
render game = 
    let gameMapFlow = Graphics.Element.flow Graphics.Element.outward (
        (Graphics.Collage.collage (floor (numXBlocks*tileSize)) (floor (numYBlocks*tileSize)) (getAllForms++(getCircles game)++((getPacmanForm game.pacman)::[])))::[])
    in Graphics.Element.flow Graphics.Element.down (gameMapFlow::(getMessageElements game))

-- SIGNALS
main : Signal Graphics.Element.Element
main = Signal.map render (Signal.foldp update currentGame input)

input : Signal (Time.Time, { x:Int, y:Int }, Bool)
input = Signal.sampleOn delta (Signal.map3 (,,) delta Keyboard.arrows Keyboard.shift)


delta : Signal Time.Time
delta = Signal.map (\t -> t / 20) (Time.fps 20)
