# `path`
Module for file path manipulations.

## Fields

### `separator`
The character that separates directories.

```lua
path.separator: string
```


### `search_path_separator`
The character that is used to separate the entries in the `PATH` environment variable.

```lua
path.search_path_separator: string
```


## Functions

### `function directory(filepath)`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

#### Returns

| Type | Description |
| ---- | ----------- |
| `string` | The filepath up to the last directory separator. |

Gets the directory name, i.e., removes the last directory separator and everything after from the given path.

```lua
function directory(filepath: string): string
```

*Since: 0.1.0*


### `function filename(filepath)`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

#### Returns

| Type | Description |
| ---- | ----------- |
| `string` | File name part of the input path. |

Get the file name.

```lua
function filename(filepath: string): string
```

*Since: 0.1.0*


### `function is_absolute(filepath)`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

#### Returns

| Type | Description |
| ---- | ----------- |
| `boolean` | `true` iff `filepath` is an absolute path, `false` otherwise. |

Checks whether a path is absolute, i.e. not fixed to a root.

```lua
function is_absolute(filepath: string): boolean
```

*Since: 0.1.0*


### `function is_relative(filepath)`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

#### Returns

| Type | Description |
| ---- | ----------- |
| `boolean` | `true` iff `filepath` is a relative path, `false` otherwise. |

Checks whether a path is relative or fixed to a root.

```lua
function is_relative(filepath: string): boolean
```

*Since: 0.1.0*


### `function join(filepaths)`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepaths` | `string[]` | path components |

#### Returns

| Type | Description |
| ---- | ----------- |
| `string` | The joined path. |

Join path elements back together by the directory separator.

```lua
function join(filepaths: string[]): string
```

*Since: 0.1.0*


### `function make_relative(path, root, unsafe)`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `path` | `string` | path to be made relative |
| `root` | `string` | root path |
| `unsafe` | `boolean?` | whether to allow `..` in the result. |

#### Returns

| Type | Description |
| ---- | ----------- |
| `string` | contracted filename |

Contract a filename, based on a relative path. Note that the resulting path will never introduce `..` paths, as the presence of symlinks means `../b` may not reach `a/b` if it starts from `a/c`. For a worked example see [this blog post](http://neilmitchell.blogspot.co.uk/2015/10/filepaths-are-subtle-symlinks-are-hard.html).

```lua
function make_relative(path: string, root: string, unsafe?: boolean): string
```

*Since: 0.1.0*


### `function normalize(filepath)`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

#### Returns

| Type | Description |
| ---- | ----------- |
| `string` | The normalized path. |

Normalizes a path.

 - `//` makes sense only as part of a (Windows) network drive;
   elsewhere, multiple slashes are reduced to a single
   `path.separator` (platform dependent).
 - `/` becomes `path.separator` (platform dependent).
 - `./` is removed.
 - an empty path becomes `.`


```lua
function normalize(filepath: string): string
```

*Since: 0.1.0*


### `function split(filepath)`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

#### Returns

| Type | Description |
| ---- | ----------- |
| `string[]` | List of all path components. |

Splits a path by the directory separator.

```lua
function split(filepath: string): string[]
```

*Since: 0.1.0*


### `function split_extension(filepath)`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

#### Returns

| Type | Description |
| ---- | ----------- |
| `string` | filepath without extension |
| `string` | extension or empty string |

Splits the last extension from a file path and returns the parts. The extension, if present, includes the leading separator; if the path has no extension, then the empty string is returned as the extension.

```lua
function split_extension(filepath: string): string|string
```

*Since: 0.1.0*


### `function split_search_path(search_path)`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `search_path` | `string` | platform-specific search path |

#### Returns

| Type | Description |
| ---- | ----------- |
| `string[]` | list of directories in search path |

Takes a string and splits it on the `search_path_separator` character. Blank items are ignored on Windows, and converted to `.` on Posix. On Windows path elements are stripped of quotes.

```lua
function split_search_path(search_path: string): string[]
```

*Since: 0.1.0*


### `function treat_strings_as_paths()`

Augment the string module such that strings can be used as path objects.

```lua
function treat_strings_as_paths()
```

*Since: 0.1.0*


