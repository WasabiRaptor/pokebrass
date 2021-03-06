
    dw 00323 ;national dex no

    db  70, 100,  70,  40, 105,  75
    evs  0,   1,   0,   0,   1,   0
    ;   hp  atk  def  spd  sat  sdf

    db FIRE, GROUND ; type
    db 150 ; catch rate
    db 161 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/camerupt/front.dimensions"
    db MAGMA_ARMOR, SOLID_ROCK     ; abilities
    db ANGER_POINT    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_FIELD ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
