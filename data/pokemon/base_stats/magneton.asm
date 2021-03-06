
    dw 00082 ;national dex no

    db  50,  60,  95,  70, 120,  70
    evs  0,   0,   0,   0,   2,   0
    ;   hp  atk  def  spd  sat  sdf

    db ELECTRIC, STEEL ; type
    db 60 ; catch rate
    db 163 ; base exp
	dw 0 ; field capabilities
    dn GENDERLESS, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/magneton/front.dimensions"
    db MAGNET_PULL, STURDY     ; abilities
    db ANALYTIC    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_MINERAL ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
