
    dw 00774 ;national dex no

    db  60,  60, 100,  60,  60, 100
    evs  0,   0,   1,   0,   0,   1
    ;   hp  atk  def  spd  sat  sdf

    db ROCK, FLYING ; type
    db 30 ; catch rate
    db 154 ; base exp
	dw 0 ; field capabilities
    dn GENDERLESS, 5 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/minior_red_meteor/front.dimensions"
    db SHIELDS_DOWN, SHIELDS_DOWN     ; abilities
    db SHIELDS_DOWN    ; hidden ability
    db GROWTH_MEDIUM_SLOW ; growth rate
    dn EGG_MINERAL ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
