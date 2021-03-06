
    dw 00229 ;national dex no

    db  75,  90,  50,  95, 110,  80
    evs  0,   0,   0,   0,   2,   0
    ;   hp  atk  def  spd  sat  sdf

    db DARK, FIRE ; type
    db 45 ; catch rate
    db 175 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_50, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/houndoom/front.dimensions"
    db EARLY_BIRD, FLASH_FIRE     ; abilities
    db UNNERVE    ; hidden ability
    db GROWTH_SLOW ; growth rate
    dn EGG_FIELD ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
