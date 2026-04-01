module HsLua.Annotations.Shared
  ( nameToText,
    typeToText,
  )
where

import Data.Char (toLower)
import Data.Text (Text)
import Data.Text qualified as T
import Data.Text.Encoding (decodeUtf8)
import HsLua.Core (Name (..), Type (..))
import HsLua.Packaging (TypeSpec (..))

nameToText :: Name -> Text
nameToText = decodeUtf8 . fromName

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
