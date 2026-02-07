-- WALL : SUMMIT
SMODS.Blind {
    key = "summit",
    dollars = 5,
    mult = 18,
    atlas = "blinds",
    pos = { x = 0, y = 0 },
    boss = { min = 9 },
    boss_colour = HEX("6a3985"),
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips / 2
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
}

-- SERPENT : CONSTRICTOR
SMODS.Blind {
    key = "constrictor",
    dollars = 5,
    mult = 2,
    atlas = "blinds",
    pos = { x = 0, y = 1 },
    boss = { min = 9 },
    boss_colour = HEX("73aa7f"),
    modifies_draw = true,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.drawing_cards and (G.GAME.current_round.hands_played ~= 0 or G.GAME.current_round.discards_used ~= 0) then
                return {
                    cards_to_draw = 1
                }
            end
        end
    end
}

-- WHEEL : BLIND
SMODS.Blind {
    key = "blind",
    dollars = 5,
    mult = 2,
    atlas = "blinds",
    pos = { x = 0, y = 2 },
    boss = { min = 9 },
    boss_colour = HEX("22100b"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.stay_flipped and context.to_area == G.hand then
                return {
                    stay_flipped = true
                }
            end
        end
    end,
    disable = function(self)
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].facing == 'back' then
                G.hand.cards[i]:flip()
            end
        end
        for _, playing_card in pairs(G.playing_cards) do
            playing_card.ability.wheel_flipped = nil
        end
    end
}

-- HOOK : CLAW
SMODS.Blind {
    key = "claw",
    dollars = 5,
    mult = 2,
    atlas = "blinds",
    pos = { x = 0, y = 3 },
    boss = { min = 9 },
    boss_colour = HEX("9ab9cd"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.press_play then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local any_selected = nil
                        local _cards = {}
                        for _, playing_card in ipairs(G.hand.cards) do
                            _cards[#_cards + 1] = playing_card
                        end
                        for i = 1, 2 do
                            if G.hand.cards[i] then 
                                local selected_card, card_key = pseudorandom_element(_cards, pseudoseed('hook'))
                                G.hand:add_to_highlighted(selected_card, true)
                                table.remove(_cards, card_key)
                                any_selected = true
                                play_sound('card1', 1)
                            end
                        end
                        if any_selected then 
                            SMODS.destroy_cards(G.hand.highlighted)
                        end
                        return true
                    end
                }))
                blind.triggered = true 
                delay(0.7)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = (function()
                        SMODS.juice_up_blind()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.06 * G.SETTINGS.GAMESPEED,
                            blockable = false,
                            blocking = false,
                            func = function()
                                play_sound('tarot2', 0.76, 0.4); return true
                            end
                        }))
                        play_sound('tarot2', 1, 0.4)
                        return true
                    end)
                }))
                delay(0.4)
            end
        end
    end
}


-- OX : URSA
SMODS.Blind {
    key = "ursa",
    dollars = 5,
    mult = 2,
    atlas = "blinds",
    pos = { x = 0, y = 4 },
    boss = { min = 9 },
    boss_colour = HEX("6f4a09"),
    loc_vars = function(self)
        return { vars = { -G.GAME.hypb_ante_dollars } }
    end,
    collection_loc_vars = function(self)
        return { vars = { 'negative' } }
    end,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_hand then
                blind.triggered = false
                if G.GAME.hands[context.scoring_name].played > 1 then
                    blind.triggered = true
                    if not context.check then
                        ease_dollars(-G.GAME.dollars - G.GAME.hypb_ante_dollars, true)
                        blind:wiggle()
                    end
                end
            end
        end
    end
}


-- NEEDLE : THREAD
SMODS.Blind {
    key = "thread",
    dollars = 5,
    mult = 0.5,
    atlas = "blinds",
    pos = { x = 0, y = 5 },
    boss = { min = 9 },
    boss_colour = HEX("61289b"),
    defeat = function(self)
        if not G.GAME.blind.disabled then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - G.GAME.current_round.hands_left
        end
    end
}

-- CLUB : MACE
SMODS.Blind {
    key = "mace",
    dollars = 5,
    mult = 2,
    atlas = "blinds",
    pos = { x = 0, y = 6 },
    boss = { min = 9 },
    boss_colour = HEX("16c099"),
    calculate = function(self, card, context)
        if not G.GAME.blind.disabled then
            if context.hand_drawn then
                for i, v in pairs(context.hand_drawn) do
                    if v:is_suit("Clubs") then
                        v:set_ability(G.P_CENTERS.c_base)
                        v.seal = nil
                        v:set_edition()
                    end
                end
            end
        end
    end,
}

