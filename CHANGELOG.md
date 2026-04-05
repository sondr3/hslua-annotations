## 0.1.0
> 2026-04-05

## Summary

Initial release of `hslua-annotations`, a utility library to generate Lua type
annotations and Markdown documentation for [hslua](https://github.com/hslua/hslua)
modules and functions.

### Commits
- [[`1aa9062`](https://github.com/sondr3/hslua-annotations/commit/1aa9062)] Add Hackage version badge
- [[`2cff0c6`](https://github.com/sondr3/hslua-annotations/commit/2cff0c6)] Add publishing step to CI
- [[`5c2a75a`](https://github.com/sondr3/hslua-annotations/commit/5c2a75a)] Add category
- [[`fe00c06`](https://github.com/sondr3/hslua-annotations/commit/fe00c06)] Update docs
- [[`6b045ad`](https://github.com/sondr3/hslua-annotations/commit/6b045ad)] Remove redundant function calls
- [[`a6ede1e`](https://github.com/sondr3/hslua-annotations/commit/a6ede1e)] Change return type to table, move description and version down
- [[`ec3becb`](https://github.com/sondr3/hslua-annotations/commit/ec3becb)] Handle [] as having no return type
- [[`331f5f0`](https://github.com/sondr3/hslua-annotations/commit/331f5f0)] Remove untyped return types
- [[`6913e1d`](https://github.com/sondr3/hslua-annotations/commit/6913e1d)] Add ? for optional params in lua block
- [[`7e2f9db`](https://github.com/sondr3/hslua-annotations/commit/7e2f9db)] Extract return type and create typed lua block for functions
- [[`3e3215c`](https://github.com/sondr3/hslua-annotations/commit/3e3215c)] Indent params properly
- [[`2b21218`](https://github.com/sondr3/hslua-annotations/commit/2b21218)] Take inspiration from rustdoc
- [[`fb38417`](https://github.com/sondr3/hslua-annotations/commit/fb38417)] Render parameter docs as a table
- [[`0ab42c9`](https://github.com/sondr3/hslua-annotations/commit/0ab42c9)] Change function headings to match fields
- [[`f398aee`](https://github.com/sondr3/hslua-annotations/commit/f398aee)] Refactor to not use LambdaCase
- [[`7e495ca`](https://github.com/sondr3/hslua-annotations/commit/7e495ca)] Fix multiline function descriptions
- [[`e085ef9`](https://github.com/sondr3/hslua-annotations/commit/e085ef9)] Add type annotations to fields
- [[`f8f5819`](https://github.com/sondr3/hslua-annotations/commit/f8f5819)] Refactor field rendering some more
- [[`d9826e4`](https://github.com/sondr3/hslua-annotations/commit/d9826e4)] Create utility function for filtering unlines
- [[`5bdf26c`](https://github.com/sondr3/hslua-annotations/commit/5bdf26c)] Wrap module headings with backticks
- [[`b937e35`](https://github.com/sondr3/hslua-annotations/commit/b937e35)] Remove comments, refactor things slightly
- [[`2a8b825`](https://github.com/sondr3/hslua-annotations/commit/2a8b825)] Render class fields as a table
- [[`2a0aaac`](https://github.com/sondr3/hslua-annotations/commit/2a0aaac)] Extract 'typeToText' to shared module
- [[`47c463b`](https://github.com/sondr3/hslua-annotations/commit/47c463b)] Import old, deprecated render functionality, update to latest HsLua
- [[`ed7d2f8`](https://github.com/sondr3/hslua-annotations/commit/ed7d2f8)] Extract shared functions to shared module
- [[`004b1ed`](https://github.com/sondr3/hslua-annotations/commit/004b1ed)] Rejigger tests, add annotation and markdown test trees
- [[`9d4ed09`](https://github.com/sondr3/hslua-annotations/commit/9d4ed09)] Start sketching out markdown rendering
- [[`a8b0827`](https://github.com/sondr3/hslua-annotations/commit/a8b0827)] Split out the annotation into an internal file
- [[`a071088`](https://github.com/sondr3/hslua-annotations/commit/a071088)] Implement 'typeToText' to better align with annotations
- [[`4aa5f81`](https://github.com/sondr3/hslua-annotations/commit/4aa5f81)] Slacken text package requirements
- [[`34b76cb`](https://github.com/sondr3/hslua-annotations/commit/34b76cb)] Minor README adjustments
- [[`e7b2247`](https://github.com/sondr3/hslua-annotations/commit/e7b2247)] Rename annotateMethod... not really a thing in Lua
- [[`37901ee`](https://github.com/sondr3/hslua-annotations/commit/37901ee)] Filter out empty function descriptions
- [[`285b8ed`](https://github.com/sondr3/hslua-annotations/commit/285b8ed)] Add dependabot
- [[`d86ec4c`](https://github.com/sondr3/hslua-annotations/commit/d86ec4c)] Remove unused dependencies, move test only to test package
- [[`cb45364`](https://github.com/sondr3/hslua-annotations/commit/cb45364)] Add README and document things
- [[`605f044`](https://github.com/sondr3/hslua-annotations/commit/605f044)] Remove duplicate function annotation function
- [[`6099d8e`](https://github.com/sondr3/hslua-annotations/commit/6099d8e)] Filter out empty lines
- [[`dff4da6`](https://github.com/sondr3/hslua-annotations/commit/dff4da6)] And annotate operators
- [[`fbf3e27`](https://github.com/sondr3/hslua-annotations/commit/fbf3e27)] Use T.unlines to make multilines more readable
- [[`2a5523b`](https://github.com/sondr3/hslua-annotations/commit/2a5523b)] Annotate module functions
- [[`54843d0`](https://github.com/sondr3/hslua-annotations/commit/54843d0)] Stick with GHC 9.12 for now
- [[`5700b5e`](https://github.com/sondr3/hslua-annotations/commit/5700b5e)] Fix hlint suggestions
- [[`3c9fe23`](https://github.com/sondr3/hslua-annotations/commit/3c9fe23)] Start sketching out module annotation, test on hslua-module-path
- [[`bb48b5d`](https://github.com/sondr3/hslua-annotations/commit/bb48b5d)] Move factorial to test file
- [[`99e1e70`](https://github.com/sondr3/hslua-annotations/commit/99e1e70)] Add a Justfile for running things
- [[`84a1e1b`](https://github.com/sondr3/hslua-annotations/commit/84a1e1b)] Add parameter annotations to functions
- [[`d81deb6`](https://github.com/sondr3/hslua-annotations/commit/d81deb6)] Get the function description and output it too
- [[`f9f1de5`](https://github.com/sondr3/hslua-annotations/commit/f9f1de5)] Correct pipeline name
- [[`969bf50`](https://github.com/sondr3/hslua-annotations/commit/969bf50)] Add CI pipeline
- [[`34d0bce`](https://github.com/sondr3/hslua-annotations/commit/34d0bce)] Fix unused imports
- [[`1c1c666`](https://github.com/sondr3/hslua-annotations/commit/1c1c666)] Initial pass at getting types from HsLua
- [[`1dfaa20`](https://github.com/sondr3/hslua-annotations/commit/1dfaa20)] In the beginning there was darkness...

