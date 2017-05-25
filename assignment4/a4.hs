--Exercise #1 Runtme Sack--
--Consider the following block. Assume static scoping and call-by-value parameter passing.
-- { int x;
--   int y;
--   y := 1; 
--   { int f(int x) {
--         if x=0 then { 
--             y := 1 }
--         else {
--             y := f(x-1)*y+1 };
--         return y; 
--       };
--       x := f(2);
--   }
-- }
--
--Illustrate the computations that take place during the evaluation of this block, that is, draw a sequence of
--pictures each showing the complete run time stack with all activation records after each statement or function
--call.

--1 Answer:
--   []
--1  [x:?]
--2  [y:?, x:?]
--3  [y:1, x:?]
--4  [f:{}, y:1, x:?]
--11 
--          [x:2, f:{}, y:1, x:?]
--        5 [x:2, f:{}, y:1, x:?]
--        7 [x:2, f:{}, y:1, x:?]
--        8 
--               [x:1, x:2, f:{}, y:1, x:?]
--             5 [x:1, x:2, f:{}, y:1, x:?]
--             7 [x:1, x:2, f:{}, y:1, x:?]
--             8
--                    [x:0, x:1, x:2, f:{}, y:1, x:?]
--                  5 [x:0, x:1, x:2, f:{}, y:1, x:?]
--                  6 [x:0, x:1, x:2, f:{}, y:1, x:?]
--                  7 [x:0, x:1, x:2, f:{}, y:1, x:?]
--                  9 [res:1, x:0, x:1, x:2, f:{}, y:1, x:?]
--             8 [x:1, x:2, f:{}, y:2, x:?]
--             9 [res:2, x:1, x:2, f:{}, y:2, x:?]
--        8 [x:2, f:{}, y:5, x:?]
--        9 [res:5, x:2, f:{}, y:5, x:?]
--10 [f:{}, y:1, x:?]
--11 [f:{}, y:5, x:5]
--12 [y:5, x:5]
--13 []

--Excercise #2
--Consider the following block. Assume call-by-value parameter passing.
--{ int x; 
--  int y;
--  int z; 
--  x := 3;
--  y := 7; 
--  { int f(int y) { return x*y }; 
--    int y;
--    y := 11;
--    { int g(int x){ return f(y)};
--        { int y;
--          y := 13;
--          z := g(2);
--         };
--     };
--   };
--}
--a.Which value will be assigned to z in line 12 under static scoping? 
--
--b.Which value will be assigned to z in line 12 under dynamic scoping?
--




--Excercise #3 Parameter Passing
--Consider the following block. Assume dynamic scoping.
--{ int y; 
--  int z; 
--  y := 7; 
--  { int f(int a) {
--        y := a+1;
--        return (y+a) 
--    };
--    int g(int x) { 
--       y := f(x+1)+1;
--       z := f(x-y+3); 
--       return (z+1) 
--    }
--    z := g(y*2);
-- };
--}
--What are the values of y and z at the end of the above block under the assumption that both parameters a and x
--are passed:

--a. Call-by-Name
--y = 54
--z = 111


--Walk Through
--14 [g={}, f={}, z=?, y=7]
--12 
--        10 [x=y*2, g={}, f={}, z=?, y=7]
--        11 
--             4 [a=x+1, x=y*2, g={}, f={}, z=?, y=7]
--             5 [a=x+1, x=y*2, g={}, f={}, z=?, y=16]
--                  { x=14, a=15  ==>  y:=a+1=16  }
--             8 [res=49, a=x+1, x=y*2, g={}, f={}, z=?, y=16]
--                  { y=16, x=32, a=33   ==>  res=y+a=16+33=49 }
--        11 [x=y*2, g={}, f={}, z=?, y=50]
--        12 
--             4 [a=x-y+3, x=y*2, g={}, f={}, z=?, y=50]
--             5 [a=x-y+3, x=y*2, g={}, f={}, z=?, y=54]
--                  { x=100, a=53  ==>  y:=a+1=54  }
--             8 [res=111, a=x-y+3, x=y*2, g={}, f={}, z=?, y=54]
--                  { y=54, x=108, a=57   ==>  res=y+a=54+57=111 }
--        12 [x=y*2, g={}, f={}, z=111, y=54]
--        13 [res=112, x=y*2, g={}, f={}, z=111, y=54]
--15 [g={}, f={}, z=112, y=54]

--b. Call-by-Need
--y = -14
--z = -28


--Walk Through
--14 [g={}, f={}, z=?, y=7]
--15 
--        10 [x=y*2, g={}, f={}, z=?, y=7]
--        11 
--             4 [a=x+1, x=y*2, g={}, f={}, z=?, y=7]
--             5 [a=15, x=14, g={}, f={}, z=?, y=16]
--                  { x=14, a=15  ==>  y:=a+1=16  }
--             8 [res=31, a=15, x=14, g={}, f={}, z=?, y=16]
--                  { y=16, a=15   ==>  res=y+a=16+15=31 }
--        11 [x=14, g={}, f={}, z=?, y=32]
--        12
--             4 [a=x-y+3, x=14, g={}, f={}, z=?, y=32]
--             5 [a=-15, x=14, g={}, f={}, z=?, y=31]
--                  { x=14, a=-15  ==>  y:=a+1=-14  }
--             8 [res=-29, a=-15, x=14, g={}, f={}, z=?, y=-14]
--                  { y=-14, a=-15   ==>  res=y+a=-14+-15=-29 }
--        12 [x=14, g={}, f={}, z=-29, y=-14]
--        13 [res=-28, x=14, g={}, f={}, z=-29, y=-14]
--15 [g={}, f={}, z=-28, y=-14]



