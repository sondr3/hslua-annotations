module HsLua.Annotations.Markdown
  ( documentFunction,
    documentModule,
  )
where

import Data.Text (Text)
import HsLua.Packaging

documentFunction :: DocumentedFunction a -> Text
documentFunction = undefined

documentModule :: Module a -> Text
documentModule (Module {}) = undefined
