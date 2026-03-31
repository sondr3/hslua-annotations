---@meta path
---Module for file path manipulations.

---@class (exact) path
---@field separator string The character that separates directories.
---@field search_path_separator string The character that is used to separate the entries in the `PATH` environment variable.
local path = {}

---Gets the directory name, i.e., removes the last directory separator and everything after from the given path.
---@param filepath string path
---@return string
function path.directory(filepath)

---Get the file name.
---@param filepath string path
---@return string
function path.filename(filepath)

---Checks whether a path is absolute, i.e. not fixed to a root.
---@param filepath string path
---@return boolean
function path.is_absolute(filepath)

---Checks whether a path is relative or fixed to a root.
---@param filepath string path
---@return boolean
function path.is_relative(filepath)

---Join path elements back together by the directory separator.
---@param filepaths {string,...} path components
---@return string
function path.join(filepaths)

---Contract a filename, based on a relative path. Note that the resulting path will never introduce `..` paths, as the presence of symlinks means `../b` may not reach `a/b` if it starts from `a/c`. For a worked example see [this blog post](http://neilmitchell.blogspot.co.uk/2015/10/filepaths-are-subtle-symlinks-are-hard.html).
---@param path string path to be made relative
---@param root string root path
---@param unsafe? boolean whether to allow `..` in the result.
---@return string
function path.make_relative(path, root, unsafe)

---Normalizes a path.

 - `//` makes sense only as part of a (Windows) network drive;
   elsewhere, multiple slashes are reduced to a single
   `path.separator` (platform dependent).
 - `/` becomes `path.separator` (platform dependent).
 - `./` is removed.
 - an empty path becomes `.`

---@param filepath string path
---@return string
function path.normalize(filepath)

---Splits a path by the directory separator.
---@param filepath string path
---@return {string,...}
function path.split(filepath)

---Splits the last extension from a file path and returns the parts. The extension, if present, includes the leading separator; if the path has no extension, then the empty string is returned as the extension.
---@param filepath string path
---@return string|string
function path.split_extension(filepath)

---Takes a string and splits it on the `search_path_separator` character. Blank items are ignored on Windows, and converted to `.` on Posix. On Windows path elements are stripped of quotes.
---@param search_path string platform-specific search path
---@return {string,...}
function path.split_search_path(search_path)

---Augment the string module such that strings can be used as path objects.
---@return 
function path.treat_strings_as_paths()

