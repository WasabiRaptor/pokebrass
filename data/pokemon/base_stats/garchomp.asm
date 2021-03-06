
    dw 00445 ;national dex no

    db 108, 130,  95, 102,  80,  85
    evs  0,   3,   0,   0,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db DRAGON, GROUND ; type
    db 45 ; catch rate
    db 255 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 8 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/garchomp/front.dimensions"
    db SAND_VEIL, SAND_VEIL     ; abilities
    db ROUGH_SKIN    ; hidden ability
    db GROWTH_SLOW ; growth rate
    dn EGG_MONSTER, EGG_DRAGON ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
