
    dw 00474 ;national dex no

    db  85,  80,  70,  90, 135,  75
    evs  0,   0,   0,   0,   3,   0
    ;   hp  atk  def  spd  sat  sdf

    db NORMAL, NORMAL ; type
    db 30 ; catch rate
    db 241 ; base exp
	dw 0 ; field capabilities
    dn GENDERLESS, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/porygon_z/front.dimensions"
    db ADAPTABILITY, DOWNLOAD     ; abilities
    db ANALYTIC    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_MINERAL ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
