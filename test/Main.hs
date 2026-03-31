module Main (main) where

import Data.Text (Text)
import Data.Text.Lazy (fromStrict)
import Data.Text.Lazy.Encoding (encodeUtf8)
import Data.Version (makeVersion)
import HsLua.Annotations (annotateFunction, annotateModule)
import HsLua.Core qualified as Lua
import HsLua.Marshalling (peekIntegral, pushIntegral)
import HsLua.Module.Path qualified as Path
import HsLua.Module.Version qualified as Version
import HsLua.Packaging
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.Golden

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests =
  testGroup
    "Spec"
    [ goldenVsString "factorial" "test/golden/factorial.lua" (pure $ encodeUtf8 (fromStrict $ annotateFunction factorial)),
      goldenVsString "path" "test/golden/path.lua" (pure $ encodeUtf8 $ fromStrict (annModule Path.documentedModule)),
      goldenVsString "version" "test/golden/version.lua" (pure $ encodeUtf8 $ fromStrict (annModule Version.documentedModule))
    ]
  where
    annModule :: Module Lua.Exception -> Text
    annModule = annotateModule

factorial :: DocumentedFunction Lua.Exception
factorial =
  defun "factorial" (liftPure $ \n -> product [1 .. n] :: Integer)
    <#> parameter peekIntegral "integer" "n" ""
    =#> functionResult pushIntegral "integer" "factorial"
    #? "Calculates the factorial of a positive integer."
    `since` makeVersion [1, 0, 0]
