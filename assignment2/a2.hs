-- CS381 Assignment 2
--
-- Mihai Dan
-- Braden Ackles
-- Pranav Ramesh
-- Sophia Liu
-- Juan Ramirez

module A2 where

import Data.Maybe
import Data.List

{-- Ex.1 --}
-- Syntax
type Prog = [Cmd]

data Cmd = LD Int
         | ADD
         | MULT
         | DUP
         deriving Show


-- Semantic Domain
type Stack = [Int]
type D = Maybe Stack -> Maybe Stack


-- Semantics for Prog
-- sem :: Prog -> Stack -> Stack
sem :: Prog -> D
-- Base case - list being empty.
sem [] stk = stk
-- Iterating through the list and evaluating it
-- using the semCmd function.
sem (item:list) stk = sem list (semCmd item stk)


-- Semantics for Cmd
-- semCmd :: Cmd -> Stack -> Stack
semCmd :: Cmd -> D
-- Loading an integer to the stack.
semCmd (LD i)  stk = case stk of Just stk -> Just ([i] ++ stk)
                                 _        -> Nothing
-- Taking the topmost two integers and adding them.
-- If not, return nothing. 
semCmd (ADD)   stk = case stk of Just (x1:x2:stk) -> Just ([x1+x2] ++ stk)
                                 _                -> Nothing
-- Taking the topmost two integers and multiplying them.
-- If not, return nothing. 
semCmd (MULT)  stk = case stk of Just (x1:x2:stk) -> Just ([x1*x2] ++ stk)
                                 _                -> Nothing
-- Adding a copy of the topmost integer to the stack.
semCmd (DUP)   stk = case stk of Just (x1:stk) -> Just ([x1,x1] ++ stk)
                                 _             -> Nothing

-- Evaluation function.
evaluate :: Prog -> Maybe Stack
evaluate p = sem p (Just [])

-- Test values.
test1 = [LD 3, DUP, ADD, DUP, MULT]             -- Just [36]
test2 = [LD 3, ADD]                             -- Nothing
test3 = []                                      -- Just []
test4 = [LD 5, LD 4, MULT, LD 3, ADD, DUP, ADD] -- Just [46]
test5 = [LD 3, MULT]                            -- Nothing



{-- Ex.2 (a) --}
type Prog2 = [Cmd2]

data Cmd2 = LD2 Int
          | ADD2
          | MULT2
          | DUP2
          | DEF String Prog2
          | CALL String
          deriving Show


{-- Ex.2 (b) --}
type Macros = [(String, Prog2)]
type State2 = (Stack, Macros)

type W = State2 -> State2

{-- Ex.2 (c) --}
-- sem :: Prog -> State2 -> State2
sem2 :: Prog2 -> W
-- Base case - list being empty.
sem2 [] stt = stt
-- Iterating through the list and evaluating it
-- using the semCmd function.
sem2 (item:list) stt = sem2 list (semCmd2 item stt)

-- semCmd2 :: Cmd2 -> State2 -> State2
semCmd2 :: Cmd2 -> W
-- Loading adds an integer to the stack.
semCmd2 (LD2 i) (stk, mac) = ([i] ++ stk, mac)
-- Pops the first two items off and places their sum on the stack.
semCmd2 ADD2    (stk, mac) = ([last stk + last(init stk)] ++ (init(init stk)), mac)
-- Pops the first two items off, multiplies them and places the result on the stack.
semCmd2 MULT2   (stk, mac) = ([last stk * last(init stk)] ++ (init(init stk)), mac)
-- Adds the last item back on the stack.
semCmd2 DUP2    (stk, mac) = (([(last stk)] ++ stk), mac)
-- Defines a program and adds it to the list of macros.
semCmd2 (DEF name prog)  (stk, mac) = (stk, mac ++ [(name, prog)])
-- Calls a function if it exists.
semCmd2 (CALL name)      (stk, mac) = sem2 (findFunction name mac) (stk, mac)

{-- Function to check if the function exists. --}
findFunction :: String -> Macros -> Prog2
findFunction name mac = find3 (find2 name mac) mac

{-- Takes the list of macros and the index derived from the
    find2 function. The fromJust turns the Maybe Int into a
    regular Int, which is needed for !!. --}
find3 :: Maybe Int -> Macros -> Prog2
find3 i mac = snd (mac !! fromJust(i))

{-- findIndex takes the first element in the list that matches
    the 'name' string passed from findFunction. It returns the
    integer value of the index, assuming it finds a match. --}
find2 :: String -> Macros -> Maybe Int
find2 name mac = findIndex (\c -> fst c == name) mac

{-- Testing --}
mac1 :: Macros
mac1 = [("macro1", [LD2 3, DUP2, ADD2, DUP2, MULT2])]

state1 = ([1,2,3,4], mac1)

tst1 = semCmd2 (CALL "macro1") state1
tst2 = semCmd2 (DEF "macro2" [LD2 3, DUP2, ADD2, DUP2, MULT2]) state1
tst35 = semCmd2 (CALL "macro2") state1
tst3 = semCmd2 (CALL "fail") state1



{-- Ex.3 --}
-- Syntax
data Cmd3 = Pen Mode
          | MoveTo Int Int
          | Seq Cmd3 Cmd3
          deriving Show

data Mode = Up | Down
          deriving (Show, Eq)

-- Defining State
type State = (Mode,Int,Int)

-- Defining Line / Lines
type Line = (Int,Int,Int,Int)
type Lines = [Line]

-- Semantics
semS :: Cmd3 -> State -> (State,Lines)
{-- Change the pen mode. If the mode is the same, do not do anything. --}
semS (Pen mode1) (mode2, x, y) | mode1 /= mode2    = ((mode1, x, y), [])
                               | otherwise         = ((mode2, x, y), [])
{-- If the pen is up, do not do anything.
    If the pen is down and the coordinates are not the same, make a
    line to that position.
    Otherwise, do not do anything. --}
semS (MoveTo x1 y1) (mode, x2, y2)  | mode == Up               = (stt, [])
                                    | x1 /= x2 || y1 /= y2     = (stt, [(x2, y2, x1, y1)])
                                    | otherwise                = (stt, [])
                                    where stt = (mode, x1, y1)
{-- Evaluates the first and second command. --}
semS (Seq cmd1 cmd2) stt = (fst stt2, snd stt1 ++ snd stt2)
                 where
                   stt1 = semS cmd1 stt
                   stt2 = semS cmd2 (fst stt1)

-- Start with the initial position of Up and (0,0).
sem' :: Cmd3 -> Lines
sem' y = snd (semS y (Up,0,0))

-- Test for exercise 3.
t1 = sem' (Seq (Pen Down) (MoveTo 1 1))
t2 = sem' (Seq (Pen Down) (MoveTo 0 0))
t3 = sem' (Seq (Pen Up) (MoveTo 1 1))
t4 = sem' (Seq (Pen Down) (MoveTo 0 5))
t5 = sem' (Seq (Pen Down) (Seq (MoveTo 2 2) (MoveTo 3 3)))