
    dw 00668 ;national dex no

    db  86,  68,  72, 106, 109,  66
    evs  0,   0,   0,   0,   2,   0
    ;   hp  atk  def  spd  sat  sdf

    db FIRE, NORMAL ; type
    db 65 ; catch rate
    db 177 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_87_5, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/pyroar/front.dimensions"
    db RIVALRY, UNNERVE     ; abilities
    db MOXIE    ; hidden ability
    db GROWTH_MEDIUM_SLOW ; growth rate
    dn EGG_FIELD ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
