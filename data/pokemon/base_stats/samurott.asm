
    dw 00503 ;national dex no

    db  95, 100,  85,  70, 108,  70
    evs  0,   0,   0,   0,   3,   0
    ;   hp  atk  def  spd  sat  sdf

    db WATER, WATER ; type
    db 45 ; catch rate
    db 238 ; base exp
	dw 0 ; field capabilities
    dn FEMALE_12_5, 4 ; gender, step cycles to hatch
    INCBIN "gfx/pokemon/samurott/front.dimensions"
    db TORRENT, TORRENT     ; abilities
    db SHELL_ARMOR    ; hidden ability
    db GROWTH_MEDIUM_SLOW ; growth rate
    dn EGG_FIELD ; egg groups
    db 3 ; number of portrait emotes

    ; tm/hm learnset
    tmhm
    ; end
