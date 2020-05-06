
    dw 00439 ;national dex no

    db  20,  25,  45,  60,  70,  90
    evs  0,   0,   0,   0,   0,   1
    ;   hp  atk  def  spd  sat  sdf

    db PSYCHIC, FAIRY ; type
    db 145 ; catch rate
    db 62 ; base exp
    db NO_ITEM, NO_ITEM ; items
    dn FEMALE_50, 5 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/mime_jr/front.dimensions"
    db SOUNDPROOF, FILTER     ; abilities
    db TECHNICIAN    ; hidden ability
    db GROWTH_MEDIUM_FAST ; growth rate
    dn EGG_NONE ; egg groups

    ; tm/hm learnset
    tmhm
    ; end