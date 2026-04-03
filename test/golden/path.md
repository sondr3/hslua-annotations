# `path`
Module for file path manipulations.
## Fields
| Name | Type | Description |
| ---- | ---- | ----------- |
| `separator` | `string` | The character that separates directories. |
| `search_path_separator` | `string` | The character that is used to separate the entries in the `PATH` environment variable. |


## Functions

### directory (filepath)

Gets the directory name, i.e., removes the last directory separator and everything after from the given path.

*Since: 0.1.0*

Parameters:

filepath
:   path (string)

Returns:

 -  The filepath up to the last directory separator. (string)

### filename (filepath)

Get the file name.

*Since: 0.1.0*

Parameters:

filepath
:   path (string)

Returns:

 -  File name part of the input path. (string)

### is_absolute (filepath)

Checks whether a path is absolute, i.e. not fixed to a root.

*Since: 0.1.0*

Parameters:

filepath
:   path (string)

Returns:

 -  `true` iff `filepath` is an absolute path, `false` otherwise. (boolean)

### is_relative (filepath)

Checks whether a path is relative or fixed to a root.

*Since: 0.1.0*

Parameters:

filepath
:   path (string)

Returns:

 -  `true` iff `filepath` is a relative path, `false` otherwise. (boolean)

### join (filepaths)

Join path elements back together by the directory separator.

*Since: 0.1.0*

Parameters:

filepaths
:   path components ({string,...})

Returns:

 -  The joined path. (string)

### make_relative (path, root, unsafe)

Contract a filename, based on a relative path. Note that the resulting path will never introduce `..` paths, as the presence of symlinks means `../b` may not reach `a/b` if it starts from `a/c`. For a worked example see [this blog post](http://neilmitchell.blogspot.co.uk/2015/10/filepaths-are-subtle-symlinks-are-hard.html).

*Since: 0.1.0*

Parameters:

path
:   path to be made relative (string)

root
:   root path (string)

unsafe
:   whether to allow `..` in the result. (boolean)

Returns:

 -  contracted filename (string)

### normalize (filepath)

Normalizes a path.

 - `//` makes sense only as part of a (Windows) network drive;
   elsewhere, multiple slashes are reduced to a single
   `path.separator` (platform dependent).
 - `/` becomes `path.separator` (platform dependent).
 - `./` is removed.
 - an empty path becomes `.`


*Since: 0.1.0*

Parameters:

filepath
:   path (string)

Returns:

 -  The normalized path. (string)

### split (filepath)

Splits a path by the directory separator.

*Since: 0.1.0*

Parameters:

filepath
:   path (string)

Returns:

 -  List of all path components. ({string,...})

### split_extension (filepath)

Splits the last extension from a file path and returns the parts. The extension, if present, includes the leading separator; if the path has no extension, then the empty string is returned as the extension.

*Since: 0.1.0*

Parameters:

filepath
:   path (string)

Returns:

 -  filepath without extension (string)
 -  extension or empty string (string)

### split_search_path (search_path)

Takes a string and splits it on the `search_path_separator` character. Blank items are ignored on Windows, and converted to `.` on Posix. On Windows path elements are stripped of quotes.

*Since: 0.1.0*

Parameters:

search_path
:   platform-specific search path (string)

Returns:

 -  list of directories in search path ({string,...})

### treat_strings_as_paths ()

Augment the string module such that strings can be used as path objects.

*Since: 0.1.0*

Parameters:


