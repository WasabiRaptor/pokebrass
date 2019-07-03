	dw 00381
	db  80,  90,  80, 110, 130, 110
    evs  0,   0,   0,   0,   3,   0
	;   hp  atk  def  spd  sat  sdf

	db DRAGON, PSYCHIC ; type
	db 3 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn ALL_MALE, 15 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/latios/front.dimensions"
	db LEVITATE, LEVITATE	; abilities
	db LEVITATE	; hidden ability
	db GROWTH_SLOW ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm
	; end
