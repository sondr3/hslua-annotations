module HsLua.Annotations
  ( annotateFunction,
    factorial,
  )
where

import Data.Text (Text)
import Data.Text qualified as T
import Data.Text.Encoding (decodeUtf8)
import Data.Version (makeVersion)
import HsLua.Core (Name (..))
import HsLua.Core qualified as Lua
import HsLua.Marshalling (peekIntegral, pushIntegral)
import HsLua.Packaging

annotateFunction :: DocumentedFunction a -> Text
annotateFunction (DocumentedFunction {functionName, functionDoc}) = do
  let name = decodeName functionName
      desc = functionDesc functionDoc
      typ = returnType functionDoc
  "---" <> desc <> "\n" <> "---@return " <> typ <> "\n" <> "function " <> name <> "()"

functionDesc :: FunctionDoc -> Text
functionDesc (FunDoc {funDocDescription}) = funDocDescription

returnType :: FunctionDoc -> Text
returnType (FunDoc {funDocResults}) = go funDocResults
  where
    go (ResultsDocList ((ResultValueDoc {resultValueType}) : _)) = T.pack $ typeSpecToString resultValueType
    go (ResultsDocMult res) = res

decodeName :: Name -> Text
decodeName = decodeUtf8 . fromName

factorial :: DocumentedFunction Lua.Exception
factorial =
  defun "factorial" (liftPure $ \n -> product [1 .. n] :: Integer)
    <#> parameter peekIntegral "integer" "n" ""
    =#> functionResult pushIntegral "integer" "factorial"
    #? "Calculates the factorial of a positive integer."
    `since` makeVersion [1, 0, 0]
