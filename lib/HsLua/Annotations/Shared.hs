module HsLua.Annotations.Shared (nameToText) where

import Data.Text (Text)
import Data.Text.Encoding (decodeUtf8)
import HsLua.Core (Name (..))

nameToText :: Name -> Text
nameToText = decodeUtf8 . fromName
