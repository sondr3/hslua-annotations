{-# OPTIONS_HADDOCK show-extensions #-}

-- |
-- Module: HsLua.Annotations
-- Description: A type annotation generator for HSLua
-- Copyright: (c) Sondre Aasemoen
-- SPDX-License-Identifier: (MIT OR Apache-2.0)
--
-- Maintainer: Sondre Aasemoen <sondre@eons.io>
-- Stability: experimental
-- Portability: portable
-- Safe Haskell: Safe
--
-- A type annotation generator for HSLua targetting LuaLS and EmmyLua
--
-- == Usage
--
-- To use this library you need to add it as a dependency in your project, e.g.
-- by adding it to @build-depends@ in your @.cabal@ file.
--
-- @
-- build-depends: hslua-annotations ^>= 0.1.0
-- @
--
-- This module does not use common names and can be directly imported:
--
-- @
-- __import__ HsLua.Annotations
-- @
module HsLua.Annotations
  ( -- * Type annotation
    annotateFunction,
    annotateModule,

    -- * Markdown rendering
    documentFunction,
    documentModule,
  )
where

--

import HsLua.Annotations.Internal (annotateFunction, annotateModule)
import HsLua.Annotations.Markdown (documentFunction, documentModule)
