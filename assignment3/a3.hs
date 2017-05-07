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
rankP []          = Just 0
rankP (com:list) = if(n /= 0)
                      then Nothing
                      else rank list (m - n)
                      where (n,m) = rankC com

{-- rank checks if the list is empty (meaning there
    was only one LD operation) and returns that rank.
    Then, it recursively cycles through the rest of the
    list, updating r (rank) appropriately. --}
rank :: Prog -> Rank -> Maybe Rank
rank [] r          = Just r
rank (com:list) r = if(r - n < 0)
                       then Nothing
                       else rank list (m - n + r)
                       where (n,m) = rankC com

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

semStatTC :: Prog -> Maybe Stack
semStatTC prgm | rankP prgm /= Nothing = Just (sem prgm [])
               | otherwise             = Nothing

t1 = semStatTC [LD 1, LD 1, LD 1] -- Just [1,1,1]
t2 = semStatTC [LD 1, LD 2, ADD]  -- Just [3]
t3 = semStatTC [LD 1, POP 2]      --Nothing
t4 = semStatTC [LD 1, SWAP]       --Nothing



{--- Ex.2 ---}
--Syntax
data Shape = X
           | TD Shape Shape
           | LR Shape Shape
           deriving Show

--Semantic Domain
type BBox = (Int, Int)

{-- (a) --}
-- Define a type checker for the shape language as a Haskell function.
--bbox :: Shape -> BBox

{-- (b) --}
-- Define a type checker for the shape language that assigns types
-- only to rectangular shapes by defining a Haskell function.
--rect :: Shape -> Maybe BBox



{--- Ex.3 ---}
f x y = if null x then [y] else x
g x y = if not (null x) then [] else [y]

{-- (a) --}
{--
(1) What are the types of f and g?
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