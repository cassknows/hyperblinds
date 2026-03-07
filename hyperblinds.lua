SMODS.Atlas {
  key = "blinds",
  px = 42,
  py = 42,
  path = "vanilla-base-atlas.png",
  frames = 1,
  atlas_table = "ANIMATION_ATLAS"
}

SMODS.Atlas {
  key = "showdowns",
  px = 34,
  py = 34,
  path = "vanilla-showdown-atlas.png",
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
    G.GAME.hypb_flytrap_hands = {}
    G.GAME.hypb_iris_hands = {}
    G.GAME.hypb_ethos_ranks = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}
    G.GAME.hypb_ethos_perma = {}
    G.GAME.hypb_ethos_debuff_rank = ''
    G.GAME.hypb_ethos_locs = {{ 'Discard', 'Rank', 'Playing' }, { 'Hand', 'Joker', 'Discarding' }}
    G.GAME.hypb_evens = 0
    G.GAME.hypb_reign_sell = 1
    G.GAME.hypb_ichor_suit = "Hearts"
    G.GAME.hypb_epoch_scale = -10
  end
end

function hypb_ichor_suit_picker()
  local tempcard = G.hand.cards[pseudorandom("ichor_suit", 1, #G.hand.cards)]
  local ticker = 20
  while SMODS.has_no_suit(tempcard) and tempcard.base.suit ~= "entr_nilsuit" and ticker > 0 do
    tempcard = G.hand.cards[pseudorandom("ichor_suit", 1, #G.hand.cards)]
    ticker = ticker - 1
  end
  G.GAME.hypb_ichor_suit = tempcard.base.suit
end

local ca_ath = CardArea.add_to_highlighted
function CardArea:add_to_highlighted(card, silent)
  if card and not (G.GAME.blind.config.blind.key == "bl_hypb_final_ichor" and 
  not ((card:is_suit(G.GAME.hypb_ichor_suit)) or
  (G.GAME.hypb_ichor_suit == "entr_nilsuit" and card.base.suit == "entr_nilsuit")
  or ( SMODS.has_no_suit(card) and card.base.suit ~= "entr_nilsuit"))) then
      ca_ath(self, card, silent)
  else if G.GAME.blind.config.blind.key == "bl_hypb_final_ichor" then
      for _, v in pairs(G.hand.cards) do
        if v:is_suit(G.GAME.hypb_ichor_suit) or (G.GAME.hypb_ichor_suit == "entr_nilsuit" and card.base.suit == "entr_nilsuit")then
          return
        end
      end
      hypb_ichor_suit_picker()
      G.GAME.blind.loc_debuff_lines = {}
      G.FUNCS.HUD_blind_debuff(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
      G.GAME.blind:set_text()
      G.FUNCS.HUD_blind_debuff(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
    end
  end
end


SMODS.current_mod.set_debuff = function(card)
  if G.GAME.hypb_ethos_perma[card:get_id()] ~= nil then
    return true
  end
  if (card.ability.ethos_perma_debuff == true) then
    return true
  end
end

local cdt = 0
local update_ref = Game.update
Game.update = function(self, dt)
  local ret = update_ref(self, dt)
  G.GAME.hypb_global_time_var = os.time()
  if G.GAME.blind and G.GAME.blind.config.blind.key == "bl_hypb_final_epoch" then
      cdt = cdt + dt
      if cdt >= 1 then
        cdt = 0
        
        if G.STATE == G.STATES.HAND_PLAYED or G.SETTINGS.paused then else
          G.GAME.blind.chips = G.GAME.blind.chips * (1 + G.GAME.hypb_epoch_scale/100)
          G.GAME.hypb_epoch_scale = G.GAME.hypb_epoch_scale + 1
          G.GAME.blind:juice_up()
          G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
          G.HUD_blind:recalculate()
        end

        G.GAME.blind.loc_debuff_lines = {}
        G.FUNCS.HUD_blind_debuff(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
        G.GAME.blind:set_text()
        G.FUNCS.HUD_blind_debuff(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
      end
  end
  return ret
end


SMODS.current_mod.calculate = function(self, context)
  if context.check then
    G.GAME.hypb_evens = math.fmod(G.GAME.hypb_evens + 1, 2)
  end
  if context.ante_change then
    G.GAME.hypb_ante_dollars = G.GAME.dollars
  end
  if context.individual and (context.cardarea == G.play or context.cardarea == "unscored") then
    context.other_card.ability.marble_played_ever = true
  end
  if context.hand_drawn then
    for _, v in pairs(context.hand_drawn) do
      if math.random() < 0.7 and v.ability.sometimes_face_down and v.facing ~= "back" then
        v:flip()
      end
      if G.GAME.hypb_ethos_perma[v:get_id()] ~= nil then
        v:set_debuff(true)
        v:juice_up()
      end
    end
  end
  if context.stay_flipped and context.other_card.sometimes_face_down then
    return {
      stay_flipped = true
    }
  end
  if context.before and G.GAME.hypb_flytrap_hands[context.scoring_name] then
      G.GAME.current_round.hands_left = G.GAME.current_round.hands_left - 1
  end
  if context.after then
    se_carry = prand(context.scoring_name .. tostring(context.scoring_name.played) .. tostring(se_carry) .. tostring(G.GAME.round_resets.ante))
  end
  if context.debuff_hand then
    if context.scoring_name and G.GAME.hypb_iris_hands[context.scoring_name] ~= nil then
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