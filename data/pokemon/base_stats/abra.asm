
    dw 00063 ;national dex no

    db  25,  20,  15,  90, 105,  55
    evs  0,   0,   0,   0,   1,   0
    ;   hp  atk  def  spd  sat  sdf

    db PSYCHIC, PSYCHIC ; type
    db 200 ; catch rate
    db 62 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_25, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/abra/front.dimensions"
    db SYNCHRONIZE, INNER_FOCUS     ; abilities
    db MAGIC_GUARD    ; hidden ability
    db GROWTH_MEDIUM_SLOW ; growth rate
    dn EGG_HUMAN_LIKE ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
