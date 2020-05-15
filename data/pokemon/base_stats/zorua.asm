
    dw 00570 ;national dex no

    db  40,  65,  40,  65,  80,  40
    evs  0,   0,   0,   0,   1,   0
    ;   hp  atk  def  spd  sat  sdf

    db DARK, DARK ; type
    db 75 ; catch rate
    db 66 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_12_5, 5 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/zorua/front.dimensions"
    db ILLUSION, ILLUSION     ; abilities
    db ILLUSION    ; hidden ability
    db GROWTH_MEDIUM_SLOW ; growth rate
    dn EGG_FIELD ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
