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

--Semantics
rankC :: Cmd -> CmdRank

rankP :: Prog -> Maybe Rank

rank :: Prog -> Rank -> Maybe Rank

