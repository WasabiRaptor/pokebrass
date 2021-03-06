
    dw 00086 ;national dex no

    db  65,  45,  55,  45,  45,  70
    evs  0,   0,   0,   0,   0,   1
    ;   hp  atk  def  spd  sat  sdf

    db WATER, WATER ; type
    db 190 ; catch rate
    db 65 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/seel/front.dimensions"
    db THICK_FAT, HYDRATION     ; abilities
    db ICE_BODY    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_WATER_1, EGG_FIELD ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
