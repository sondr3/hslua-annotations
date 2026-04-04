# `Version`
Version specifier handling

## Functions

### `must_be_at_least(self, reference, msg)`

Parameters:

self
:   version to check (Version)

reference
:   minimum version (Version)

msg
:   alternative message (string)
 -  Returns no result, and throws an error if this version is older than `reference`.

