	dw 00718
	db 108, 100, 121,  95,  81,  95
    evs  3,   0,   0,   0,   0,   0
	;   hp  atk  def  spd  sat  sdf

	db DRAGON, GROUND ; type
	db 3 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items

	INCBIN "gfx/pokemon/zygarde_fifty_percent/front.dimensions"
	db REVERSE_AURA, REVERSE_AURA	; abilities
	db POWER_CONSTRUCT	; hidden ability
	db GROWTH_SLOW ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm
	; end
