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
      paramAnn = paramsDesc functionDoc
      params = T.intercalate ", " $ paramNames functionDoc
  "---" <> desc <> "\n" <> paramAnn <> "\n" <> "---@return " <> typ <> "\n" <> "function " <> name <> "(" <> params <> ")"

functionDesc :: FunctionDoc -> Text
functionDesc (FunDoc {funDocDescription}) = funDocDescription

paramNames :: FunctionDoc -> [Text]
paramNames (FunDoc {funDocParameters}) = map go funDocParameters
  where
    go (ParameterDoc {parameterName}) = parameterName

paramsDesc :: FunctionDoc -> Text
paramsDesc (FunDoc {funDocParameters}) = T.intercalate "\n" $ map paramDesc funDocParameters

paramDesc :: ParameterDoc -> Text
paramDesc (ParameterDoc {parameterName, parameterType, parameterDescription, parameterIsOptional}) = "---@param " <> parameterName <> (if parameterIsOptional then "?" else "") <> " " <> (T.pack $ typeSpecToString parameterType) <> " " <> parameterDescription

returnType :: FunctionDoc -> Text
returnType (FunDoc {funDocResults}) = go funDocResults
  where
    go (ResultsDocList (rs : [])) = resultValueDesc rs
    go (ResultsDocList xs) = T.intercalate "|" $ map resultValueDesc xs
    go (ResultsDocMult res) = res

resultValueDesc :: ResultValueDoc -> Text
resultValueDesc (ResultValueDoc {resultValueType}) = T.pack $ typeSpecToString resultValueType

decodeName :: Name -> Text
decodeName = decodeUtf8 . fromName

factorial :: DocumentedFunction Lua.Exception
factorial =
  defun "factorial" (liftPure $ \n -> product [1 .. n] :: Integer)
    <#> parameter peekIntegral "integer" "n" ""
    =#> functionResult pushIntegral "integer" "factorial"
    #? "Calculates the factorial of a positive integer."
    `since` makeVersion [1, 0, 0]
