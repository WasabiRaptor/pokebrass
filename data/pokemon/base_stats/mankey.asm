
    dw 00056 ;national dex no

    db  40,  80,  35,  70,  35,  45
    evs  0,   1,   0,   0,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db FIGHTING, FIGHTING ; type
    db 190 ; catch rate
    db 61 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/mankey/front.dimensions"
    db VITAL_SPIRIT, ANGER_POINT     ; abilities
    db DEFIANT    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_FIELD ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
