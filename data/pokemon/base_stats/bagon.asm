
    dw 00371 ;national dex no

    db  45,  75,  60,  50,  40,  30
    evs  0,   1,   0,   0,   0,   0
    ;   hp  atk  def  spd  sat  sdf

    db DRAGON, DRAGON ; type
    db 45 ; catch rate
    db 60 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 8 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/bagon/front.dimensions"
    db ROCK_HEAD, ROCK_HEAD     ; abilities
    db SHEER_FORCE    ; hidden ability
    db GROWTH_SLOW ; growth rate
    dn EGG_DRAGON ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
