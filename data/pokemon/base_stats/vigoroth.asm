
    dw 00288 ;national dex no

    db  80,  80,  80,  90,  55,  55
    evs  0,   0,   0,   2,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db NORMAL, NORMAL ; type
    db 120 ; catch rate
    db 154 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 3 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/vigoroth/front.dimensions"
    db VITAL_SPIRIT, VITAL_SPIRIT     ; abilities
    db VITAL_SPIRIT    ; hidden ability
    db GROWTH_SLOW ; growth rate
    dn EGG_FIELD ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
