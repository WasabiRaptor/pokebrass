
    dw 00240 ;national dex no

    db  45,  75,  37,  83,  70,  55
    evs  0,   0,   0,   1,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db FIRE, FIRE ; type
    db 45 ; catch rate
    db 73 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_25, 5 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/magby/front.dimensions"
    db FLAME_BODY, FLAME_BODY     ; abilities
    db VITAL_SPIRIT    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_NONE ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
