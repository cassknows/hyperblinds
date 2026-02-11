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
        return { vars = { string.sub(tostring(hypb_global_time_var), -4) } } -- yes i know its not the actual MMSS, i'll adjust the exact parsing later
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