
    dw 00124 ;national dex no

    db  65,  50,  35,  95, 115,  95
    evs  0,   0,   0,   0,   2,   0
    ;   hp  atk  def  spd  sat  sdf

    db ICE, PSYCHIC ; type
    db 45 ; catch rate
    db 159 ; base exp
	dw 0 ; field capabilities
    dn ALL_FEMALE, 5 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/jynx/front.dimensions"
    db OBLIVIOUS, FOREWARN     ; abilities
    db DRY_SKIN    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_HUMAN_LIKE ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
