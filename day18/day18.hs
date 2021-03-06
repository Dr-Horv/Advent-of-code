

import Data.List.Split

type State = [[Int]]
type Pos = (Int, Int)

main :: IO ()
main = do 
    print $ lightsOn $ iterate nextState (lightCorners initialState) !! 100
    return ()

prettifyState :: State -> String
prettifyState = concatMap ((++"\n") . show)

lightsOn :: State -> Int
lightsOn s = length $ filter (==1) $ concat s

initialStateExample :: State
initialStateExample = [
        [0,1,0,1,0,1],
        [0,0,0,1,1,0],
        [1,0,0,0,0,1],
        [0,0,1,0,0,0],
        [1,0,1,0,0,1],
        [1,1,1,1,0,0]
        ]

lightCorners :: State -> State
lightCorners s = chunksOf (nbrOfCols s) [ valueOfPos' s (x,y) | x <- [0..(nbrOfRows s - 1)], y <- [0..(nbrOfCols s - 1)] ]
    

nextState :: State -> State
nextState s = chunksOf (nbrOfCols s) $ [ calculatePos s (x,y) | x <- [0..(nbrOfRows s - 1)], y <- [0..(nbrOfCols s - 1)] ]

nbrOfRows :: State -> Int
nbrOfRows = length 

nbrOfCols :: State -> Int
nbrOfCols = length . head

calculatePos :: State -> Pos -> Int
calculatePos s p = case valueOfPos' s p of 
                    1 -> if isCorner s p || f (length (filter (==1) nbs)) then 1 else 0
                    0 -> if length (filter (==1) nbs) == 3 then 1 else 0
                    where
                        f i = i == 3 || i == 2
                        nbs = neighbors s p

neighbors :: State -> Pos -> [Int]
neighbors s (x,y) = [valueOfPos' s (x',y') | x' <- [x-1..x+1], y' <- [y-1..y+1], (x',y') /= (x,y) ]

valueOfPos' :: State -> Pos -> Int
valueOfPos' s p@(x,y) | isOutSide s p   = 0 
                      | isCorner s p    = 1 
                      | otherwise       = (s !! x) !! y

isOutSide :: State -> Pos -> Bool
isOutSide s (x,y) = x >= nbrOfRows s || x < 0 || y >= nbrOfCols s || y < 0

isCorner :: State -> Pos -> Bool
isCorner s (x,y)  = ((nbrOfRows s - 1) == x && yCorner) || (x == 0 && yCorner)
    where
        yCorner = nbrOfCols s - 1 == y || y == 0

valueOfPos :: State -> Pos -> Int
valueOfPos s (x,y) = if isOutSide s (x,y) then 0 else (s !! x) !! y
    where
        isOutSide :: State -> Pos -> Bool
        isOutSide s (x,y) = x >= nbrOfRows s || x < 0 || y >= nbrOfCols s || y < 0



initialState :: State
initialState = s 
    where
        s = [[1,0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,1,0,1,1,0,0,1,0,0,0,1,1,0,0,0,0,0,0,1,1,0,1,0,1,0,1,1,1,0,1,0,1,0,0,1,0,0,1,0,0,0,0,0,0,1,1,1,1,0,0,1,0,0,0,0,0,0,1,1,1,0,1,0,1,0,0,0,0,1,0,0,1,1,0,0,1,1,1,0,0],
             [1,1,1,1,0,0,1,0,1,0,0,0,1,0,0,0,0,1,0,1,1,1,1,1,0,1,1,0,1,1,0,1,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1,1,0,0,0,1,1,1,0,1,1,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,1,0,1,1,0,0,0,1,1,0,0,1,0,1,1,1,1,0,1],
             [0,0,0,1,0,0,1,1,0,0,0,1,0,1,0,1,1,1,0,1,0,1,1,1,0,0,1,0,1,1,0,1,1,1,1,0,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,0,0,1,1,0,1,0,1,1,0,1,0,1,1,1,0,0,0,1,0,1,0,0,1,1,1,0,0,0,0,1,0,1,1,1,0,1,0,0,1,0],
             [0,1,0,0,0,1,1,0,0,0,1,1,1,1,0,1,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,1,0,1,0,1,1,0,0,0,1,0,0,0,1,1,0,0,1,0,1,0,1,1,1,0,0,0,0,1,0,0,1,1,1,0,0,0,0,0,1,1,0,0,1,0,1,1,1,0,0,1,1,1,0,0,0,0,0,1,1,0,0,1,1,1,0,0,0,1],
             [0,0,1,1,0,1,1,1,1,1,0,0,0,0,1,1,0,0,1,0,1,0,0,1,1,0,1,1,0,0,1,1,1,1,1,1,0,0,0,1,0,0,1,1,1,0,1,1,1,1,1,1,0,0,0,0,0,1,0,0,1,1,0,0,0,1,0,1,0,0,1,1,0,0,1,1,0,0,1,0,0,1,0,0,1,0,0,1,1,0,1,0,1,0,1,0,1,0,0,0],
             [0,1,1,1,0,1,1,1,0,1,1,1,0,0,0,1,1,0,0,0,1,1,0,0,1,1,1,0,0,1,1,0,1,1,1,0,1,0,0,0,0,0,1,1,0,0,1,1,0,1,0,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0,0,1,1,0,1,0,0,1,1,0,1,0,0,1,1,0,0,1,1,1,1,0,0,1,0,1,0,1,0,1,1,1,1,1],
             [1,0,1,1,1,1,1,0,0,1,1,1,0,1,1,1,0,1,1,0,1,1,0,1,0,0,0,1,0,1,0,1,0,1,0,0,1,0,1,1,1,0,0,0,1,0,0,1,1,0,1,1,1,0,1,0,0,0,1,1,1,1,0,1,0,0,1,0,1,0,0,0,0,0,1,1,1,0,0,1,0,0,1,1,1,1,0,0,1,0,1,0,1,0,0,0,1,1,0,0],
             [0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,1,1,1,1,0,1,1,0,1,0,1,1,1,0,0,1,0,1,0,1,1,0,0,1,0,1,0,0,0,1,1,0,1,1,1,0,1,1,1,0,0,1,0,1,1,0,0,1,0,1,0,1,1,0,0,1,1,0,0,1,0,1,1,0,1,1,1,0,0,1,0,1,0,1,1,1,0,1,1,1],
             [1,1,0,1,1,0,0,0,1,0,1,1,0,0,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,1,1,1,0,0,0,1,1,1,0,1,0,0,1,0,0,1,0,1,1,1,1,1,0,0,1,1,1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,0,1,1,1,1,1,0,1,0,1,0,0,1,0,1,0,1,0,1,1,0,0,1,0,1,0],
             [1,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,1,0,1,0,0,1,1,0,0,0,1,1,1,0,0,1,1,0,0,0,1,1,0,0,0,1,1,1,0,1,0,1,1,1,0,1,0,0,1,0,1,0,1,1,1,0,0,0,1,1,0,0,1,1,0,0,1,0,1,1,1,0,0,0,1,0,1,1,1,1,1,1,1,0,1,0,0,0,1,0,1,0],
             [1,0,1,0,0,0,0,0,1,1,1,1,0,1,0,0,1,0,1,1,0,0,0,1,0,1,1,0,0,0,0,1,1,1,1,1,0,1,1,1,0,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1,0,0,0,1,0,0,0,1,0,1,1,1,0,0,0,0,1,0,0,1,1,1],
             [1,1,0,1,0,1,1,0,0,1,0,1,0,1,1,0,1,0,0,0,0,0,1,1,0,1,0,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0,1,0,1,0,0,1,1,0,1,0,1,1,0,0,0,1,0,0,1,0,1,0,0,0,0,0,1,0,1,1,1,1,0,1,0,0,0,0,0,0,0],
             [1,0,0,1,0,0,1,0,1,0,0,1,0,1,1,1,1,1,1,0,1,1,0,0,1,1,0,1,1,1,1,0,0,0,0,0,1,1,0,1,0,1,1,0,1,0,1,1,1,1,1,1,0,0,1,0,1,0,0,0,0,1,0,1,0,0,0,1,0,1,0,0,1,0,0,1,0,1,0,1,1,1,0,1,0,0,1,0,1,0,1,0,0,1,0,0,0,1,1,1],
             [1,1,1,1,0,0,1,1,1,1,0,1,0,1,0,1,1,1,0,0,0,0,0,1,0,1,0,1,0,1,1,0,0,1,0,1,1,0,1,1,0,1,1,0,1,0,0,1,1,0,0,1,1,0,1,0,1,1,0,0,0,0,0,1,0,1,0,0,1,0,1,1,1,1,0,0,0,0,0,1,1,1,0,1,0,0,1,0,1,1,1,1,0,1,0,1,0,0,1,1],
             [1,1,1,0,1,1,0,0,1,1,0,1,0,1,1,0,0,1,0,0,1,1,0,0,0,1,0,1,1,1,1,1,0,1,1,0,1,0,0,0,0,1,1,0,1,1,1,1,0,1,0,1,1,0,0,0,0,1,0,0,1,1,1,0,1,0,1,0,1,1,0,0,0,1,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,0,1,1,0,1,0,1,0,0,1,0],
             [0,0,0,0,0,0,1,0,0,1,1,1,1,0,0,0,1,1,0,1,1,0,0,0,1,0,1,1,0,1,1,0,0,0,1,1,0,0,1,0,0,1,1,0,1,1,1,0,0,1,0,0,0,1,0,0,1,1,0,0,0,1,0,1,0,0,0,0,1,1,1,0,1,1,1,1,0,0,0,1,0,1,1,0,1,1,1,0,1,0,1,1,0,1,1,1,1,0,1,1],
             [0,0,1,0,0,0,1,1,1,1,1,0,1,0,1,0,0,1,0,1,1,0,0,0,0,1,0,0,1,0,0,0,1,0,0,1,1,1,1,0,0,0,0,0,1,1,1,0,0,0,1,1,0,1,1,1,0,0,0,0,1,0,0,1,0,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,1,0,0,1,0,0,1,0,1,0,0,0,0,0,1],
             [1,1,1,1,1,1,1,0,1,0,1,0,1,1,1,0,1,1,1,0,0,1,1,1,1,1,1,0,1,1,0,0,1,1,1,1,1,0,1,1,0,1,1,1,0,1,1,1,0,0,0,0,1,1,1,1,0,1,0,0,1,1,0,1,1,0,0,0,1,1,1,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,0,0,0,1,1,0,1],
             [1,0,1,0,0,0,1,1,0,1,1,1,0,1,0,1,1,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,1,0,0,1,1,1,1,0,1,0,0,1,1,0,0,0,0,0,1,0,1,1,0,0,1,0,1,1,0,0,0,1,1,0,1,0,0,1,1,0,0,1,0,1,0,1,0,0,0,0,1,1,0,0,0,0,1,1,0,1,0,0,1,0,1,0],
             [0,0,1,0,1,0,1,1,1,1,0,0,0,0,0,1,1,1,0,0,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,0,0,0,1,1,0,1,1,1,1,1,0,0,0,0,0,1,1,0,0,0,1,1,0,0,0,1,1,0,1,1,1,0,0,1,1,1,1,1,1,0,1,1,1,0,0,1,0,0,0,1,1,1,1,0,1,0,0,1,1,1,0,1,1,1],
             [0,1,0,1,1,0,0,0,0,1,0,1,0,1,1,0,0,1,1,0,1,0,1,1,0,1,1,0,0,1,1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,0,0,1,0,1,0,1,0,1,0,0,0,0,0,1,0,1,0,0,1,1,0,1,0,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0],
             [0,0,1,1,1,0,1,1,0,1,1,0,0,1,1,0,0,0,0,1,0,1,1,1,0,0,0,1,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,1,1,1,0,0,0,1,1,0,0,1,1,1,0,1,1,0,0,0,1,1,0,1,1,1,0,1,0,1,0,1,0,1,1,1,0,1,1,1,0,1,0,1,0,0,0,1,1,1,0,0,1,0,0,0],
             [0,1,1,0,1,0,1,0,0,0,1,0,0,0,1,1,0,1,0,1,0,0,0,1,0,0,1,0,0,1,0,1,0,0,0,1,1,0,1,0,1,1,0,0,0,1,1,0,0,1,0,0,0,0,1,0,1,0,0,1,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,0,1,0,1,0,0,0,1,1,1,1,1,1,1,0,1,0,1,1,0],
             [0,0,0,1,1,1,1,0,0,0,0,1,0,1,1,1,0,1,0,0,1,1,1,0,0,1,1,0,0,0,1,1,0,0,1,0,1,0,1,0,1,1,1,0,0,0,1,0,0,1,1,0,1,1,0,1,1,0,0,1,1,0,1,0,0,0,1,0,0,1,0,1,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,1,0,1,1,1,1],
             [0,0,0,0,0,1,1,0,0,1,1,1,0,0,0,1,0,0,0,0,1,0,1,0,1,0,1,0,0,0,1,1,1,0,1,1,1,0,0,0,1,0,1,0,0,0,1,0,1,0,1,1,1,1,0,0,0,0,1,0,0,1,1,1,1,0,0,0,1,1,1,0,0,1,0,0,1,1,1,1,1,1,0,0,1,1,0,1,1,0,0,1,1,1,0,1,1,1,1,1],
             [1,1,1,1,1,0,1,1,0,0,1,0,0,0,0,1,1,1,0,1,1,1,0,0,0,0,1,1,0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,1,0,1,1,1,1,1,0,1,1,0,1,0,1,1,1,1,0,1,0,1,1,0,0,0,1,0,0,1,1,1,0,0,0,1,1,1,0,0,1,1,0,0,0,1,0,1,1,1,0,1,1,1,1,1,0,0],
             [1,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,0,1,1,1,0,1,0,0,1,1,0,0,0,1,0,1,1,0,1,1,1,1,0,1,0,0,0,0,0,1,1,0,0,1,1,1,1,1,0,0,1,1,1,0,0,0,1,1,1,1,1,0,0,0,0,0,1,0,1,0,1],
             [1,1,0,0,1,1,1,1,1,0,1,1,0,1,0,1,1,1,1,1,0,1,0,1,1,0,1,1,0,0,1,0,1,1,0,0,0,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,0,0,0,1,0,1,1,1,0,1,1,0,0,0,1,0,1,1,1,0,1,0,1,0,0,1,0,0,0,0,1,1,0,1,0,0,1,0,0,0,1,0,1,0,1,0],
             [0,1,1,0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,0,1,1,1,1,1,0,0,1,0,0,1,1,0,1,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0,0,1,1,1,1,0,1,0,0,0,1,1,0,0,0,1,0,1,1,1,0,1,0,1,0,0,1,1,0,1],
             [0,1,1,0,1,1,0,1,0,1,1,0,1,0,1,1,0,0,0,1,0,1,0,1,0,0,1,1,0,1,1,0,1,1,1,0,1,0,0,1,1,0,0,1,0,0,0,1,1,1,0,1,1,0,1,1,1,0,1,1,1,1,1,0,1,0,1,1,1,0,0,1,0,0,1,1,1,0,1,0,0,0,1,0,1,1,1,0,1,0,0,0,1,0,0,1,0,1,0,1],
             [0,1,0,0,1,0,0,1,0,1,0,0,1,0,0,1,1,1,0,0,1,0,0,0,0,1,1,1,0,1,1,1,1,0,1,1,0,1,0,1,1,1,0,1,0,1,1,0,1,1,1,0,1,0,1,1,0,1,1,1,0,1,1,1,0,0,0,1,1,1,0,0,0,1,1,1,0,1,0,0,0,1,1,1,1,0,0,0,1,0,1,1,0,1,1,0,1,0,1,0],
             [1,1,1,0,0,1,1,0,0,0,1,1,1,0,0,0,1,0,0,1,1,0,1,0,0,1,0,1,0,0,0,1,1,0,0,0,0,1,1,1,0,1,1,0,1,1,0,0,1,1,1,1,1,0,0,0,0,1,1,1,0,0,1,0,0,1,0,0,0,0,1,0,0,1,1,1,0,1,1,1,0,1,0,0,0,1,0,1,1,0,0,0,1,0,1,0,1,0,0,1],
             [1,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,1,1,0,0,0,1,0,0,1,0,1,1,1,0,1,0,1,1,0,0,1,1,0,0,1,0,1,1,0,0,1,0,1,1,1,0,0,1,1,0,1,1,0,0,0,1,1,1,1,1,0,1,0,0,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,1,1,1,0,0,0,0,1],
             [0,1,1,1,1,0,1,1,1,1,0,0,0,0,1,1,1,0,0,1,1,1,0,1,0,1,1,0,1,1,1,1,0,1,1,0,1,0,0,0,1,1,1,1,0,1,0,1,1,1,0,1,0,0,0,0,0,1,0,0,0,1,1,1,1,0,0,1,1,1,1,1,0,1,1,1,0,0,1,0,1,0,1,1,1,0,1,1,0,1,1,0,0,0,1,1,0,0,1,0],
             [1,1,1,1,0,0,1,1,0,0,0,1,1,0,1,1,1,1,1,1,1,1,0,0,0,1,1,0,0,1,1,1,0,0,1,0,0,1,1,1,0,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,0,1,0,0,0,1,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,1,1,0,0,1,0,1,0,1,0,0,0,0,1,1],
             [1,1,1,0,1,0,0,1,0,0,0,1,1,1,0,1,0,0,1,0,0,1,0,1,1,1,0,0,0,1,1,0,0,1,1,1,0,1,1,0,1,0,1,0,0,0,1,0,0,1,0,0,0,1,1,1,1,0,0,1,1,0,0,0,0,1,0,1,0,0,1,0,0,1,1,0,1,0,1,0,0,0,1,1,1,1,1,0,1,1,1,0,1,0,0,1,0,1,0,1],
             [0,0,0,1,1,0,0,0,0,1,0,1,1,1,0,1,0,1,0,0,1,1,0,0,0,1,1,0,1,1,1,0,1,0,0,1,0,0,1,0,0,0,0,0,0,1,0,0,0,1,0,1,0,0,1,1,1,1,0,1,0,1,1,0,0,1,1,1,1,1,1,0,1,1,1,1,0,1,0,0,0,1,0,0,1,0,0,1,0,0,1,1,0,1,0,1,0,1,1,0],
             [1,1,0,1,1,1,1,0,1,0,0,0,1,0,0,1,0,1,0,1,1,0,0,1,1,0,1,0,1,0,1,1,1,0,0,1,1,0,0,0,1,1,1,1,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,0,1,0,0,0,0,0,0,1,0,1,1,0,1,0,0,0,0,1,1,0,0,0,1,1,1,0,1,0,1,0,0,1,0,0,0,0,0,0,1,1],
             [1,0,0,0,0,0,1,0,0,0,1,1,1,1,1,1,1,0,1,1,0,1,0,0,1,0,1,0,0,0,1,1,1,0,1,0,0,1,0,1,1,1,1,0,0,0,0,1,0,1,0,1,1,0,1,0,1,1,0,0,0,1,1,1,0,0,1,0,0,0,1,0,1,1,1,0,1,1,0,0,1,0,1,1,1,0,0,1,0,1,1,0,0,0,1,1,1,1,1,0],
             [1,1,1,1,1,0,1,1,0,0,0,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,1,0,0,1,1,1,1,1,0,0,1,1,1,1,1,0,0,0,1,1,1,0,0,1,1,0,1,0,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,1,1,0,0,1,0,1,0,0,1,1,0,0,0,1,0,1,1,0,0,0,1,0,1,1,1],
             [0,1,1,0,1,0,0,1,1,1,1,1,1,1,0,1,1,1,0,1,0,1,1,1,1,0,0,0,0,0,1,1,0,0,0,1,0,1,1,0,1,0,1,0,0,1,0,0,0,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,0,1,0,0,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,1,1,0],
             [1,1,0,0,0,1,0,1,0,0,1,0,1,1,0,1,1,1,0,1,0,1,0,1,0,1,1,0,1,1,1,0,1,1,0,0,1,1,0,1,1,0,1,1,0,0,0,1,0,1,0,0,1,1,1,0,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0,0,0,1,1,1,1,1,1,0,1,0,0,1,1,0,0,1,1,1],
             [0,1,0,1,0,1,1,1,0,0,0,0,0,1,0,0,1,1,0,0,1,0,1,0,0,1,1,0,0,1,0,1,1,1,0,0,0,1,1,1,0,1,0,0,1,1,0,0,0,1,0,0,0,1,0,1,1,1,1,1,0,1,0,1,1,1,1,1,0,0,1,1,1,0,1,0,0,1,0,0,0,1,1,0,0,1,0,1,0,0,1,0,0,1,1,1,1,0,0,0],
             [0,1,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,1,1,1,1,0,1,1,1,0,0,0,0,1,1,0,1,1,1,0,0,0,0,0,1,1,1,0,1,1,0,0,0,0,0,0,0,0,1,0,1,1,1,0,1,1,0,0,1,0,0,1,0,1,1,1,1,1,1,1,0,1,0,1,1,1,1,1,1,0,0,1,1,0,0,1,1,1,0,0,0,0,0],
             [0,0,1,1,0,1,0,1,0,0,1,0,1,1,0,0,0,1,0,1,1,1,0,1,1,1,0,0,0,1,1,1,1,1,1,0,0,1,0,0,1,0,1,0,0,1,0,0,0,0,1,1,1,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,1,1,0,1,1,0,1,0,0,1,1,0,0,1,0,1,1,1,1,1,0],
             [1,1,1,0,1,1,1,0,1,0,0,1,0,1,1,0,0,1,1,0,1,0,0,1,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,0,1,0,0,1,0,1,0,1,0,1,1,1,1,0,1,1,1,0,0,1,1,1,0,1,0,1,0,0,1,0,1,1,0,1,1,0,1,1,1,1,0,1,1,1,0,1,1,1,1],
             [1,0,1,0,1,0,0,1,0,0,0,0,1,1,1,1,1,1,1,1,0,1,0,0,1,0,0,1,0,0,0,1,1,0,0,1,0,1,1,0,0,1,0,1,0,0,1,1,0,0,1,1,1,1,0,0,0,1,1,0,0,0,0,0,1,0,1,1,0,1,0,1,0,0,0,1,1,1,1,1,1,1,1,0,0,1,0,1,1,1,0,1,0,0,1,0,1,0,1,1],
             [0,1,1,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,1,0,1,1,0,0,0,0,1,1,1,0,0,0,1,1,0,0,1,0,1,1,1,1,0,0,0,1,0,0,1,0,1,0,0,1,0,0,1,0,1,1,0,0,1,0,1,1,1,0,1,1,0,1,1,1,1,0,1,1,0,0,1,1,1,1,0,0,0,0,0,1,1,0,1,0,0,0,0,0,1],
             [0,0,0,0,1,1,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,0,1,1,0,1,0,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,1,0,0,1,1,1,0,1,0,1,0,0,1,0,0,1,1,0,1,0,1,0,0,0,0,0,1,1,0,1,1,1,1,1,0,1,0,1,1,1,1,0,0,0,1,0,1,0],
             [1,0,0,1,1,1,1,1,0,1,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,1,1,1,1,1,1,0,0,1,1,0,0,0,0,1,0,0,1,0,1,0,1,1,1,0,1,1,1,1,1,0,0,0,0,0,1,1,0,1,1,0,1,1,1,1,0,1,0,0,0,1,1,0,0,0,1,0,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1,0,0,0],
             [1,1,0,1,1,1,1,0,0,1,1,1,0,1,0,0,0,0,1,0,0,0,1,0,1,0,1,0,1,0,1,1,1,0,1,1,1,1,1,0,1,0,1,1,1,1,0,0,1,1,1,1,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,0,0,1,0,0,1,0,0,1,0,1,0,1,1,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,1,0,0,0],
             [0,1,1,1,0,1,0,1,0,1,0,1,0,0,1,1,1,1,0,1,1,0,1,0,0,1,1,1,1,1,1,0,0,1,0,1,0,1,1,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,1,1,1,1,0,1,1,0,0,0,1,1,0,1,1,1,1,1,0,1,0,1,1,0,0,1,1,0,0,1,0,0,1,0,1,0,0],
             [0,0,0,0,0,1,1,1,0,0,0,1,0,0,0,1,0,1,1,1,1,0,1,1,1,0,1,0,1,0,1,0,1,0,0,0,0,0,1,0,0,0,0,1,0,1,1,1,1,0,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,0,0,0,0,0,0,1,0,1,1,1,1,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0],
             [1,1,0,0,1,0,0,1,0,1,0,1,1,0,0,1,0,0,0,1,0,0,1,1,0,1,1,0,1,1,0,0,1,1,1,0,1,0,0,0,0,1,1,0,1,1,0,0,0,0,1,1,1,1,0,1,0,1,1,0,1,1,1,0,0,0,0,1,0,1,1,0,1,0,1,0,1,1,0,0,0,1,1,0,1,1,1,0,0,0,1,0,0,1,0,0,1,1,1,1],
             [0,0,0,1,0,1,0,0,1,1,0,0,1,1,0,1,0,0,0,1,1,0,1,1,0,0,0,1,0,1,0,0,0,0,0,0,1,0,1,0,1,1,0,0,1,1,1,0,0,0,0,1,1,1,1,0,1,1,0,0,0,1,0,1,0,1,1,1,0,1,0,0,1,0,0,1,0,1,1,1,1,0,0,1,1,0,0,1,1,0,0,1,1,1,1,1,0,1,1,1],
             [0,1,1,0,1,1,0,0,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,1,0,1,1,0,1,1,1,1,0,1,0,1,1,1,1,1,1,1,0,1,1,0,1,0,1,1,0,1,1,0,0,1,0,0,0,1,1,0,0,0,0,1,1,1,1,1,1,1,1,0,1,1,1,0,0,1,1,0,1,1,0,1,1,0,1,0,0,1,1,0,1,0,1,0,1],
             [1,1,1,1,1,0,1,0,0,0,0,1,0,1,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,1,1,0,1,1,0,0,1,0,1,1,0,1,1,1,0,0,1,1,0,0,0,0,0,0,0,1,1,1,0,0,1,1,0,1,0,1,1,1,0,1,1,0,1,1,1,0,0,0,0,1,1,1,1,0,1,0,0,1,0,1,1,1,0,0,1,0,1,0,1],
             [0,1,0,0,0,1,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,1,0,0,0,1,1,1,1,0,0,0,0,1,0,0,0,1,0,0,1,0,0,0,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,0,1,1,1,0,1,0,0,1,1,0,1,0,1,0,1,1,0,0,1,1,1,0,0,1,0,1,0,1,1,1,0,0,0,0,0,1,1,0,1],
             [1,1,0,0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,0,0,1,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,1,1,0,1,0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,0,1,0,1,0,0,1,0,1,1,1,0,1,0,0,0,1,0,0,0,1,0,0,1,1,0,1,1,0,0,0,1,0,0,1,1,1,1,1,1,1],
             [0,0,0,0,0,1,1,0,0,1,1,1,0,0,1,1,0,0,0,1,1,1,1,1,0,1,0,1,0,0,0,0,0,1,1,1,0,1,0,1,0,0,1,1,1,1,0,0,0,1,0,1,0,1,0,0,1,0,0,1,1,1,1,0,0,1,1,0,1,0,0,1,1,1,0,1,1,1,1,0,1,0,0,0,0,1,1,0,0,1,1,1,0,0,0,0,1,0,0,1],
             [1,0,1,0,1,1,0,1,0,0,0,0,1,0,1,1,1,1,1,0,1,0,0,0,0,1,1,0,0,0,1,0,0,0,1,1,0,0,0,1,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,1,0,0,0,1,1,1,0,1,1,1,0,1,0,1,1,1,1,0,0,1,1,1,1,0,0,0,0,1,0,1,1,0,1,0,1,0],
             [0,0,1,1,0,0,0,1,1,0,0,1,1,1,0,1,0,1,0,1,1,0,1,0,0,1,0,0,0,0,1,0,1,0,0,0,0,0,1,1,0,1,1,1,0,1,0,1,1,1,0,1,1,1,0,0,0,0,0,1,0,0,0,1,0,1,0,0,1,1,1,1,1,1,1,0,1,1,1,1,1,0,0,1,0,1,1,1,0,0,0,1,1,0,0,0,0,0,0,1],
             [1,0,0,0,0,0,0,1,1,1,0,0,1,0,0,0,0,1,0,1,0,0,1,0,1,1,1,0,1,1,0,1,0,0,0,1,1,0,0,1,1,1,0,1,1,1,1,0,1,0,1,0,0,0,0,1,0,1,1,0,0,1,0,1,1,1,0,0,1,1,0,1,0,0,1,1,1,1,1,0,0,1,1,0,1,1,1,0,0,0,0,0,1,0,0,1,1,1,0,0],
             [1,1,0,1,0,1,1,0,0,1,1,0,1,1,1,0,1,0,0,1,1,0,0,0,0,0,1,0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,1,1,0,1,1,1,1,0,1,1,1,1,1,1,0,1,0,0,0,1,0,0,1,1,1,0,0,0,0,1,0,1,0,0,0,1,0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,1,0,1,0],
             [0,1,1,0,1,0,1,0,1,0,1,1,0,0,1,0,1,0,1,0,0,1,1,0,0,1,0,1,1,1,0,1,1,1,1,0,0,0,0,1,0,0,1,1,1,0,1,1,1,1,1,1,0,0,1,1,1,1,0,1,0,0,0,0,0,1,1,1,0,1,1,0,0,1,0,0,0,1,1,1,0,1,0,0,1,1,1,1,1,1,0,1,1,0,1,0,1,1,0,0],
             [0,0,0,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,1,0,1,1,0,1,0,0,0,1,1,0,0,1,0,0,1,0,0,0,1,0,1,0,1,0,1,1,1,1,1,0,0,0,1,0,0,0,0,1,0,0,1,1,1,0,0,0,1,0,0,1,0,0,0,0,1,0,1,0,1,1,0,1,0,1,1,1,1,1,1,0,1,0,0,1,1,1,1],
             [0,0,1,0,1,0,1,0,1,0,0,0,1,0,1,1,1,1,1,1,0,1,0,0,0,0,0,1,0,0,1,0,1,0,0,1,1,1,0,0,0,0,1,0,1,0,1,1,1,1,1,1,1,1,0,0,0,1,0,0,0,0,1,0,1,0,1,1,0,0,1,0,0,0,1,1,0,0,0,1,0,1,0,0,1,0,1,0,1,1,1,0,0,0,0,1,1,0,0,0],
             [1,1,1,1,1,0,0,1,0,0,1,1,0,0,1,0,0,1,1,0,0,1,0,0,1,0,1,0,1,1,0,1,0,0,0,0,1,1,1,1,1,0,1,1,1,1,0,1,1,0,1,0,1,1,1,0,0,1,1,0,0,1,1,0,0,0,0,1,0,0,0,0,0,1,0,1,1,1,1,1,0,1,0,0,0,1,0,1,1,1,1,1,0,1,1,0,1,0,1,0],
             [1,0,1,0,0,1,1,1,1,1,0,0,0,1,1,1,1,0,1,1,1,0,1,1,1,0,0,0,0,0,1,1,1,1,0,1,1,1,0,0,0,0,0,1,1,0,0,0,1,1,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,0,1,0,1,1,0,0,0,0,1,1,0,0,1,1,1,1,0,0,0,0,0,1,1,0,0,0,1,0,0,1,0,0,1],
             [1,0,1,0,1,1,1,0,1,0,1,0,0,1,1,0,0,1,0,0,0,0,1,0,1,0,0,0,1,0,1,0,1,1,0,1,1,0,0,1,0,1,1,0,0,0,0,0,1,1,0,0,0,1,0,1,0,0,1,1,0,0,0,0,0,0,0,1,1,0,1,0,1,1,1,0,0,1,1,1,1,1,0,1,0,1,1,0,0,0,0,1,0,1,1,0,0,0,0,0],
             [0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1,0,1,1,1,1,0,1,0,1,1,1,0,1,1,1,0,0,1,0,0,0,0,1,0,0,1,1,0,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,1,0,1,1,0,0,1,0,0,0,1,0,1,0,0,0,1,1,1,0,1,0,0,1,0,1,0,1,0,0,0,1,0,0,0,1,0,0],
             [0,0,0,1,1,0,1,1,1,1,1,0,1,1,0,1,0,1,1,1,0,1,1,0,1,1,0,1,0,1,1,0,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,0,1,1,0,0,0,1,1,0,1,0,1,0,0,1,0,0,1,1,0,1,1,0,1,1,1,1,1,0,1,0,1,1,1,0,0,0,1,1,1,1,1,0,0,1,0,0,1,0],
             [1,1,1,1,1,1,1,0,1,0,0,1,0,0,1,0,0,0,0,1,1,0,1,0,1,0,0,1,1,1,1,0,1,0,0,1,0,0,1,1,1,0,0,0,1,0,0,1,0,0,0,0,0,0,0,1,1,1,0,1,0,1,0,1,1,1,1,0,0,0,0,1,0,1,1,1,0,0,0,1,0,1,0,1,1,1,0,1,0,1,0,1,0,1,0,0,1,1,1,0],
             [0,0,1,1,0,1,1,0,1,0,1,1,0,1,1,1,0,0,0,0,1,1,1,0,1,1,0,1,0,1,1,1,0,1,0,0,0,1,0,0,0,0,1,0,1,1,1,1,0,0,1,1,1,0,0,1,1,1,0,1,0,1,0,0,1,0,0,0,1,1,0,1,0,1,0,1,0,0,1,1,0,1,1,1,0,0,1,1,1,0,1,0,1,1,0,0,0,1,1,1],
             [1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,0,0,1,1,0,1,0,1,0,1,1,0,1,1,0,1,0,0,1,1,0,0,1,0,1,0,1,0,1,1,0,0,1,0,1,0,0,0,1,0,0,0,1,0,1,0,1,0,0,1,1,1,1,1,1,0,1,0,0,1,0,1,0,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,1,1,0,1],
             [1,0,1,1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0,1,1,0,0,0,1,0,0,0,1,1,0,1,0,1,0,0,1,0,0,0,1,1,1,1,1,0,0,0,1,0,0,0,1,0,0,1,0,1,1,1,0,1,0,0,1,0,1,0,0,0,1,1,1,0,1,0,1,0,1,0,0,0,1,0],
             [1,0,0,0,0,1,1,0,0,0,0,1,1,1,0,0,0,1,1,0,1,1,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,0,0,1,0,1,0,1,1,0,1,0,1,1,1,1,1,1,0,1,1,1,1,1,0,0,1,0,0,1,1,1,0,1,1,1,0,1,0,0,0,1,0,1,0,1,1,0,1,1,1,1,1,1,0,0,0],
             [1,0,1,0,0,0,1,1,1,0,1,0,1,1,1,0,1,1,0,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,0,1,1,0,0,1,0,1,0,1,0,0,0,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1,1,0,0,1,0,1,0,1,0,1,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,1],
             [0,0,1,1,1,0,0,1,1,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,1,0,1,0,1,1,1,0,1,0,1,0,0,0,0,0,1,1,0,1,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,0,1,0,0,0,1,1,0,0,1,1,0,1,0,1,0,1,1,1,1,0,0,1,1,1,0,0,0,1,1,1,1,1,1,0,0,0,0,1,0,1],
             [0,0,1,1,1,0,1,0,1,1,0,1,1,1,1,0,1,0,0,1,0,1,1,0,0,0,0,1,1,0,0,1,1,1,1,1,0,0,0,0,1,0,0,1,1,0,1,1,0,1,0,0,1,1,1,1,1,1,1,0,0,0,1,0,1,1,1,1,0,0,0,1,1,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1],
             [0,1,1,0,1,0,0,0,1,0,1,1,1,1,0,0,1,0,1,0,0,0,1,0,1,1,0,0,1,1,1,1,1,1,0,1,1,0,0,1,1,0,1,0,1,1,1,0,1,1,0,0,1,1,1,0,1,1,1,0,0,0,0,1,1,0,0,1,0,1,1,0,1,1,0,0,1,1,0,1,0,0,0,1,1,1,0,1,1,0,1,1,0,1,1,1,0,0,0,0],
             [1,0,0,0,1,1,1,0,1,1,1,0,1,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,1,1,0,0,1,0,1,1,1,0,1,1,0,1,1,0,0,0,0,1,0,1,1,1,1,0,1,0,1,1,1,1,0,1,1,0,0,1,1,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,1,0,1,0,1,0],
             [0,1,1,0,1,0,0,1,0,0,1,0,1,1,0,0,0,0,0,0,0,1,0,1,1,1,1,0,1,1,1,1,1,1,1,0,0,0,0,0,1,0,1,1,0,1,1,0,1,0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,1,1,1,1,1,1,0,1,0,0,1,1,1,0,1,1,0,1,1,0,0,0,0,0,1,0,1,1,1,1,0,0,1,1,0,1],
             [1,1,1,0,0,1,0,1,1,1,0,1,0,0,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,1,0,0,1,1,1,1,0,0,0,0,1,0,1,1,0,1,1,0,0,1,0,0,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,0,0,0,1,0,1,0,0,0,0,1,1,0,0,0,1,1,1,0,1,0,0,1,0,1,1,0,0,0,1,0],
             [1,0,0,1,1,1,0,0,1,1,0,0,1,0,1,0,1,1,0,1,1,1,0,1,0,1,0,1,1,0,0,0,1,1,1,0,1,0,0,0,1,1,0,1,1,0,0,1,0,1,1,1,0,0,0,0,1,1,1,0,0,1,0,1,0,0,0,1,0,1,1,1,0,0,1,1,1,1,1,1,0,1,0,0,1,0,1,1,1,0,0,1,0,0,1,0,0,1,0,1],
             [0,1,0,0,0,0,0,0,0,0,1,1,0,1,0,1,1,1,0,0,1,1,1,0,1,0,1,0,1,1,0,0,0,0,0,1,1,0,1,1,0,1,0,1,0,0,0,1,1,0,0,1,0,1,1,0,0,0,0,1,1,1,0,0,1,0,1,0,1,0,1,0,1,1,0,0,0,0,1,0,1,1,0,0,1,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0],
             [1,1,1,1,0,1,1,1,1,0,0,1,0,0,0,0,1,0,1,0,1,0,0,1,0,0,1,1,0,0,0,0,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,1,0,1,1,0,0,1,0,1,0,1,1,0,1,0,0,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,0,1,0,1,1,0,0,1,0,0,0,1,0,0,0,0,0,1],
             [0,0,1,0,0,1,0,0,1,1,1,0,0,1,1,0,1,1,0,0,1,1,1,1,1,1,0,1,0,0,1,1,1,0,0,1,1,1,0,1,0,1,1,0,0,1,1,0,1,0,0,1,1,1,1,1,0,1,0,1,0,1,0,1,1,0,0,1,0,1,1,0,0,1,1,0,1,1,0,0,0,0,0,0,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0],
             [0,0,0,1,1,0,1,1,0,0,1,1,1,0,1,0,0,0,1,1,1,0,0,0,0,1,0,1,0,1,0,1,0,0,0,0,0,1,0,1,1,0,0,0,0,0,1,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1,1,1,1,0,0,0,1,1,0,1,1,0,0,0,0,1,1,0,1,0,0,1,0,1,1,1,1,0,1,0,0,1,1,1,0,1,0],
             [0,0,1,0,0,0,0,0,1,1,1,1,0,1,0,1,1,1,0,1,1,1,1,1,0,0,1,0,0,1,1,1,0,0,1,0,0,1,0,1,0,0,0,1,1,1,1,1,0,0,0,1,1,1,0,1,1,1,0,0,0,0,1,0,1,1,1,0,0,1,0,0,0,1,0,0,1,0,0,1,0,1,0,0,1,0,1,1,0,0,1,1,0,1,0,1,0,0,0,0],
             [0,0,1,1,0,1,1,1,1,1,0,0,0,1,1,1,0,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,0,1,1,1,1,0,1,1,0,0,1,0,1,0,0,1,0,1,0,0,0,1,0,0,0,1,1,0,1,1,0,1,1,0,0,1,0,1,0,1,1,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,0],
             [0,0,0,1,1,1,0,1,0,1,0,0,1,0,0,0,1,0,1,1,1,0,1,1,1,0,0,0,0,0,0,0,1,1,0,1,1,1,0,1,0,0,1,0,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,1,0,1,0,1,0,1,1,0,1,0,1,1,1,0,0,0,1,1,1,1,1,1,0,0,1,0,1,0,0,0,1,1,1,0,1,1,0,0,0],
             [0,1,0,1,0,1,1,1,1,1,1,1,0,1,0,0,1,1,0,1,1,0,0,1,1,0,0,0,1,0,0,0,1,1,1,1,0,0,0,1,0,0,1,1,1,1,1,0,1,0,0,1,1,0,0,0,1,1,1,0,1,0,1,0,0,0,1,0,1,1,0,0,0,1,0,0,0,0,0,0,1,0,0,1,1,0,1,1,1,1,0,0,1,0,0,0,0,0,1,1],
             [0,1,1,0,1,1,0,1,0,1,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,1,1,1,0,0,0,0,0,1,1,0,1,0,1,1,0,0,1,1,1,0,0,0,0,0,0,1,0,0,0,0,1,1,1,1,0,0,0,1,0,1,1,1,0,1,0,1,1,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,1,0,0,0,0,0,1,1],
             [1,0,0,0,1,0,1,1,1,0,1,0,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,0,1,0,0,0,1,0,1,1,1,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,0,1,0,1,0,1,0,1,1,0,0,0,1,0,1,0,0,1,1,1,1,1,0,1,0,1,0,0,1,0,0,1,0,0,1,0,0,0,0,1,0,0,0,1,1,1,1],
             [0,0,0,0,0,1,1,0,0,0,1,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,1,1,0,1,1,0,1,1,0,0,0,1,1,0,1,0,1,1,1,1,1,0,0,1,1,0,0,0,1,0,1,0,1,0,1,0,1,1,1,0,0,0,1,1,1,0,1,1,0,1,1,1,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,1,1,1,0,1,1],
             [1,0,0,1,0,0,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,1,0,1,0,0,1,1,1,0,0,0,0,1,1,1,0,1,1,0,1,0,1,1,0,1,0,0,0,1,0,1,0,0,1,0,0,0,1,0,0,0,0,1,1,1,0,1,0,0,1,0,1,0,1,1,1,1,1,1,0,1,0,0,0,1,1,1,1,0,0,1,0,0,1,1,0,1,0,1],
             [1,0,0,1,0,1,0,0,1,0,0,0,1,1,1,0,1,0,0,1,1,0,1,0,0,0,1,0,0,0,1,1,0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,1,1,1,1,0,0,1,1,0,0,0,0,0,1,0,1,1,1,0,0,0,1,0,1,0,0,1,0,1,0,0,0,0,1,0,1,1,1,1,1,0,1,1,0,1,1,1,0,0,0],
             [1,1,1,0,0,0,0,1,0,1,0,0,1,0,1,0,0,1,1,1,0,0,1,0,1,1,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,1,1,0,1,0,0,1,1,1,0,0,1,1,0,0,1,0,0,1,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,1,1,1,1,0,0,1,1,0,1,0,1,1,0,1,0,1,0,1,0,0,0,1,0],
             [0,1,0,1,0,1,1,0,1,1,0,1,1,1,0,0,1,0,0,0,1,0,1,0,0,0,0,1,0,0,1,0,1,1,0,0,1,0,1,0,1,0,1,0,1,1,0,1,1,0,1,1,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,0,0,1,1,1,1,0,1,1,1,1,1,0,0,1,0,1,1,0,1,0,1,1,0]]
