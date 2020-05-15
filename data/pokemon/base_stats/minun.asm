
    dw 00312 ;national dex no

    db  60,  40,  50,  95,  75,  85
    evs  0,   0,   0,   1,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db ELECTRIC, ELECTRIC ; type
    db 200 ; catch rate
    db 142 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/minun/front.dimensions"
    db MINUS, MINUS     ; abilities
    db VOLT_ABSORB    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_FAIRY ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
