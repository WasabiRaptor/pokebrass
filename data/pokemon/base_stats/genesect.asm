
    dw 00649 ;national dex no

    db  71, 120,  95,  99, 120,  95
    evs  0,   1,   0,   1,   1,   0
    ;   hp  atk  def  spd  sat  sdf

    db BUG, STEEL ; type
    db 3 ; catch rate
    db 255 ; base exp
	dw 0 ; field capabilities
    dn GENDERLESS, 15 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/genesect/front.dimensions"
    db DOWNLOAD, DOWNLOAD     ; abilities
    db DOWNLOAD    ; hidden ability
    db GROWTH_SLOW ; growth rate
    dn EGG_NONE ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
