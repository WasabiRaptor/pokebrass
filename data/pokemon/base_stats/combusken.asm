
    dw 00256 ;national dex no

    db  60,  85,  60,  55,  85,  60
    evs  0,   1,   0,   0,   1,   0
    ;   hp  atk  def  spd  sat  sdf

    db FIRE, FIGHTING ; type
    db 45 ; catch rate
    db 142 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_12_5, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/combusken/front.dimensions"
    db BLAZE, BLAZE     ; abilities
    db SPEED_BOOST    ; hidden ability
    db GROWTH_MEDIUM_SLOW ; growth rate
    dn EGG_FIELD ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
