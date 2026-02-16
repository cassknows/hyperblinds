-- VIOLET VESSEL : EPOCH
SMODS.Blind {
    key = "final_epoch",
    dollars = 8,
    mult = 6,
    atlas = "showdowns",
    pos = { x = 0, y = 4 },
    --boss = { showdown = true },
    boss = { min = 999 },
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

--G.GAME.blind:set_text()


-- CRIMSON HEART : ETHOS
SMODS.Blind {
    key = "final_ethos",
    dollars = 8,
    mult = 6,
    atlas = "showdowns",
    pos = { x = 0, y = 0 },
    --boss = { showdown = true },
    boss = { min = 999 },
    boss_colour = HEX("ac3232"),
    loc_vars = function(self)
        return { vars = G.GAME.hypb_ethos_locs[G.GAME.hypb_evens + 1] } 
    end,
    collection_loc_vars = function(self)
        return { vars = { 'Hand', 'Joker', 'Discarding' } }
    end,
    calculate = function (self, card, context)
        if context.check then
            G.GAME.blind:set_text()
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