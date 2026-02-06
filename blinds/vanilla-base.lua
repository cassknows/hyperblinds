-- WALL - SUMMIT
SMODS.Blind {
    key = "summit",
    dollars = 5,
    mult = 18,
    atlas = "blinds",
    pos = { x = 0, y = 0 },
    boss = { min = 2 },
    boss_colour = HEX("6a3985"),
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips / 2
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
}