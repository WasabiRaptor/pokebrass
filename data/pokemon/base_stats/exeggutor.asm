
    dw 00103 ;national dex no

    db  95,  95,  85,  55, 125,  75
    evs  0,   0,   0,   0,   2,   0
    ;   hp  atk  def  spd  sat  sdf

    db GRASS, PSYCHIC ; type
    db 45 ; catch rate
    db 186 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/exeggutor/front.dimensions"
    db CHLOROPHYLL, CHLOROPHYLL     ; abilities
    db HARVEST    ; hidden ability
    db GROWTH_SLOW ; growth rate
    dn EGG_GRASS ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
