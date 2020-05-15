
    dw 00169 ;national dex no

    db  85,  90,  80, 130,  70,  80
    evs  0,   0,   0,   3,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db POISON, FLYING ; type
    db 90 ; catch rate
    db 241 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 3 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/crobat/front.dimensions"
    db INNER_FOCUS, INNER_FOCUS     ; abilities
    db INFILTRATOR    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_FLYING ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
