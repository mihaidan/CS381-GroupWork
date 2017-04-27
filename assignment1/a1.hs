-- CS381 Assignment 1
--
-- Mihai Dan
-- Braden Ackles
-- Pranav Ramesh
-- Sophia Liu
-- Juan Ramirez

module A1 where

-- Importing Prelude without including Num because we
-- are defining the type ourselves.
import Prelude hiding (Num)

-- Ex.1 (a)
-- Define the abstract syntax for Mini Logo as a Haskell data type.

-- Defining types Name and Num
type Name = String
type Num = Int

-- Data types definitions.
data Cmd = Pen Mode
         | Moveto Pos Pos
         | Def Name Pars Cmd
         | Call Name Vals
         | Seq Cmd Cmd

data Mode = Up | Down
data Pos = I Num | S Name
data Pars = OneP Name | MoreP [Name]
data Vals = OneV Num | MoreV [Num]


-- Ex.1 (b)
-- Write a Mini Logo macro vector that draws a line from a given 
-- position (x1,y1) to a given position (x2,y2) and represent the 
-- macro in abstract syntax, that is, as a Haskell data type value.
vector :: Cmd
vector = Def "vector" (MoreP ["x1","y1","x2","y2"])
                (Seq (Pen Up)
                     (Seq (Moveto (S "x1") (S "y1"))
                          (Seq (Pen Down)
                               (Seq (Moveto (S "x2") (S "y2")) (Pen Up)) )))


-- Ex.1 (c)
-- Define a Haskell function steps :: Int -> Cmd that constructs
-- a Mini Logo program which draws a stair of n steps.

-- Function type.
steps :: Int -> Cmd
-- Base Case for 0
steps 0 = Seq (Pen Up) (Moveto (I 0) (I 0))
-- Base Case for 1
steps 1 = Seq (Pen Up) 
            (Seq (Moveto (I 0) (I 0)) 
                (Seq (Pen Down) 
                    (Seq (Moveto (I 0) (I 1)) 
                        (Seq (Moveto (I 1) (I 1)) (Pen Up)))))
-- n steps
steps n = Seq (steps (n-1))
    (Seq (Pen Up) 
            (Seq (Moveto (I (n-1)) (I (n-1))) 
                (Seq (Pen Down) 
                    (Seq (Moveto (I (n-1)) (I n)) 
                        (Seq (Moveto (I n) (I n)) (Pen Up))))))

-----------------------------------------------------------------
-----------------------------------------------------------------

-- Ex.2 (a)
-- Define the abstract syntax for the above language as a Haskell 
-- data type.
data Circuit = Circuit Gates Links

data Gates = Gate Int GateFn Gates | EmptyG

data GateFn = And | Or | Xor | Not

data Links = Lnk Int Int Int Int Links | EmptyL

-- Ex.2 (b)
-- Represent the half adder circuit in abstract syntax, that is, 
-- as a Haskell data type value.
halfadder = Circuit (Gate 1 Xor (Gate 2 And (EmptyG))) 
                        (Lnk 1 1 2 1 (Lnk 1 2 2 2 (EmptyL)))


-- Ex.2 (c)
-- Define a Haskell function that implements a pretty printer for
-- the abstract syntax.
ppGateFn :: GateFn -> String
ppGateFn And = "and"
ppGateFn Or = "or"
ppGateFn Xor = "xor"
ppGateFn Not = "not"

ppLinks :: Links -> String
ppLinks EmptyL = " "
ppLinks (Lnk int1 int2 int3 int4 links) = "from " ++ show int1 ++ "." ++ show int2 ++ " to " ++ show int3 ++ "." ++ show int4 ++ (show "\n") ++ ppLinks links

ppGates :: Gates -> String
ppGates EmptyG = " "
ppGates (Gate i func gates) = show i ++ ":" ++ ppGateFn func ++ (show "\n") ++ ppGates gates

ppCircuit :: Circuit -> String
ppCircuit (Circuit gate link) = ppGates gate ++ (show "\n") ++ ppLinks link


-----------------------------------------------------------------
-----------------------------------------------------------------

-- Consider the following abstract syntax for arithmetic expressions.
data Expr = N Int
          | Plus Expr Expr
          | Times Expr Expr
          | Neg Expr

-- Now consider the following alternative abstract syntax.
data Op = Add | Multiply | Negate
data Exp = Num Int
         | Apply Op [Exp]

-- Ex.3 (a)
-- Represent the expression -(3+4)*7 in the alternative abstract 
-- syntax.
variable = Apply Multiply [(Apply Negate [(Apply Add [Num 3, Num 4])]), Num 7]

-- Ex.3 (b)
-- What are the advantages or disadvantages of either representation?
{--
Advantages:
-The advantage to the second representation is that it has the ability to
apply an operator to a list of Exp, whether that be integers or more Exp.
-The advantage to the first representation is that it is much easier to
understand what it is doing.

Disadvantages:
-The disadvantage to the second representation is that, in order to do
more calculations, Op must be called several times.
--}

-- Ex.3 (c)
-- Define a function translate :: Expr -> Exp that translates 
-- expressions given in the first abstract syntax into equivalent 
-- expressions in the second abstract syntax.
translate :: Expr -> Exp
translate (N x) = (Num x)
translate (Plus (N x) (N y)) = (Apply Add [(Num x), (Num y)])
translate (Times (N x) (N y)) = (Apply Multiply [(Num x), (Num y)])
translate (Neg (N x)) = (Apply Negate [(Num x)]) 