module HsLua.Annotations
  ( annotateFunction,
    annotateModule,
  )
where

import Data.Text (Text)
import Data.Text qualified as T
import Data.Text.Encoding (decodeUtf8)
import HsLua.Core (Name (..))
import HsLua.Core qualified as Lua
import HsLua.Packaging

annotateFunction :: DocumentedFunction a -> Text
annotateFunction (DocumentedFunction {functionName, functionDoc}) = do
  let name = decodeName functionName
      desc = functionDesc functionDoc
      typ = returnType functionDoc
      paramAnn = paramsDesc functionDoc
      params = T.intercalate ", " $ paramNames functionDoc
  "---" <> desc <> "\n" <> paramAnn <> "\n" <> "---@return " <> typ <> "\n" <> "function " <> name <> "(" <> params <> ")"

annotateModule :: Module Lua.Exception -> Text
annotateModule (Module {moduleName, moduleDescription, moduleFields, moduleFunctions}) = "---@meta " <> decodeName moduleName <> "\n" <> "---" <> moduleDescription <> "\n\n" <> "---@class (exact) " <> decodeName moduleName <> "\n" <> T.intercalate "\n" (map fieldDesc moduleFields) <> "\n" <> "local " <> decodeName moduleName <> " = {}\n\n" <> T.intercalate "\n\n" (map (moduleFuncDesc moduleName) moduleFunctions)

moduleFuncDesc :: Name -> DocumentedFunction a -> Text
moduleFuncDesc moduleName (DocumentedFunction {functionName, functionDoc}) = do
  let name = decodeName functionName
      desc = functionDesc functionDoc
      typ = returnType functionDoc
      paramAnn = paramsDesc functionDoc
      params = T.intercalate ", " $ paramNames functionDoc
  "---" <> desc <> "\n" <> paramAnn <> "\n" <> "---@return " <> typ <> "\n" <> "function " <> decodeName moduleName <> "." <> name <> "(" <> params <> ")"

fieldDesc :: Field a -> Text
fieldDesc (Field {fieldName, fieldDoc}) = "---@field " <> decodeName fieldName <> " " <> docs fieldDoc
  where
    docs (FieldDoc {fieldDocDescription, fieldDocType}) = T.pack (typeSpecToString fieldDocType) <> " " <> fieldDocDescription

functionDesc :: FunctionDoc -> Text
functionDesc (FunDoc {funDocDescription}) = funDocDescription

paramNames :: FunctionDoc -> [Text]
paramNames (FunDoc {funDocParameters}) = map go funDocParameters
  where
    go (ParameterDoc {parameterName}) = parameterName

paramsDesc :: FunctionDoc -> Text
paramsDesc (FunDoc {funDocParameters}) = T.intercalate "\n" $ map paramDesc funDocParameters

paramDesc :: ParameterDoc -> Text
paramDesc (ParameterDoc {parameterName, parameterType, parameterDescription, parameterIsOptional}) = "---@param " <> parameterName <> (if parameterIsOptional then "?" else "") <> " " <> T.pack (typeSpecToString parameterType) <> " " <> parameterDescription

returnType :: FunctionDoc -> Text
returnType (FunDoc {funDocResults}) = go funDocResults
  where
    go (ResultsDocList [rs]) = resultValueDesc rs
    go (ResultsDocList xs) = T.intercalate "|" $ map resultValueDesc xs
    go (ResultsDocMult res) = res

resultValueDesc :: ResultValueDoc -> Text
resultValueDesc (ResultValueDoc {resultValueType}) = T.pack $ typeSpecToString resultValueType

decodeName :: Name -> Text
decodeName = decodeUtf8 . fromName
