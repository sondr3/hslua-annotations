module HsLua.Annotations.Markdown
  ( documentFunction,
    documentModule,
  )
where

import Data.Bool (bool)
import Data.Text (Text)
import Data.Text qualified as T
import Data.Version (showVersion)
import HsLua.Annotations.Shared (hasReturnType, nameToText, returnType, typeToText, unlinesNonEmpty)
import HsLua.Core
import HsLua.Core.Utf8 qualified as Utf8
import HsLua.Packaging

-- | Create markdown documentation for a documented function.
--
-- See the below example or the generated test annotations [here](https://github.com/sondr3/hslua-annotations/blob/main/test/golden/factorial.md).
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
-- The output of running @documentFunction factorial@ will be the following string:
--
-- @
-- `function factorial(n)`
--
-- #### Parameters
--
-- | Name | Type | Description |
-- | ---- | ---- | ----------- |
-- | `n` | `integer` |  |
--
-- #### Returns
--
-- | Type | Description |
-- | ---- | ----------- |
-- | `integer` | factorial |
--
-- Calculates the factorial of a positive integer.
--
-- ```lua
-- function factorial(n: integer): integer
-- ```
--
-- *Since: 1.0.0*
-- @
--
-- @since 0.1.0
documentFunction :: DocumentedFunction e -> Text
documentFunction fn =
  let fnDoc = functionDoc fn
      fnName = Utf8.toText $ fromName (functionName fn)
      name =
        if T.null fnName
          then "<anonymous function>"
          else fnName
   in unlinesNonEmpty
        [ "`function " <> name <> "(" <> renderFunctionParams fnDoc <> ")" <> "`\n",
          renderFunctionDoc name fnDoc
        ]

-- | Create markdown documentation for a documented module.
--
-- See the below example or the generated test annotations [here](https://github.com/sondr3/hslua-annotations/blob/main/test/golden/path.md).
--
-- === __Example__
--
-- Building documentation for @HsLua.Module.Path@ using the exported @documentedModule@
-- you can generate Markdown documentation for the whole module. Note that you probably will
-- have to narrow the type of @Module a@ to for example @Module Lua.Exception@.
--
-- The output of running @documentModule documentedModule@ on it will be the
-- following string:
--
-- @
-- # `path`
-- Module for file path manipulations.
--
-- ## Fields
--
-- ### `separator`
-- The character that separates directories.
--
-- ```lua
-- path.separator: string
-- ```
--
-- ...snip
-- @
--
-- @since 0.1.0
documentModule :: Module e -> Text
documentModule (Module {moduleFields, moduleName, moduleDescription, moduleFunctions}) =
  unlinesNonEmpty
    [ "# `" <> nameToText moduleName <> "`",
      moduleDescription,
      renderFields moduleName moduleFields,
      renderFunctions moduleFunctions
    ]

renderFunctions :: [DocumentedFunction e] -> Text
renderFunctions [] = mempty
renderFunctions fs = "## Functions\n\n" <> T.intercalate "\n" (map (("### " <>) . documentFunction) fs)

renderFunctionParams :: FunctionDoc -> Text
renderFunctionParams (FunDoc {funDocParameters}) = T.intercalate ", " $ map parameterName funDocParameters

renderFields :: Name -> [Field e] -> Text
renderFields _ [] = mempty
renderFields name fs =
  unlinesNonEmpty
    [ "\n## Fields",
      T.intercalate "\n" (map (renderField name) fs)
    ]

renderField :: Name -> Field e -> Text
renderField modName (Field {fieldName, fieldDoc}) = do
  let name = nameToText fieldName
      parent = nameToText modName
      typ = typeToText $ fieldDocType fieldDoc
  unlinesNonEmpty
    [ "\n### `" <> name <> "`",
      fieldDocDescription fieldDoc,
      "\n```lua\n" <> parent <> "." <> name <> ": " <> typ <> "\n```"
    ]

renderFunctionDoc :: Text -> FunctionDoc -> Text
renderFunctionDoc name fd@(FunDoc {funDocDescription, funDocSince, funDocParameters, funDocResults}) =
  let sinceTag = case funDocSince of
        Nothing -> mempty
        Just version -> T.pack $ "*Since: " <> showVersion version <> "*"
   in unlinesNonEmpty
        [ renderParamTable funDocParameters,
          renderResultsDoc funDocResults,
          funDocDescription,
          "\n```lua\n" <> "function " <> name <> renderParamType funDocParameters <> (if hasReturnType funDocResults then ": " <> returnType fd else "") <> "\n```\n",
          sinceTag
        ]

renderParamTable :: [ParameterDoc] -> Text
renderParamTable [] = mempty
renderParamTable ps =
  T.unlines
    [ "#### Parameters\n",
      "| Name | Type | Description |",
      "| ---- | ---- | ----------- |",
      T.intercalate "\n" (map renderParamField ps)
    ]

renderParamType :: [ParameterDoc] -> Text
renderParamType [] = "()"
renderParamType ps = "(" <> T.intercalate ", " (map (\p -> parameterName p <> bool "" "?" (parameterIsOptional p) <> ": " <> typeToText (parameterType p)) ps) <> ")"

renderParamField :: ParameterDoc -> Text
renderParamField (ParameterDoc {parameterName, parameterDescription, parameterType, parameterIsOptional}) =
  "| `" <> parameterName <> "` | `" <> typeToText parameterType <> bool "" "?" parameterIsOptional <> "` | " <> parameterDescription <> " |"

renderResultsDoc :: ResultsDoc -> Text
renderResultsDoc (ResultsDocList []) = mempty
renderResultsDoc (ResultsDocList rds) =
  unlinesNonEmpty
    [ "#### Returns\n",
      "| Type | Description |",
      "| ---- | ----------- |",
      T.intercalate "\n" (map renderResultValueDoc rds)
    ]
renderResultsDoc (ResultsDocMult txt) = " -  " <> indent 4 txt

renderResultValueDoc :: ResultValueDoc -> Text
renderResultValueDoc (ResultValueDoc {resultValueType, resultValueDescription}) = "| `" <> typeToText resultValueType <> "` | " <> resultValueDescription <> " |"

indent :: Int -> Text -> Text
indent n = T.replace "\n" (T.replicate n " ")
