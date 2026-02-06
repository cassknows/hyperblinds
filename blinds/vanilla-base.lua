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