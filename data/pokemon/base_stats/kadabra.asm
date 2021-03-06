
    dw 00064 ;national dex no

    db  40,  35,  30, 105, 120,  70
    evs  0,   0,   0,   0,   2,   0
    ;   hp  atk  def  spd  sat  sdf

    db PSYCHIC, PSYCHIC ; type
    db 100 ; catch rate
    db 140 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_25, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/kadabra/front.dimensions"
    db SYNCHRONIZE, INNER_FOCUS     ; abilities
    db MAGIC_GUARD    ; hidden ability
    db GROWTH_MEDIUM_SLOW ; growth rate
    dn EGG_HUMAN_LIKE ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
