module Main (main) where

import Control.Exception (throw)
import Control.Monad (void)
import Data.Text qualified as T
import Data.Text.Lazy (fromStrict)
import Data.Text.Lazy.Encoding (encodeUtf8)
import HsLua.Annotations (annotateFunction, factorial)
import Test.Tasty (TestName, TestTree, defaultMain, testGroup)
import Test.Tasty.Golden

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests =
  testGroup
    "Spec"
    [ goldenVsString "factorial" "test/golden/factorial.lua" (pure $ encodeUtf8 (fromStrict $ annotateFunction factorial))
    ]
