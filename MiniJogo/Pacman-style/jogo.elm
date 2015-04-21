import Color
import Graphics.Collage 
import Graphics.Element
 
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
 
getSquaresFromArray : List Int -> Float -> Float -> List Graphics.Collage.Form 
getSquaresFromArray xs x y = 
    case xs of
        [] -> []
        hd::tl -> (Graphics.Collage.move (x, y) (Graphics.Collage.filled (getBlockColor hd) (Graphics.Collage.rect 20 20))) :: (getCircle hd x y) ++ (getSquaresFromArray tl (x+20) y)

getSquaresFromMatrix : List (List Int) -> Float -> Float -> List Graphics.Collage.Form
getSquaresFromMatrix xs x y = 
    case xs of
        [] -> []
        hd::tl -> (getSquaresFromArray hd x y) ++ (getSquaresFromMatrix tl x (y-20))

getCircle : Int -> Float -> Float -> List Graphics.Collage.Form
getCircle i x y =
    case i of
        -1 -> []
        0 -> []
        1 -> (Graphics.Collage.move (x, y) (Graphics.Collage.filled white (Graphics.Collage.circle 2)))::[]
        2 -> (Graphics.Collage.move (x, y) (Graphics.Collage.filled white (Graphics.Collage.circle 5)))::[]
        3 -> []
        4 -> []

getPacmanForm : Graphics.Element.Element
getPacmanForm =
    Graphics.Element.image 15 15 "./images/pacman_right.png"


getAllForms : List Graphics.Collage.Form
getAllForms = 
    (getSquaresFromMatrix map -270 300)
 
main : Graphics.Element.Element
main =
    Graphics.Element.flow Graphics.Element.outward ((Graphics.Collage.collage (28*20) (31*20) getAllForms) :: (getPacmanForm) ::[])
 
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