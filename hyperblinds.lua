

SMODS.Atlas {
  key = "blinds",
  px = 34,
  py = 34,
  path = "vanilla-base-atlas.png",
  frames = 1,
  atlas_table = "ANIMATION_ATLAS"
}

local blind_files = NFS.getDirectoryItems(SMODS.current_mod.path .. "blinds")

for _, file in ipairs(blind_files) do
  assert(SMODS.load_file("blinds/" .. file))()
end