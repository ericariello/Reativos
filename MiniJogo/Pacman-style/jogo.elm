import Color
import Graphics.Collage 
import Graphics.Element
type Direction = Up | Down | Right | Left
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

tileSize : number
tileSize = 15
 
getSquaresFromArray : List Int -> Float -> Float -> List Graphics.Collage.Form 
getSquaresFromArray xs x y = 
    case xs of
        [] -> []
        hd::tl -> (Graphics.Collage.move (x, y) (Graphics.Collage.filled (getBlockColor hd) (Graphics.Collage.rect tileSize tileSize))) :: (getCircle hd x y) ++ (getSquaresFromArray tl (x+tileSize) y)

getSquaresFromMatrix : List (List Int) -> Float -> Float -> List Graphics.Collage.Form
getSquaresFromMatrix xs x y = 
    case xs of
        [] -> []
        hd::tl -> (getSquaresFromArray hd x y) ++ (getSquaresFromMatrix tl x (y-tileSize))

getCircle : Int -> Float -> Float -> List Graphics.Collage.Form
getCircle i x y =
    case i of
        -1 -> []
        0 -> []
        1 -> (Graphics.Collage.move (x, y) (Graphics.Collage.filled white (Graphics.Collage.circle 1.5)))::[]
        2 -> (Graphics.Collage.move (x, y) (Graphics.Collage.filled white (Graphics.Collage.circle 4)))::[]
        3 -> []
        4 -> []

getPacmanForm : Float -> Float -> Direction -> Graphics.Collage.Form
getPacmanForm x y dir =
    Graphics.Collage.move (x, y) (Graphics.Collage.toForm (Graphics.Element.image 15 15 (pacmanImagePath dir)))

pacmanImagePath : Direction -> String
pacmanImagePath dir =
    case dir of
        Up -> "./images/pacman_up.png"
        Down -> "./images/pacman_down.png"
        Left -> "./images/pacman_left.png"
        Right -> "./images/pacman_right.png"

getAllForms : List Graphics.Collage.Form
getAllForms = 
    (getSquaresFromMatrix map (-27*tileSize/2) (30*tileSize/2))
 
main : Graphics.Element.Element
main =
    Graphics.Element.flow Graphics.Element.outward (
        (Graphics.Collage.collage (28*tileSize) (31*tileSize) (getAllForms++((getPacmanForm 0 0 Right)::[])))::[])
 
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
black =
    Color.rgba 0 0 0 1
  
grey : Color.Color
grey =
    Color.rgba 55 55 55 1

white : Color.Color
white =
    Color.rgba 255 255 255 1