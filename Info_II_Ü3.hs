type Nibble = (Bool,Bool,Bool,Bool)
type Byte = (Nibble,Nibble)

shiftByte :: Byte -> Byte
shiftByte ((a,b,c,d),(e,f,g,h)) = ((b,c,d,e),(f,g,h,False))

signExtension :: Nibble -> Byte
signExtension (a,b,c,d) = ((a,False,False,False),(False,b,c,d))

multBitByte :: Bool -> Byte -> Byte
multBitByte x ((a,b,c,d),(e,f,g,h))
  |x == False = ((False,False,False,False),(False,False,False,False))
  |otherwise = ((a,b,c,d),(e,f,g,h))

(<+>) :: Bool -> Bool -> Bool
(<+>) x y = (y || x) && (not (y && x))

fullAdder :: Bool -> Bool -> Bool -> (Bool,Bool)
fullAdder x y z
  | (x && y && z) = (True,True)
  | ((x && y) <+> (y && z)) <+> (z && x) = (True,False)
  | ((x <+> y) <+> z) = (False, True)
  | otherwise = (False,False)

rippleCarryAdder :: Byte -> Byte -> Byte
rippleCarryAdder ((a,b,c,d),(e,f,g,h)) ((i,j,k,l),(m,n,o,p)) = ((s7,s6,s5,s4),(s3,s2,s1,s0))
  where
      (c0,s0) = fullAdder h p False
      (c1,s1) = fullAdder g o c0
      (c2,s2) = fullAdder f n c1
      (c3,s3) = fullAdder m e c2
      (c4,s4) = fullAdder l d c3
      (c5,s5) = fullAdder k c c4
      (c6,s6) = fullAdder j b c5
      (c7,s7) = fullAdder a i c6

carrySaveAdder :: Byte -> Byte -> Byte -> (Byte,Byte)
carrySaveAdder ((a,b,c,d),(e,f,g,h)) ((i,j,k,l),(m,n,o,p)) ((q,r,s,t),(u,v,w,x)) = (( shiftByte ((c7,c6,c5,c4),(c3,c2,c1,c0)) ),( (s7,s6,s5,s4),(s3,s2,s1,s0)))
    where
        (c0,s0) = fullAdder x p h
        (c1,s1) = fullAdder w o g
        (c2,s2) = fullAdder v n f
        (c3,s3) = fullAdder u m e
        (c4,s4) = fullAdder l d t
        (c5,s5) = fullAdder k c s
        (c6,s6) = fullAdder j b r
        (c7,s7) = fullAdder a i q


boolToInt :: Bool -> Int
boolToInt a
  |a == False = 0
  | otherwise = 1

intToBool :: Int -> Bool
intToBool x
  |x == 0 = False
  |x == 1 = True
  |otherwise = False

byteDec :: Byte -> Int
byteDec ((a,b,c,d),(e,f,g,h)) = p
    where
        i = (boolToInt a) *2
        j = (i + boolToInt b) *2
        k = (j + boolToInt c) *2
        l = (k + boolToInt d) *2
        m = (l + boolToInt e) *2
        n = (m + boolToInt f) *2
        o = (n + boolToInt g) *2
        p = (o + boolToInt h)

decByte :: Int -> Byte
decByte x = ((s7,s6,s5,s4),(s3,s2,s1,s0))
    where
        (s0,y0) = (intToBool(mod x 2),div x 2)
        (s1,y1) = (intToBool(mod y0 2),div y0 2)
        (s2,y2) = (intToBool(mod y1 2),div y1 2)
        (s3,y3) = (intToBool(mod y2 2),div y2 2)
        (s4,y4) = (intToBool(mod y3 2),div y3 2)
        (s5,y5) = (intToBool(mod y4 2),div y4 2)
        (s6,y6) = (intToBool(mod y5 2),div y5 2)
        s7 = intToBool(mod y6 2)


negByte :: Byte -> Byte
negByte ((a,b,c,d),(e,f,g,h)) = decByte (256 -(byteDec ((a,b,c,d),(e,f,g,h))))

nibbleDec :: Nibble -> Int
nibbleDec (a,b,c,d) = l
    where
        i = (boolToInt a) *2
        j = (i + boolToInt b) *2
        k = (j + boolToInt c) *2
        l = (k + boolToInt d)

decNibble :: Int -> Nibble
decNibble x = (s3,s2,s1,s0)
    where
     (s0,y0) = (intToBool(mod x 2),div x 2)
     (s1,y1) = (intToBool(mod y0 2),div y0 2)
     (s2,y2) = (intToBool(mod y1 2),div y1 2)
     s3 = intToBool(mod y2 2)

negNibble :: Nibble -> Nibble
negNibble (a,b,c,d) = decNibble(16 -(nibbleDec (a,b,c,d)))

byteDecComp :: Byte -> Int
byteDecComp ((a,b,c,d),(e,f,g,h)) = (y6*2 - (byteDec ((a,b,c,d),(e,f,g,h))))
      where
        y0 = (boolToInt b)*2
        y1 = (y0 +(boolToInt c))*2
        y2 = (y1 +(boolToInt d))*2
        y3 = (y2 +(boolToInt e))*2
        y4 = (y3 +(boolToInt f))*2
        y5 = (y4 +(boolToInt g))*2
        y6 = (y5 +(boolToInt h))

showByte :: Byte -> String
showByte ((a,b,c,d),(e,f,g,h)) = s7 ++ " " ++ show(byteDec ((a,b,c,d),(e,f,g,h))) ++ " " ++show(byteDecComp ((a,b,c,d),(e,f,g,h)))
    where
        s0 = show( boolToInt a)
        s1 = s0 ++ show(boolToInt b)
        s2 = s1 ++ show(boolToInt c)
        s3 = s2 ++ show(boolToInt d)
        s4 = s3 ++ show(boolToInt e)
        s5 = s4 ++ show(boolToInt f)
        s6 = s5 ++ show(boolToInt g)
        s7 = s6 ++ show(boolToInt h)

multNibble :: Nibble -> Nibble -> Byte
multNibble (a,b,c,d) (e,f,g,h)
     |a == True && a == e = multNibble (negNibble (a,b,c,d)) (negNibble (e,f,g,h))
     |e /= a && a == True = negByte(multNibble (negNibble (a,b,c,d)) (e,f,g,h))
     |a /= e && e == True = negByte(multNibble (a,b,c,d) (negNibble (e,f,g,h)))
     |otherwise = ergebnis
    where
        (x0,y0) = (multBitByte h (signExtension (a,b,c,d)), signExtension (a,b,c,d))
        (x1,y1) = (shiftByte (multBitByte g y0), shiftByte y0)
        (x2,y2) = (shiftByte (multBitByte f y1), shiftByte y1)
        (x3,y3) = (shiftByte (multBitByte e y2), shiftByte y2)
        (xz0,xn0) = carrySaveAdder x0 x1 x2
        (xz1,xn1) = carrySaveAdder xz0 xn0 x3
        ergebnis = rippleCarryAdder xz1 xn1

tableMult :: ( Nibble -> Nibble -> Byte )-> [( Nibble , Nibble )] -> String
tableMult op x
    | x == [] = ""
    | otherwise = showByte(op a b) ++ "\n" ++ tableMult op (tail x)
    where
        (a,b) = head x
