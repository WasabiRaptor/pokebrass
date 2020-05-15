
    dw 00244 ;national dex no

    db 115, 115,  85, 100,  90,  75
    evs  1,   2,   0,   0,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db FIRE, FIRE ; type
    db 3 ; catch rate
    db 255 ; base exp
	dw 0 ; field capabilities
    dn GENDERLESS, 15 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/entei/front.dimensions"
    db PRESSURE, PRESSURE     ; abilities
    db INNER_FOCUS    ; hidden ability
    db GROWTH_SLOW ; growth rate
    dn EGG_NONE ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
