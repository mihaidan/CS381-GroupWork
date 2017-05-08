-- CS381 Assignment 3
--
-- Mihai Dan
-- Braden Ackles
-- Pranav Ramesh
-- Sophia Liu
-- Juan Ramirez

module A3 where

import Data.Maybe
import Data.List

{--- Ex.1 ---}
-- Syntax
type Prog = [Cmd]

data Cmd = LD Int
         | ADD
         | MULT
         | DUP
         | INC
         | SWAP
         | POP Int
         deriving Show

{-- (a) --}
--Semantic Domain
type Rank    = Int
type CmdRank = (Int, Int)
type Stack   = [Int]

--Semantics
{--rankC assigns the appropriate command rank to 
   each operation.--}
rankC :: Cmd -> CmdRank
rankC (LD x)  = (0,1)
rankC ADD     = (2,1)
rankC MULT    = (2,1)
rankC DUP     = (1,2)
rankC INC     = (1,1)
rankC SWAP    = (2,2)
rankC (POP x) = (x,0)

{-- rankP checks if the first command on the stack is
    LD (if statement checking if the first integer
    from rankCmd is 0). If it is, then continue to
    the rank function, otherwise, return Nothing. --}
rankP :: Prog -> Maybe Rank
rankP []         = Just 0
rankP (com:list) = if(n /= 0)
                      then Nothing
                      else rank list (m - n)
                      where (n,m) = rankC com

{-- rank checks if the list is empty (meaning there
    was only one LD operation) and returns that rank.
    Then, it recursively cycles through the rest of the
    list, updating r (rank) appropriately. --}
rank :: Prog -> Rank -> Maybe Rank
rank [] r         = Just r
rank (com:list) r = if(r - n < 0)
                       then Nothing
                       else rank list (m - n + r)
                       where (n,m) = rankC com

--Tests
test1 = rankP [LD 1, LD 1, LD 1] --Just 3
test2 = rankP [LD 1, LD 2, ADD]  --Just 1
test3 = rankP [LD 1, POP 2]      --Nothing
test4 = rankP [LD 1, SWAP]       --Nothing

{-- (b) --}
sem :: Prog -> Stack -> Stack
sem [] stk         = stk
sem (com:list) stk = sem list (semCmd com stk)

{-- semCmd is the semantics function for each individual
    command. More detailed stack manipulation explanations
    can be found in the comments below. --}
semCmd :: Cmd -> Stack -> Stack
-- Adds the given integer to the stack.
semCmd (LD i) stk    = stk ++ [i]
-- Pops the first two items off and places their sum on the stack.
semCmd ADD stk       = (init(init stk)) ++ [last stk + last(init stk)]
-- Pops the first two items off, multiplies them and places the result on the stack.
semCmd MULT stk      = (init(init stk)) ++ [last stk * last(init stk)]
-- Adds a copy of the last item to the stack.
semCmd DUP stk       = stk ++ [(last stk)]
-- Pops off the first item on the stack and increments it by one.
semCmd INC stk       = (init stk) ++ [(last stk)+1]
-- Takes stack-last two items, adds last item, then adds second to last.
semCmd SWAP stk      = init(init stk) ++ [last stk] ++ [last(init stk)]
-- Takes the (length - x) from the stack.
semCmd (POP num) stk = take ((length stk)-num) stk

{-- Same idea as the TypeChecker on the in-class exercise. --}
semStatTC :: Prog -> Maybe Stack
semStatTC prgm | rankP prgm /= Nothing = Just (sem prgm [])
               | otherwise             = Nothing

--Tests
t1 = semStatTC [LD 1, LD 1, LD 1] -- Just [1,1,1]
t2 = semStatTC [LD 1, LD 2, ADD]  -- Just [3]
t3 = semStatTC [LD 1, POP 2]      --Nothing
t4 = semStatTC [LD 1, SWAP]       --Nothing



