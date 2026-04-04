---@meta Version
---Version specifier handling

---@class (exact) Version
---@operator call:Version
local Version = {}

---@param self Version version to check
---@param reference Version minimum version
---@param msg? string alternative message
function Version.must_be_at_least(self, reference, msg)

