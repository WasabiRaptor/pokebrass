
    dw 00457 ;national dex no

    db  69,  69,  76,  91,  69,  86
    evs  0,   0,   0,   2,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db WATER, WATER ; type
    db 75 ; catch rate
    db 161 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/lumineon/front.dimensions"
    db SWIFT_SWIM, STORM_DRAIN     ; abilities
    db WATER_VEIL    ; hidden ability
    db GROWTH_ERRATIC ; growth rate
    dn EGG_WATER_2 ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
