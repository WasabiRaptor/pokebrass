
    dw 00429 ;national dex no

    db  60,  60,  60, 105, 105, 105
    evs  0,   0,   0,   0,   1,   1
    ;   hp  atk  def  spd  sat  sdf

    db GHOST, GHOST ; type
    db 45 ; catch rate
    db 173 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 5 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/mismagius/front.dimensions"
    db LEVITATE, LEVITATE     ; abilities
    db LEVITATE    ; hidden ability
    db GROWTH_FAST ; growth rate
    dn EGG_AMORPHOUS ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
