
local blind_files = NFS.getDirectoryItems(SMODS.current_mod.path .. "blinds")

for _, file in ipairs(blind_files) do
  assert(SMODS.load_file("blinds/" .. file))()
end