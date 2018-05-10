

(<+>) :: Bool -> Bool -> Bool
(<+>) x y = (y || x) && (not (y && x))

boolToInt :: Bool -> Int
boolToInt a
  |a == False = 0
  | otherwise = 1

calcNibble :: (Int,Int,Int,Int) -> Bool -> Int
calcNibble (a,b,c,d) e
  | boolToInt(e) == a && a == 1 = ((((b*2) +c)*2) +d) *2 - ((((((a*2) +b) *2) +c) *2)+d)
  | boolToInt(e) == a && a == 0 = ((((b*2) +c)*2) +d)
  | otherwise = (((((a*2) +b) *2) +c) *2)+d

showNibble :: (Bool,Bool,Bool,Bool) -> String
showNibble (a,b,c,d) = show(boolToInt(a)) ++ show(boolToInt(b)) ++ show(boolToInt(c)) ++ show(boolToInt(d)) ++ " " ++ show(calcNibble (boolToInt(a),boolToInt(b),boolToInt(c),boolToInt(d)) False) ++ " "++ show(calcNibble (boolToInt(a),boolToInt(b),boolToInt(c),boolToInt(d)) True)


fullAdder :: Bool -> Bool -> Bool -> (Bool,Bool)
fullAdder x y z
  | (x && y && z) = (True,True)
  | (x && y) || (y && z) || (z && x) = (True,False)
  | ((x <+> y) <+> z) = (False, True)
  | otherwise = (False,False)

carry :: (Bool,Bool) -> Bool
carry (a,b) = a

noCarry :: (Bool,Bool) -> Bool
noCarry (a,b) = b

rippleCarryAdder :: (Bool,Bool,Bool,Bool) -> (Bool,Bool,Bool,Bool) -> (Bool,Bool,Bool,Bool)
rippleCarryAdder (w,x,y,z) (a,b,c,d) =  ( noCarry(fullAdder w a (carry(fullAdder x b (carry((fullAdder y c (carry((fullAdder z d False))))))))) ,noCarry(fullAdder x b (carry((fullAdder y c (carry((fullAdder d z False))))))) ,noCarry((fullAdder y c (carry((fullAdder d z False))))) ,noCarry((fullAdder d z False)) )

nibbelSelect :: ((Bool,Bool,Bool,Bool),(Bool,Bool,Bool,Bool)) -> Bool -> (Bool,Bool,Bool,Bool)
nibbelSelect (x,y) z
  | z == True = x
  | otherwise =y

tableAdder :: ((Bool,Bool,Bool,Bool) -> (Bool,Bool,Bool,Bool) -> (Bool,Bool,Bool,Bool)) -> [((Bool,Bool,Bool,Bool),(Bool,Bool,Bool,Bool))] -> String
tableAdder op x
  | x == [] = ""
  | otherwise = showNibble (nibbelSelect (head x) True) ++ " ; " ++ showNibble (nibbelSelect (head x) False) ++ " = " ++ showNibble (op (nibbelSelect (head x) True) (nibbelSelect (head x) False)) ++ "\n" ++ tableAdder op (tail x)
