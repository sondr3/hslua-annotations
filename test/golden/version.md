# `Version`
Version specifier handling

## Functions

### `function must_be_at_least(self, reference, msg)`

## Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| `self` | `Version` | version to check |
| `reference` | `Version` | minimum version |
| `msg` | `string?` | alternative message |
 -  Returns no result, and throws an error if this version is older than `reference`.

