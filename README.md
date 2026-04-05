<h1 align="center">hslua-annotations</h1>

<p align="center">
   <a href="https://github.com/sondr3/hslua-annotations/actions"><img alt="GitHub Actions Status" src="https://github.com/sondr3/hslua-annotations/workflows/pipeline/badge.svg" /></a>
   <br />
</p>

<p align="center">
   <strong>A type annotation generator for HSLua targetting LuaLS and EmmyLua</strong>
</p>

<details>
<summary>Table of Contents</summary>
<br />

**Table of Contents**

- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

</details>

This is a small library to generate [LuaLS](https://luals.github.io/wiki/annotations) and [EmmyLua](https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/main/docs/emmylua_doc/annotations_EN/README.md) 
annotations from HsLua.

## Installation

Add `hslua-annotations` to your Cabal file:

```cabal
build-depends:
  hslua-annotations ^>= 0.1
```

## Usage

```haskell
import HsLua.Annotations (annotateModule, documentModule)
import HsLua.Module.Path qualified as Path
import HsLua.Packaging
import HsLua.Core qualified as Lua
import Data.Text (Text)
import Data.Text.IO qualified as TIO

-- utility function might be needed to narrow the `Module e` type
renderDocs :: Module Lua.Exception -> Text
renderDocs mod = documentModule mod

-- utility function might be needed to narrow the `Module e` type
renderAnnotations :: Module Lua.Exception -> Text
renderAnnotations mod = annotateModule mod

main :: IO ()
main = do
  TIO.writeFile "path.md" $ renderDocs Path.documentedModule
  TIO.writeFile "path.lua" $ renderAnnotations Path.documentedModule
```

## License

This project is licensed under either of

- Apache License, Version 2.0, ([LICENSE_APACHE](LICENSE_APACHE) or
  http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE](LICENSE) or http://opensource.org/licenses/MIT)

at your option.