{--- Ex.2 ---}
--Syntax
data Shape = X
           | TD Shape Shape
           | LR Shape Shape
           deriving (Eq, Show)

--Semantic Domain
type BBox = (Int, Int)

{-- (a) --}
-- Define a type checker for the shape language as a Haskell function.
bbox :: Shape -> BBox
{-- In case of X, set it equal to 1,1. --}
bbox X              = (1,1)
{-- In case of TopDown, get the maximum x variable between
    the two shapes, and add the y variables. x1/y1 correspond
    to the coordinates of the first shape, while x2/y2
    correspond to the coordinates of the second shape. --}
bbox (TD shp1 shp2) = (max x1 x2, y1+y2)
                        where (x1,y1) = bbox shp1
                              (x2,y2) = bbox shp2
{-- In case of LeftRight, get the maximum y variable between
    the two shapes, and add the x variables. x1/y1 correspond
    to the coordinates of the first shape, while x2/y2
    correspond to the coordinates of the second shape. --}
bbox (LR shp1 shp2) = (x1+x2, max y1 y2)
                        where (x1,y1) = bbox shp1
                              (x2,y2) = bbox shp2

--Tests
tbox1 = bbox (LR (TD X X) X)          --(2,2)
tbox2 = bbox (TD X (LR X X))          --(2,2)
tbox3 = bbox (TD (TD (LR X X) X) X)   --(2,3)

{-- (b) --}
-- Define a type checker for the shape language that assigns types
-- only to rectangular shapes by defining a Haskell function.
{-- DIFFERENCE BETWEEN bbox AND rect:
    The only difference between part (a) and part (b)
    is the check prior to calculation. For TD, it makes
    sure that the x variables of the two shapes are the
    same, otherwise it will return Nothing. For LR, it
    makes sure that the y variables of the two shapes
    are the same, otherwise, it returns Nothing. These
    checks make sure that the returned BBox is a rectangle.--}
rect :: Shape -> Maybe BBox
{-- In case of X, set it equal to 1,1. --}
rect X              = Just (1,1)
{-- In case of TopDown, get the maximum x variable between
    the two shapes, and add the y variables. x1/y1 correspond
    to the coordinates of the first shape, while x2/y2
    correspond to the coordinates of the second shape. --}
rect (TD shp1 shp2) | x1==x2    = Just (x1, y1+y2)
                    | otherwise = Nothing
                      where Just (x1,y1) = rect shp1
                            Just (x2,y2) = rect shp2
{-- In case of LeftRight, get the maximum y variable between
    the two shapes, and add the x variables. x1/y1 correspond
    to the coordinates of the first shape, while x2/y2
    correspond to the coordinates of the second shape. --}
rect (LR shp1 shp2) | y1==y2    = Just (x1+x2, y1)
                    | otherwise = Nothing
                      where Just (x1,y1) = rect shp1
                            Just (x2,y2) = rect shp2
--Tests
trect1 = rect (TD (TD X X) X)        --Just (1,3)
trect2 = rect (LR X (TD X (TD X X))) --Nothing
trect3 = rect (TD X (LR X X))        --Nothing



{--- Ex.3 ---}
f x y = if null x then [y] else x
g x y = if not (null x) then [] else [y]

{-- (a) --}
{--
(1) What are the types of f and g?
Type of f: [t] -> t -> [t]
Type of g: [a] -> t -> [t]

(2) Explain why the functions have these types.
(3) Which type is more general?
(4) Why do f and g have different types?
--}

{-- (b) --}
--Find a (simple) definition for a function h that has the following type.
--h :: [b] -> [(a,b)] -> [b]

{-- (c) --}
--Find a (simple) definition for a function k that has the following type.
--k :: (a->b) -> ((a->b)->a)->b

{-- (d) --}
-- Can you define a function of type a -> b? If yes, explain your definition. 
-- If not, explain why it is so difficult.
--l :: a -> b