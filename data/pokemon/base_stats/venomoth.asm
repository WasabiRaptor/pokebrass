
    dw 00049 ;national dex no

    db  70,  65,  60,  90,  90,  75
    evs  0,   0,   0,   1,   1,   0
    ;   hp  atk  def  spd  sat  sdf

    db BUG, POISON ; type
    db 75 ; catch rate
    db 158 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/venomoth/front.dimensions"
    db SHIELD_DUST, TINTED_LENS     ; abilities
    db WONDER_SKIN    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_BUG ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
