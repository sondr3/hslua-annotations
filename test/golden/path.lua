---@meta path
---Module for file path manipulations.

---@class (exact) path
---@field separator string The character that separates directories.
---@field search_path_separator string The character that is used to separate the entries in the `PATH` environment variable.
local path = {}