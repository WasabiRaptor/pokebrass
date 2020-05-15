
    dw 00144 ;national dex no

    db  90,  85, 100,  85,  95, 125
    evs  0,   0,   0,   0,   0,   3
    ;   hp  atk  def  spd  sat  sdf

    db ICE, FLYING ; type
    db 3 ; catch rate
    db 255 ; base exp
	dw 0 ; field capabilities
    dn GENDERLESS, 15 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/articuno/front.dimensions"
    db PRESSURE, PRESSURE     ; abilities
    db SNOW_CLOAK    ; hidden ability
    db GROWTH_SLOW ; growth rate
    dn EGG_NONE ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
