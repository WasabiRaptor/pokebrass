
    dw 00267 ;national dex no

    db  60,  70,  50,  65, 100,  50
    evs  0,   0,   0,   0,   3,   0
    ;   hp  atk  def  spd  sat  sdf

    db BUG, FLYING ; type
    db 45 ; catch rate
    db 178 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 3 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/beautifly/front.dimensions"
    db SWARM, SWARM     ; abilities
    db RIVALRY    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_BUG ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
