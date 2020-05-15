
    dw 00257 ;national dex no

    db  80, 120,  70,  80, 110,  70
    evs  0,   3,   0,   0,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db FIRE, FIGHTING ; type
    db 45 ; catch rate
    db 239 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_12_5, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/blaziken/front.dimensions"
    db BLAZE, BLAZE     ; abilities
    db SPEED_BOOST    ; hidden ability
    db GROWTH_MEDIUM_SLOW ; growth rate
    dn EGG_FIELD ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
