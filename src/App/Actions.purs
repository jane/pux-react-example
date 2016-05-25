module App.Actions where

import Prelude
import App.Routes (match, Route)
import Data.Either (either)
import Data.Foreign (readString, Foreign)
import Data.Function (mkFn1, Fn1, mkFn0, Fn0)

data Action
  = PageView Route
  | Increment
  | Decrement
  | Reset
  | TextInput String

pageView :: Fn1 String Action
pageView = mkFn1 (match >>> PageView)

increment :: Fn0 Action
increment = mkFn0 (const Increment)

decrement :: Fn0 Action
decrement = mkFn0 (const Decrement)

reset :: Fn0 Action
reset = mkFn0 (const Reset)

textInput :: Fn1 Foreign Action
textInput = mkFn1 (readString >>> either (const "") id >>> TextInput)
