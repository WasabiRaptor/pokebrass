
    dw 00014 ;national dex no

    db  45,  25,  50,  35,  25,  25
    evs  0,   0,   2,   0,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db BUG, POISON ; type
    db 120 ; catch rate
    db 72 ; base exp
    db NO_ITEM, NO_ITEM ; items
    dn FEMALE_50, 3 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/kakuna/front.dimensions"
    db SHED_SKIN, SHED_SKIN     ; abilities
    db SHED_SKIN    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_BUG ; egg groups

    ; tm/hm learnset
    tmhm
    ; end
