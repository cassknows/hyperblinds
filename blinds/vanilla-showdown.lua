-- VIOLET VESSEL : EPOCH
SMODS.Blind {
    key = "final_epoch",
    dollars = 8,
    mult = 6,
    atlas = "showdowns",
    pos = { x = 0, y = 4 },
    boss = {
		min = 15,
		showdown = true
	},
    boss_colour = HEX("8a71e1"),
    loc_vars = function(self)
        return { vars = { string.sub(tostring(G.GAME.hypb_global_time_var), -4) } } -- yes i know its not the actual MMSS, i'll adjust the exact parsing later
    end,
    collection_loc_vars = function(self)
        return { vars = { 'MMSS' } }
    end,
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips / 3
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
}



-- CRIMSON HEART : ETHOS
SMODS.Blind {
    key = "final_ethos",
    dollars = 8,
    mult = 6,
    atlas = "showdowns",
    pos = { x = 0, y = 0 },
    boss = {
		min = 15,
		showdown = true
	},
    boss_colour = HEX("ac3232"),
    loc_vars = function(self)
        return { vars = G.GAME.hypb_ethos_locs[G.GAME.hypb_evens + 1] } 
    end,
    collection_loc_vars = function(self)
        return { vars = { 'Hand', 'Joker', 'Discarding' } }
    end,
    calculate = function (self, card, context)
        if context.check then
            G.GAME.blind.loc_debuff_lines = {}
            G.FUNCS.HUD_blind_debuff(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
            G.GAME.blind:set_text()
            G.FUNCS.HUD_blind_debuff(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
        end
        if context.setting_blind then
            if G.jokers.cards[1] then
                local jokers = {}
                for i = 1, #G.jokers.cards do
                    if (not G.jokers.cards[i].debuff and not G.jokers.cards[i].ability.ethos_perma_debuff) or #G.jokers.cards < 2 then jokers[#jokers+1] = G.jokers.cards[i] end
                    G.jokers.cards[i]:set_debuff(false)
                    if G.jokers.cards[i].ability.ethos_temp_debuff == true then
                        G.jokers.cards[i].ability.ethos_perma_debuff = true
                        G.jokers.cards[i]:set_debuff(true)
                    end
                end
                local _card = pseudorandom_element(jokers, pseudoseed('ETHOS'))
                if _card then
                    _card:set_debuff(true)
                    _card:juice_up()
                    _card.ability.ethos_temp_debuff = true
                end
            end
            G.GAME.hypb_ethos_debuff_rank = pseudorandom_element(G.GAME.hypb_ethos_ranks, pseudoseed('ETHOS'))
        end
        if context.hand_drawn then
            for i, v in pairs(context.hand_drawn) do
                if v:get_id() == G.GAME.hypb_ethos_debuff_rank then
                    v:set_debuff(true)
                    v:juice_up()
                end
            end
        end
        if context.press_play then
            for i, rank in ipairs(G.GAME.hypb_ethos_ranks) do
                 if rank == G.GAME.hypb_ethos_debuff_rank then
                    table.remove(G.GAME.hypb_ethos_ranks, i)
                 end
            end
            G.GAME.hypb_ethos_perma[G.GAME.hypb_ethos_debuff_rank] = true
            G.GAME.hypb_ethos_debuff_rank = pseudorandom_element(G.GAME.hypb_ethos_ranks, pseudoseed('ETHOS'))
            if G.jokers.cards[1] then
                local jokers = {}
                for i = 1, #G.jokers.cards do
                    if (not G.jokers.cards[i].debuff and not G.jokers.cards[i].ability.ethos_perma_debuff) or #G.jokers.cards < 2 then jokers[#jokers+1] = G.jokers.cards[i] end
                    G.jokers.cards[i]:set_debuff(false)
                end
                local _card = pseudorandom_element(jokers, pseudoseed('ETHOS'))
                if _card then
                    _card:set_debuff(true)
                    _card:juice_up()
                    _card.ability.ethos_temp_debuff = true
                end
            end
        end
        if context.pre_discard then
            G.GAME.hypb_ethos_debuff_rank = pseudorandom_element(G.GAME.hypb_ethos_ranks, pseudoseed('ETHOS'))
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if (not G.jokers.cards[i].debuff and not G.jokers.cards[i].ability.ethos_perma_debuff) or #G.jokers.cards < 2 then jokers[#jokers+1] = G.jokers.cards[i] end
                G.jokers.cards[i]:set_debuff(false)
                if G.jokers.cards[i].ability.ethos_temp_debuff == true then
                    G.jokers.cards[i].ability.ethos_perma_debuff = true
                    G.jokers.cards[i]:set_debuff(true)
                end
            end
            local _card = pseudorandom_element(jokers, pseudoseed('ETHOS'))
            if _card then
                _card:set_debuff(true)
                _card:juice_up()
                _card.ability.ethos_temp_debuff = true
            end
        end
    end,
    recalc_debuff = function(self, card)
        if card:get_id() == G.GAME.hypb_ethos_debuff_rank then
            return true
        end
        if card.ability.ethos_temp_debuff == true then
            return true
        end
        return false
    end,
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips / 3
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end,
    defeat = function(self)
        if not G.GAME.blind.disabled then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.ethos_temp_debuff == true and G.jokers.cards[i].ability.ethos_perma_debuff ~= true then
                    G.jokers.cards[i].ability.ethos_temp_debuff = nil
                end
            end
        end
    end
}

-- VERDANT LEAF : REIGN
SMODS.Blind {
    key = "final_reign",
    dollars = 8,
    mult = 6,
    atlas = "showdowns",
    pos = { x = 0, y = 3 },
    boss = {
		min = 15,
		showdown = true
	},
    boss_colour = HEX("325763"),
    loc_vars = function(self)
        return { vars = { G.GAME.hypb_reign_sell } }
    end,
    collection_loc_vars = function(self)
        return { vars = { '1' } }
    end,
    calculate = function(self, blind, context)
        if context.setting_blind then
            G.GAME.hypb_reign_sell = 1
        end
        if context.selling_card and context.card.ability.set == 'Joker'then
            G.GAME.hypb_reign_sell = math.max(0, G.GAME.hypb_reign_sell - 1)
            G.GAME.blind.loc_debuff_lines = {}
            G.FUNCS.HUD_blind_debuff(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
            G.GAME.blind:set_text()
            G.FUNCS.HUD_blind_debuff(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
        end
        if context.pre_discard or context.press_play then
            G.GAME.hypb_reign_sell = G.GAME.hypb_reign_sell + 1
            G.GAME.blind.loc_debuff_lines = {}
            G.FUNCS.HUD_blind_debuff(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
            G.GAME.blind:set_text()
            G.FUNCS.HUD_blind_debuff(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
        end
        if (context.after or context.pre_discard or context.hand_drawn) and G.GAME.hypb_reign_sell > 0.1 then
            for _, card in ipairs(G.hand.cards) do
                card:set_debuff(true)
            end
        end
    end,
    recalc_debuff = function(self, card)
        if G.GAME.hypb_reign_sell > 0.1 and card.area ~= G.jokers then
            return true
        end
        return false
    end
}

-- AMBER ACORN : LETHE
SMODS.Blind {
    key = "final_lethe",
    dollars = 8,
    mult = 6,
    atlas = "showdowns",
    pos = { x = 0, y = 2 },
    boss = {
		min = 15,
		showdown = true
	},
    boss_colour = HEX("e8a711"),
    calculate = function(self, blind, context)
		if context.check and not G.GAME.blind.disabled then
			if #G.jokers.cards > 1 then
				local joker_1 = pseudorandom("lethe_joker1", 1, #G.jokers.cards)
				local joker_2 = pseudorandom("lethe_joker2", 1, #G.jokers.cards)
				local tries = 20
				while G.jokers.cards[joker_2] == G.jokers.cards[joker_1] and tries > 0 do
					joker_2 = pseudorandom("lethe_joker2_reroll", 1, #G.jokers.cards)
					tries = tries - 1
				end
				local temp = G.jokers.cards[joker_2]
				G.jokers.cards[joker_2] = G.jokers.cards[joker_1]
				G.jokers.cards[joker_1] = temp
                G.jokers.cards[joker_1]:flip()
                if G.jokers.cards[joker_2] ~= 'back' and math.random() > 0.5 then
                    G.jokers.cards[joker_2]:flip()
                end
			end
            if #G.hand.cards > 1 then
				local hand_1 = pseudorandom("lethe_hand1", 1, #G.hand.cards)
				local hand_2 = pseudorandom("lethe_hand2", 1, #G.hand.cards)
				local tries = 20
				while G.hand.cards[hand_2] == G.hand.cards[hand_1] and tries > 0 do
					hand_2 = pseudorandom("lethe_hand2_reroll", 1, #G.hand.cards)
					tries = tries - 1
				end
				local temp = G.hand.cards[hand_2]
				G.hand.cards[hand_2] = G.hand.cards[hand_1]
				G.hand.cards[hand_1] = temp
                --if G.hand.cards[hand_1] ~= 'back' and G.hand.cards[hand_1].ability.sometimes_face_down ~= true then
                    G.hand.cards[hand_1]:flip()
                --end
                --if G.hand.cards[hand_2] ~= 'back' and G.hand.cards[hand_2].ability.sometimes_face_down ~= true then
                    G.hand.cards[hand_2]:flip()
                --end
                G.hand.cards[hand_1].ability.sometimes_face_down = true
                G.hand.cards[hand_2].ability.sometimes_face_down = true
			end
		end
	end
}


-- CERULEAN BELL : ICHOR
SMODS.Blind {
    key = "final_ichor",
    dollars = 8,
    mult = 6,
    atlas = "showdowns",
    pos = { x = 0, y = 1 },
    boss = {
		min = 15,
		showdown = true
	},
    boss_colour = HEX("009cfd"),
    loc_vars = function(self)
        return { vars = { localize(G.GAME.hypb_ichor_suit, "suits_plural") } }
    end,
    collection_loc_vars = function(self)
        return { vars = { 'suit' } }
    end,
    calculate = function(self, blind, context)
        if context.hand_drawn then
            hypb_ichor_suit_picker()
            G.GAME.blind.loc_debuff_lines = {}
            G.FUNCS.HUD_blind_debuff(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
            G.GAME.blind:set_text()
            G.FUNCS.HUD_blind_debuff(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
        end
    end
}