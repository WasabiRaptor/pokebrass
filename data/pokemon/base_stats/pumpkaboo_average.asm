
    dw 00710 ;national dex no

    db  49,  66,  70,  51,  44,  55
    evs  0,   0,   1,   0,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db GHOST, GRASS ; type
    db 120 ; catch rate
    db 67 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/pumpkaboo_average/front.dimensions"
    db PICKUP, FRISK     ; abilities
    db INSOMNIA    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_AMORPHOUS ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
