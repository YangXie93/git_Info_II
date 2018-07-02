
import Data.Maybe

------------------------------------- Aufgabe I -------------------------------------------

match :: String -> [String] -> [String]
match x (y:s)
  | x == y = s
  | otherwise = []

----------------------- Für die match funktion habe ich keine verwendung gefunden ----------

id_list_tail :: [String] -> [String]
id_list_tail y
  | y == [] = error "der id_tail besteht immer aus mindestens zwei zeichen"
  | x == "," = id_list s                                         -- prüfen auf id
  | x == ";" = id_list_tail_end s                                -- Aufruf der endfunktion
  | otherwise = error "Die möglichen Folgen auf id sind \",id\" , \";$$\""
  where
      x = head y
      s = tail y

id_list_tail_end :: [String] -> [String]
id_list_tail_end y
    | y == ["$$"] = []                                          -- es ist nur richtig wenn nur "$$" in der Liste steht
    |otherwise = error "nach \";\" folgt immer $$"

id_list :: [String] -> [String]
id_list y
  | y == [] = []                    -- Abbruch bedingung (final)
  | x == "id" = id_list_tail s      -- nach id folt immer ein tail
  | otherwise = error "Der Satz beginnt immer mit id und nach \",\" folgt immer id"
  where
      x = head y
      s = tail y

------------------------------------ Aufgabe II ---------------------------------------------------

expr :: Maybe String -> Maybe String
expr y = ttail(term y)                 --bei expr teilt sich der Daten Strom in term und danach ttail


term :: Maybe String -> Maybe String
term y = ftail (factor y)             -- Term teilt sich in factor und ftail

ttail :: Maybe String -> Maybe String
ttail y
  | y == Nothing = Nothing              --die Möglichkeit lässt sich nicht in otherwise mit einbeziehen, da sonst das patternmatching nicht funktioniert
  | y == Just "" = Just ""              -- ist der String leer wird die verarbeitung beendet
  | x == '+' = ttail( term (Just s))    -- ist das erste Element ein '+' dann wird der Rest nochmal auf term und ttail geprüft
  | otherwise = Nothing
  where
      Just z = y
      (x:s) = z

factor :: Maybe String -> Maybe String
factor y
  | x == 'c' = Just s                    -- factor ist entweder 'c' oder gehört nicht zu der Sprache
  | otherwise = Nothing
  where
      Just z = y
      (x:s) = z

ftail :: Maybe String -> Maybe String
ftail y
  | y == Nothing = Nothing               -- das selbe Problem wie bei ttail
  | y == Just "" = Just ""               -- siehe ttail
  | x == '*' = ftail(factor (Just s))    -- ist das erste Element ein '*' dann wird nochmal auf factor und ftail geprüft
  | x == '+' = Just z                    -- ist das erste Element ein '+' dann wird der ganze String zurückgegeben, da ftail immer in einen ttail zurückgibt
  | otherwise = Nothing
  where
      Just z = y
      (x:s) = z

prog :: String -> Maybe String
prog y
  | length y < 2 = Nothing                -- es gibt kein wort kleiner 2
  | last y == '$' = expr (Just n)         -- das Endelement wird geprüft und entfernt
  | otherwise = Nothing
  where
      (x:s) = reverse y
      n = reverse s
