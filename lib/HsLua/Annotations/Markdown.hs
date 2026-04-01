module HsLua.Annotations.Markdown
  ( documentFunction,
    documentModule,
  )
where

import Data.Text (Text)
import Data.Text qualified as T
import Data.Text.Encoding qualified as T
import Data.Version (showVersion)
import HsLua.Annotations.Shared (nameToText, typeToText)
import HsLua.Core
import HsLua.Core.Utf8 qualified as Utf8
import HsLua.Packaging

documentFunction :: DocumentedFunction a -> Text
documentFunction = renderFunction

documentModule :: Module a -> Text
documentModule = renderModule

-- | Renders module documentation as Markdown.
renderModule :: Module e -> Text
renderModule mdl =
  let fields = moduleFields mdl
   in T.unlines
        [ "# " <> T.decodeUtf8 (fromName $ moduleName mdl),
          "",
          moduleDescription mdl,
          renderFields fields,
          renderFunctions (moduleFunctions mdl)
        ]

-- | Renders the full function documentation section.
renderFunctions :: [DocumentedFunction e] -> Text
renderFunctions = \case
  [] -> mempty
  fs ->
    "\n## Functions\n\n"
      <> T.intercalate "\n\n" (map (("### " <>) . renderFunction) fs)

-- | Renders documentation of a function.
renderFunction ::
  -- | function
  DocumentedFunction e ->
  -- | function docs
  Text
renderFunction fn =
  let fnDoc = functionDoc fn
      fnName = Utf8.toText $ fromName (functionName fn)
      name =
        if T.null fnName
          then "<anonymous function>"
          else fnName
   in T.intercalate
        "\n"
        [ name <> " (" <> renderFunctionParams fnDoc <> ")",
          "",
          renderFunctionDoc fnDoc
        ]

-- | Renders the parameter names of a function, separated by commas.
renderFunctionParams :: FunctionDoc -> Text
renderFunctionParams (FunDoc {funDocParameters}) =
  T.intercalate ", " $ map param funDocParameters
  where
    param (ParameterDoc {parameterName}) = parameterName

-- | Render documentation for fields as Markdown.
renderFields :: [Field e] -> Text
renderFields fs =
  if null fs
    then mempty
    else
      T.unlines
        [ "## Fields",
          "| Name | Type | Description |",
          "| ---- | ---- | ----------- |",
          T.intercalate "\n" (map renderField fs)
        ]

-- | Renders documentation for a single field.
renderField :: Field e -> Text
renderField (Field {fieldName, fieldDoc}) = "| `" <> nameToText fieldName <> "` | " <> desc fieldDoc <> " |"
  where
    desc (FieldDoc {fieldDocDescription, fieldDocType}) = "`" <> typeToText fieldDocType <> "` | " <> fieldDocDescription

--
-- Function documentation
--

-- | Renders the documentation of a function as Markdown.
renderFunctionDoc :: FunctionDoc -> Text
renderFunctionDoc (FunDoc {funDocDescription, funDocSince, funDocParameters, funDocResults}) =
  let sinceTag = case funDocSince of
        Nothing -> mempty
        Just version -> T.pack $ "\n\n*Since: " <> showVersion version <> "*"
   in ( if T.null funDocDescription
          then ""
          else funDocDescription <> sinceTag <> "\n\n"
      )
        <> renderParamDocs funDocParameters
        <> renderResultsDoc funDocResults

-- | Renders function parameter documentation as a Markdown blocks.
renderParamDocs :: [ParameterDoc] -> Text
renderParamDocs pds =
  "Parameters:\n\n"
    <> T.intercalate "\n" (map renderParamDoc pds)

-- | Renders the documentation of a function parameter as a Markdown
-- line.
renderParamDoc :: ParameterDoc -> Text
renderParamDoc pd =
  mconcat
    [ parameterName pd,
      "\n:   ",
      parameterDescription pd,
      " (",
      T.pack (typeSpecToString (parameterType pd)),
      ")\n"
    ]

-- | Renders the documentation of a function result as a Markdown list
-- item.
renderResultsDoc :: ResultsDoc -> Text
renderResultsDoc = \case
  ResultsDocList [] -> mempty
  ResultsDocList rds ->
    "\nReturns:\n\n" <> T.intercalate "\n" (map renderResultValueDoc rds)
  ResultsDocMult txt -> " -  " <> indent 4 txt

-- | Renders the documentation of a function result as a Markdown list
-- item.
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
