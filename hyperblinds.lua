SMODS.Atlas {
  key = "blinds",
  px = 34,
  py = 34,
  path = "vanilla-base-atlas.png",
  frames = 1,
  atlas_table = "ANIMATION_ATLAS"
}

SMODS.Atlas {
    key = "modicon",
    path = "hypb_ico.png",
    px = 34,
    py = 34,
}:register()

function prand(str)
    local h = 31
    for i = 1, #str do
       h = math.fmod(h*32 + h + str:byte(i), 65536)
    end
    return h/65536
end

local se_carry = 0.918772

SMODS.current_mod.reset_game_globals = function(run_start)
  if run_start then
    G.GAME.hypb_ante_dollars = G.GAME.dollars
    flytrap_hands = {}
    iris_hands = {}
  end
end


SMODS.current_mod.calculate = function(self, context)
  if context.ante_change then
    G.GAME.hypb_ante_dollars = G.GAME.dollars
  end
  if context.individual and (context.cardarea == G.play or context.cardarea == "unscored") then
    context.other_card.ability.marble_played_ever = true
  end
  if context.hand_drawn then
    for i, v in pairs(context.hand_drawn) do
      if math.random() < 0.7 and v.ability.sometimes_face_down and v.facing ~= "back"then
        v:flip()
      end
    end
  end
  if context.stay_flipped and context.other_card.sometimes_face_down then
    return {
      stay_flipped = true
    }
  end
  if context.before and flytrap_hands[context.scoring_name] then
      G.GAME.current_round.hands_left = G.GAME.current_round.hands_left - 1
  end
  if context.after then
    se_carry = prand(context.scoring_name .. tostring(context.scoring_name.played) .. tostring(se_carry) .. tostring(G.GAME.round_resets.ante))
  end
  if context.debuff_hand then
    if iris_hands[context.scoring_name] == true and context.scoring_name then
      if se_carry < 0.1666 then
        return {
          debuff = true,
          debuff_text = "IRIS is watching"
        }
      end
    end
  end
end

local blind_files = NFS.getDirectoryItems(SMODS.current_mod.path .. "blinds")

for _, file in ipairs(blind_files) do
  assert(SMODS.load_file("blinds/" .. file))()
end