
    dw 00571 ;national dex no

    db  60, 105,  60, 105, 120,  60
    evs  0,   0,   0,   0,   2,   0
    ;   hp  atk  def  spd  sat  sdf

    db DARK, DARK ; type
    db 45 ; catch rate
    db 179 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_12_5, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/zoroark/front.dimensions"
    db ILLUSION, ILLUSION     ; abilities
    db ILLUSION    ; hidden ability
    db GROWTH_MEDIUM_SLOW ; growth rate
    dn EGG_FIELD ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
