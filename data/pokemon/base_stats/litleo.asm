
    dw 00667 ;national dex no

    db  62,  50,  58,  72,  73,  54
    evs  0,   0,   0,   0,   1,   0
    ;   hp  atk  def  spd  sat  sdf

    db FIRE, NORMAL ; type
    db 220 ; catch rate
    db 74 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_87_5, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/litleo/front.dimensions"
    db RIVALRY, UNNERVE     ; abilities
    db MOXIE    ; hidden ability
    db GROWTH_MEDIUM_SLOW ; growth rate
    dn EGG_FIELD ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
