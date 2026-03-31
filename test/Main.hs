module Main (main) where

import Data.Text.Lazy (fromStrict)
import Data.Text.Lazy.Encoding (encodeUtf8)
import HsLua.Annotations (annotateFunction, factorial)
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.Golden

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests =
  testGroup
    "Spec"
    [ goldenVsString "factorial" "test/golden/factorial.lua" (pure $ encodeUtf8 (fromStrict $ annotateFunction factorial))
    ]

factorial :: DocumentedFunction Lua.Exception
factorial =
  defun "factorial" (liftPure $ \n -> product [1 .. n] :: Integer)
    <#> parameter peekIntegral "integer" "n" ""
    =#> functionResult pushIntegral "integer" "factorial"
    #? "Calculates the factorial of a positive integer."
    `since` makeVersion [1, 0, 0]
