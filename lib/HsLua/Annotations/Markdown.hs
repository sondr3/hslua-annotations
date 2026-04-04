module HsLua.Annotations.Markdown
  ( documentFunction,
    documentModule,
  )
where

import Data.Bool (bool)
import Data.Text (Text)
import Data.Text qualified as T
import Data.Version (showVersion)
import HsLua.Annotations.Shared (nameToText, typeToText, unlinesNonEmpty)
import HsLua.Core
import HsLua.Core.Utf8 qualified as Utf8
import HsLua.Packaging

documentFunction :: DocumentedFunction a -> Text
documentFunction = renderFunction

documentModule :: Module a -> Text
documentModule = renderModule

renderModule :: Module e -> Text
renderModule (Module {moduleFields, moduleName, moduleDescription, moduleFunctions}) =
  unlinesNonEmpty
    [ "# `" <> nameToText moduleName <> "`",
      moduleDescription,
      renderFields moduleName moduleFields,
      renderFunctions moduleFunctions
    ]

renderFunctions :: [DocumentedFunction e] -> Text
renderFunctions [] = mempty
renderFunctions fs = "\n## Functions\n\n" <> T.intercalate "\n\n" (map (("### " <>) . renderFunction) fs)

renderFunction :: DocumentedFunction e -> Text
renderFunction fn =
  let fnDoc = functionDoc fn
      fnName = Utf8.toText $ fromName (functionName fn)
      name =
        if T.null fnName
          then "<anonymous function>"
          else fnName
   in unlinesNonEmpty
        [ "`" <> name <> "(" <> renderFunctionParams fnDoc <> ")" <> "`\n",
          renderFunctionDoc fnDoc
        ]

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

renderFunctionDoc :: FunctionDoc -> Text
renderFunctionDoc (FunDoc {funDocDescription, funDocSince, funDocParameters, funDocResults}) =
  let sinceTag = case funDocSince of
        Nothing -> mempty
        Just version -> T.pack $ "\n\n*Since: " <> showVersion version <> "*"
   in ( if T.null funDocDescription
          then ""
          else funDocDescription <> sinceTag <> "\n\n"
      )
        <> renderParamTable funDocParameters
        <> renderResultsDoc funDocResults

renderParamTable :: [ParameterDoc] -> Text
renderParamTable [] = ""
renderParamTable ps =
  T.unlines
    [ "## Parameters\n",
      "| Name | Type | Description |",
      "| ---- | ---- | ----------- |",
      T.intercalate "\n" (map renderParamField ps)
    ]

renderParamField :: ParameterDoc -> Text
renderParamField (ParameterDoc {parameterName, parameterDescription, parameterType, parameterIsOptional}) =
  "| `" <> parameterName <> "` | `" <> typeToText parameterType <> bool "" "?" parameterIsOptional <> "` | " <> parameterDescription <> " |"

renderResultsDoc :: ResultsDoc -> Text
renderResultsDoc (ResultsDocList []) = mempty
renderResultsDoc (ResultsDocList rds) = "\nReturns:\n\n" <> T.intercalate "\n" (map renderResultValueDoc rds)
renderResultsDoc (ResultsDocMult txt) = " -  " <> indent 4 txt

renderResultValueDoc :: ResultValueDoc -> Text
renderResultValueDoc rd =
  mconcat
    [ " -  ",
      resultValueDescription rd,
      " (",
      T.pack (typeSpecToString $ resultValueType rd),
      ")"
    ]

indent :: Int -> Text -> Text
indent n = T.replace "\n" (T.replicate n " ")
