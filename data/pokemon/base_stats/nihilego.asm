
    dw 00793 ;national dex no

    db 109,  53,  47, 103, 127, 131
    evs  0,   0,   0,   0,   0,   3
    ;   hp  atk  def  spd  sat  sdf

    db ROCK, POISON ; type
    db 45 ; catch rate
    db 255 ; base exp
	dw 0 ; field capabilities
    dn GENDERLESS, 15 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/nihilego/front.dimensions"
    db BEAST_BOOST, BEAST_BOOST     ; abilities
    db BEAST_BOOST    ; hidden ability
    db GROWTH_SLOW ; growth rate
    dn EGG_NONE ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
