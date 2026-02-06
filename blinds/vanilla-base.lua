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