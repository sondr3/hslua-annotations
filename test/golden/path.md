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

Gets the directory name, i.e., removes the last directory separator and everything after from the given path.

*Since: 0.1.0*

## Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

Returns:

 -  The filepath up to the last directory separator. (string)


### `function filename(filepath)`

Get the file name.

*Since: 0.1.0*

## Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

Returns:

 -  File name part of the input path. (string)


### `function is_absolute(filepath)`

Checks whether a path is absolute, i.e. not fixed to a root.

*Since: 0.1.0*

## Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

Returns:

 -  `true` iff `filepath` is an absolute path, `false` otherwise. (boolean)


### `function is_relative(filepath)`

Checks whether a path is relative or fixed to a root.

*Since: 0.1.0*

## Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

Returns:

 -  `true` iff `filepath` is a relative path, `false` otherwise. (boolean)


### `function join(filepaths)`

Join path elements back together by the directory separator.

*Since: 0.1.0*

## Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepaths` | `string[]` | path components |

Returns:

 -  The joined path. (string)


### `function make_relative(path, root, unsafe)`

Contract a filename, based on a relative path. Note that the resulting path will never introduce `..` paths, as the presence of symlinks means `../b` may not reach `a/b` if it starts from `a/c`. For a worked example see [this blog post](http://neilmitchell.blogspot.co.uk/2015/10/filepaths-are-subtle-symlinks-are-hard.html).

*Since: 0.1.0*

## Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `path` | `string` | path to be made relative |
| `root` | `string` | root path |
| `unsafe` | `boolean?` | whether to allow `..` in the result. |

Returns:

 -  contracted filename (string)


### `function normalize(filepath)`

Normalizes a path.

 - `//` makes sense only as part of a (Windows) network drive;
   elsewhere, multiple slashes are reduced to a single
   `path.separator` (platform dependent).
 - `/` becomes `path.separator` (platform dependent).
 - `./` is removed.
 - an empty path becomes `.`


*Since: 0.1.0*

## Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

Returns:

 -  The normalized path. (string)


### `function split(filepath)`

Splits a path by the directory separator.

*Since: 0.1.0*

## Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

Returns:

 -  List of all path components. ({string,...})


### `function split_extension(filepath)`

Splits the last extension from a file path and returns the parts. The extension, if present, includes the leading separator; if the path has no extension, then the empty string is returned as the extension.

*Since: 0.1.0*

## Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `filepath` | `string` | path |

Returns:

 -  filepath without extension (string)
 -  extension or empty string (string)


### `function split_search_path(search_path)`

Takes a string and splits it on the `search_path_separator` character. Blank items are ignored on Windows, and converted to `.` on Posix. On Windows path elements are stripped of quotes.

*Since: 0.1.0*

## Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `search_path` | `string` | platform-specific search path |

Returns:

 -  list of directories in search path ({string,...})


### `function treat_strings_as_paths()`

Augment the string module such that strings can be used as path objects.

*Since: 0.1.0*