-- HEAD : CLOT
SMODS.Blind {
    key = "clot",
    dollars = 5,
    mult = 2,
    atlas = "blinds",
    pos = { x = 0, y = 7 },
    boss = { min = 9 },
    boss_colour = HEX("e02bd3"),
    calculate = function(self, card, context)
        if not G.GAME.blind.disabled then
            if context.hand_drawn then
                for i, v in pairs(context.hand_drawn) do
                    if v:is_suit("Hearts") then
                        v:set_ability(G.P_CENTERS.c_base)
                        v.seal = nil
                        v:set_edition()
                    end
                end
            end
        end
    end,
}

-- GOAD : RAZOR
SMODS.Blind {
    key = "razor",
    dollars = 5,
    mult = 2,
    atlas = "blinds",
    pos = { x = 0, y = 8 },
    boss = { min = 9 },
    boss_colour = HEX("69677a"),
    calculate = function(self, card, context)
        if not G.GAME.blind.disabled then
            if context.hand_drawn then
                for i, v in pairs(context.hand_drawn) do
                    if v:is_suit("Spades") then
                        v:set_ability(G.P_CENTERS.c_base)
                        v.seal = nil
                        v:set_edition()
                    end
                end
            end
        end
    end,
}

-- WINDOW : GLINT
SMODS.Blind {
    key = "glint",
    dollars = 5,
    mult = 2,
    atlas = "blinds",
    pos = { x = 0, y = 9 },
    boss = { min = 9 },
    boss_colour = HEX("ebb700"),
    calculate = function(self, card, context)
        if not G.GAME.blind.disabled then
            if context.hand_drawn then
                for i, v in pairs(context.hand_drawn) do
                    if v:is_suit("Diamonds") then
                        v:set_ability(G.P_CENTERS.c_base)
                        v.seal = nil
                        v:set_edition()
                    end
                end
            end
        end
    end,
}


-- PLANT : EVERGREEN
SMODS.Blind {
    key = "evergreen",
    dollars = 5,
    mult = 2,
    debuff = { is_face = true },
    atlas = "blinds",
    pos = { x = 0, y = 10 },
    boss = { min = 9 },
    boss_colour = HEX("135a3b"),
    loc_vars = function(self)
        --local numerator, denominator = SMODS.get_probability_vars(self, num, den, 'evergreen')
        return { vars = { '1', '2' } }
    end,
    collection_loc_vars = function(self)
        return { vars = { '1', '2' } }
    end,
    calculate = function(self, card, context)
        if not G.GAME.blind.disabled then
            if context.hand_drawn then
                local faces = {"Jack", "Queen", "King"}
                for i, v in pairs(context.hand_drawn) do
                    if SMODS.pseudorandom_probability(card, 'evergreen', 1, 2) then
                        SMODS.change_base(v, nil, pseudorandom_element(faces, pseudoseed("evergreen")), nil)
                    end
                end
            end
        end
    end,
    recalc_debuff = function(self, card, from_blind)
    if card:is_face(true) then
        return true
    end
    return false
end,
}

-- MARK : SIGIL
SMODS.Blind {
    key = "sigil",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 11 },
    boss = { min = 2 },
    boss_colour = HEX("50bf7c"),
    loc_vars = function(self)
        local numerator, denominator = SMODS.get_probability_vars(self, 1, 2, 'sigil')
        return { vars = { numerator, denominator } }
    end,
    collection_loc_vars = function(self)
        return { vars = { '1' } }
    end,
    
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.hand_drawn then
                local number_ranks = {"2", "3", "4", "5", "6", "7", "8", "9", "T"}
                for i, v in pairs(context.hand_drawn) do
                    if SMODS.pseudorandom_probability(card, 'sigil', 1, 2) and v:is_face() then
                        SMODS.change_base(v, nil, pseudorandom_element(number_ranks, pseudoseed("sigil")), nil)
                    end
                end
            end
            if context.stay_flipped and context.to_area == G.hand and
                not context.other_card:is_face() then
                return {
                    stay_flipped = true
                }
            end
        end
    end,
    disable = function(self)
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].facing == 'back' then
                G.hand.cards[i]:flip()
            end
        end
        for _, playing_card in pairs(G.playing_cards) do
            playing_card.ability.wheel_flipped = nil
        end
    end
}