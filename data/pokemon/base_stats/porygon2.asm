
    dw 00233 ;national dex no

    db  85,  80,  90,  60, 105,  95
    evs  0,   0,   0,   0,   2,   0
    ;   hp  atk  def  spd  sat  sdf

    db NORMAL, NORMAL ; type
    db 45 ; catch rate
    db 180 ; base exp
	dw 0 ; field capabilities
    dn GENDERLESS, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/porygon2/front.dimensions"
    db TRACE, DOWNLOAD     ; abilities
    db ANALYTIC    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_MINERAL ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
