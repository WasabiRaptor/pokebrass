
    dw 00073 ;national dex no

    db  80,  70,  65, 100,  80, 120
    evs  0,   0,   0,   0,   0,   2
    ;   hp  atk  def  spd  sat  sdf

    db WATER, POISON ; type
    db 60 ; catch rate
    db 180 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/tentacruel/front.dimensions"
    db CLEAR_BODY, LIQUID_OOZE     ; abilities
    db RAIN_DISH    ; hidden ability
    db GROWTH_SLOW ; growth rate
    dn EGG_WATER_3 ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
