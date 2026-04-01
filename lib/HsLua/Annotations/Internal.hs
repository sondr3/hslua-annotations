module HsLua.Annotations.Internal
  ( annotateFunction,
    annotateModule,
  )
where

import Data.Char (toLower)
import Data.Text (Text)
import Data.Text qualified as T
import Data.Text.Encoding (decodeUtf8)
import HsLua.Core (Name (..), Type (..))
import HsLua.Packaging

-- | Create type annotations for a documented function.
--
-- === __Example__
--
-- Given the example `factorial` function from HsLua:
--
-- @
-- factorial :: DocumentedFunction Lua.Exception
-- factorial =
--   defun "factorial" (liftPure $ \n -> product [1 .. n] :: Integer)
--     <#> parameter peekIntegral "integer" "n" ""
--     =#> functionResult pushIntegral "integer" "factorial"
--     #? "Calculates the factorial of a positive integer."
-- @
--
-- The output of running @annotateFunction factorial@ on it will be the
-- following string:
--
-- @
-- ---Calculates the factorial of a positive integer.
-- ---\@param n integer
-- ---\@return integer
-- function factorial(n)
-- @
--
-- @since 0.1.0
annotateFunction :: DocumentedFunction a -> Text
annotateFunction = annotateFunction' Nothing

-- | Create type annotations for a documented module.
--
-- === __Example__
--
-- Using @HsLua.Module.Version@ and the `documentedModule` from it you can
-- generate annotations for the whole module. Note that you probably will
-- have to narrow the tyoe of @Module a@ to for example @Module Lua.Exception@.
--
-- The output of running @annotateModule documentedModule@ on it will be the
-- following string:
--
-- @
-- ---\@meta path
-- ---Module for file path manipulations.
--
-- ---\@class (exact) path
-- ---\@field separator string The character that separates directories.
-- ---\@field search_path_separator string The character that is used to separate the entries in the `PATH` environment variable.
-- local path = {}
--
-- ---Gets the directory name, i.e., removes the last directory separator and everything after from the given path.
-- ---\@param filepath string path
-- ---\@return string
-- function path.directory(filepath)
--
-- ---Get the file name.
-- ---\@param filepath string path
-- ---\@return string
-- function path.filename(filepath)
--
-- ...snip
-- @
--
-- @since 0.1.0
annotateModule :: Module a -> Text
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
        T.intercalate "\n" (map (annotateFunction' $ Just moduleName) moduleFunctions)
      ]

annotateFunction' :: Maybe Name -> DocumentedFunction a -> Text
annotateFunction' parent (DocumentedFunction {functionName, functionDoc}) = do
  let name = decodeName functionName
      desc = functionDesc functionDoc
      typ = returnType functionDoc
      paramAnn = paramsDesc functionDoc
      params = T.intercalate ", " $ paramNames functionDoc
      paren = maybe "" (\n -> decodeName n <> ".") parent
   in T.unlines $
        filter
          (not . T.null)
          [ if T.null desc then "" else "---" <> desc,
            paramAnn,
            "---@return " <> typ,
            "function " <> paren <> name <> "(" <> params <> ")"
          ]

opDesc :: (Operation, DocumentedFunction a) -> Text
opDesc (op, DocumentedFunction {functionDoc}) = "---@operator " <> opName op <> ":" <> returnType functionDoc

fieldDesc :: Field a -> Text
fieldDesc (Field {fieldName, fieldDoc}) = "---@field " <> decodeName fieldName <> " " <> docs fieldDoc
  where
    docs (FieldDoc {fieldDocDescription, fieldDocType}) = typeToText fieldDocType <> " " <> fieldDocDescription

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
      typ = typeToText parameterType
   in "---@param " <> parameterName <> isOpt <> " " <> typ <> " " <> parameterDescription

returnType :: FunctionDoc -> Text
returnType (FunDoc {funDocResults}) = go funDocResults
  where
    go (ResultsDocList [rs]) = resultValueDesc rs
    go (ResultsDocList xs) = T.intercalate "|" $ map resultValueDesc xs
    go (ResultsDocMult res) = res

resultValueDesc :: ResultValueDoc -> Text
resultValueDesc (ResultValueDoc {resultValueType}) = typeToText resultValueType

typeToText :: TypeSpec -> Text
typeToText = \case
  BasicType t -> basicTypeName t
  NamedType nt -> decodeUtf8 $ fromName nt
  AnyType -> "any"
  FunType {} -> "function"
  RecType {} -> "table"
  SeqType t -> typeToText t <> "[]"
  SumType specs -> T.intercalate "|" (map typeToText specs)

basicTypeName :: Type -> Text
basicTypeName = \case
  TypeLightUserdata -> "light userdata"
  t -> T.pack $ map toLower . drop 4 $ show t

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
