
    dw 00804 ;national dex no

    db  73,  73,  73, 121, 127,  73
    evs  0,   0,   0,   0,   3,   0
    ;   hp  atk  def  spd  sat  sdf

    db POISON, DRAGON ; type
    db 45 ; catch rate
    db 243 ; base exp
	dw 0 ; field capabilities
    dn GENDERLESS, 15 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/naganadel/front.dimensions"
    db BEAST_BOOST, BEAST_BOOST     ; abilities
    db BEAST_BOOST    ; hidden ability
    db GROWTH_SLOW ; growth rate
    dn EGG_NONE ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
