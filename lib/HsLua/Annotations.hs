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
   in T.unlines $
        filter
          (not . T.null)
          [ "---" <> desc,
            paramAnn,
            "---@return " <> typ,
            "function " <> name <> "(" <> params <> ")"
          ]

annotateModule :: Module Lua.Exception -> Text
annotateModule (Module {moduleName, moduleDescription, moduleFields, moduleFunctions, moduleOperations}) =
  T.unlines $
    filter
      (not . T.null)
      [ "---@meta " <> decodeName moduleName,
        "---" <> moduleDescription <> "\n",
        "---@class (exact) " <> decodeName moduleName,
        T.intercalate "\n" (map fieldDesc moduleFields),
        T.intercalate "\n" (map opDesc moduleOperations),
        "local " <> decodeName moduleName <> " = {}\n",
        T.intercalate "\n" (map (moduleFuncDesc moduleName) moduleFunctions)
      ]

moduleFuncDesc :: Name -> DocumentedFunction a -> Text
moduleFuncDesc moduleName (DocumentedFunction {functionName, functionDoc}) = do
  let name = decodeName functionName
      desc = functionDesc functionDoc
      typ = returnType functionDoc
      paramAnn = paramsDesc functionDoc
      params = T.intercalate ", " $ paramNames functionDoc
   in T.unlines $
        filter
          (not . T.null)
          [ "---" <> desc,
            paramAnn,
            "---@return " <> typ,
            "function " <> decodeName moduleName <> "." <> name <> "(" <> params <> ")"
          ]

opDesc :: (Operation, DocumentedFunction a) -> Text
opDesc (op, DocumentedFunction {functionDoc}) = "---@operator " <> opName op <> ":" <> returnType functionDoc

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
paramDesc (ParameterDoc {parameterName, parameterType, parameterDescription, parameterIsOptional}) = do
  let isOpt = if parameterIsOptional then "?" else ""
      typ = T.pack (typeSpecToString parameterType)
   in "---@param " <> parameterName <> isOpt <> " " <> typ <> " " <> parameterDescription

returnType :: FunctionDoc -> Text
returnType (FunDoc {funDocResults}) = go funDocResults
  where
    go (ResultsDocList [rs]) = resultValueDesc rs
    go (ResultsDocList xs) = T.intercalate "|" $ map resultValueDesc xs
    go (ResultsDocMult res) = res

resultValueDesc :: ResultValueDoc -> Text
resultValueDesc (ResultValueDoc {resultValueType}) = T.pack $ typeSpecToString resultValueType

opName :: Operation -> Text
opName = \case
  Add -> "add"
  Sub -> "sub"
  Mul -> "mul"
  Div -> "div"
  Mod -> "mod"
  Pow -> "pow"
  Unm -> "unm"
  Idiv -> "idiv"
  Band -> "band"
  Bor -> "bor"
  Bxor -> "bxor"
  Bnot -> "bnot"
  Shl -> "shl"
  Shr -> "shr"
  Concat -> "concat"
  Len -> "len"
  Eq -> "eq"
  Lt -> "lt"
  Le -> "le"
  Index -> "index"
  Newindex -> "newindex"
  Call -> "call"
  Tostring -> "tostring"
  Pairs -> "pairs"
  CustomOperation x -> decodeName x

decodeName :: Name -> Text
decodeName = decodeUtf8 . fromName
