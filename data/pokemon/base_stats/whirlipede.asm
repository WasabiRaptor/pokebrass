
    dw 00544 ;national dex no

    db  40,  55,  99,  47,  40,  79
    evs  0,   0,   2,   0,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db BUG, POISON ; type
    db 120 ; catch rate
    db 126 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 3 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/whirlipede/front.dimensions"
    db POISON_POINT, SWARM     ; abilities
    db SPEED_BOOST    ; hidden ability
    db GROWTH_MEDIUM_SLOW ; growth rate
    dn EGG_BUG ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
