import Array
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
 
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
 
getSquaresFromArray : List Int -> Float -> Float -> List Form 
getSquaresFromArray xs x y = 
  case xs of
    [] -> []
    hd::tl -> (move (x, y) (filled (getBlockColor hd) (rect 20 20))) :: (getSquaresFromArray tl (x+20) y)

getSquaresFromMatrix : List (List Int) -> Float -> Float -> List Form
getSquaresFromMatrix xs x y = 
  case xs of
    [] -> []
    hd::tl -> (getSquaresFromArray hd x y) ++ (getSquaresFromMatrix tl x (y-20))
 
main : Element
main =
  collage (28*20) (31*20) (getSquaresFromMatrix map -270 300)
 
getBlockColor : Int -> Color
getBlockColor i =
  case i of
    -1 -> clearRed
    0 -> clearGrey
    1 -> clearBlue
    2 -> clearBlue
    3 -> clearGrey
    4 -> clearGrey


clearGrey : Color
clearGrey =
  rgba 111 111 111 0.6
  
clearRed : Color
clearRed = 
  rgba 255 0 0 0.3
 
clearBlue : Color
clearBlue = 
  rgba 0 0 255 0.6