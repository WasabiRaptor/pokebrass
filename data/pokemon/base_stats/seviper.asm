
    dw 00336 ;national dex no

    db  73, 100,  60,  65, 100,  60
    evs  0,   1,   0,   0,   1,   0
    ;   hp  atk  def  spd  sat  sdf

    db POISON, POISON ; type
    db 90 ; catch rate
    db 160 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/seviper/front.dimensions"
    db SHED_SKIN, SHED_SKIN     ; abilities
    db INFILTRATOR    ; hidden ability
    db GROWTH_FLUCTUATING ; growth rate
    dn EGG_FIELD, EGG_DRAGON ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
