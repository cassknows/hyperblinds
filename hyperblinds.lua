

SMODS.Atlas {
  key = "blinds",
  px = 34,
  py = 34,
  path = "vanilla-base-atlas.png",
  frames = 1,
  atlas_table = "ANIMATION_ATLAS"
}

SMODS.current_mod.reset_game_globals = function(run_start)
  if run_start then
    G.GAME.hypb_ante_dollars = G.GAME.dollars
  end
end

SMODS.current_mod.calculate = function(self, context)
  if context.ante_change then
    G.GAME.hypb_ante_dollars = G.GAME.dollars
  end
  if context.individual and (context.cardarea == G.play or context.cardarea == "unscored") then
    context.other_card.ability.marble_played_ever = true
  end
end

local blind_files = NFS.getDirectoryItems(SMODS.current_mod.path .. "blinds")

for _, file in ipairs(blind_files) do
  assert(SMODS.load_file("blinds/" .. file))()
end