
	db  20,  15,  20,  80,  10,  55
    evs  0,   0,   0,   1,   0,   0
	;   hp  atk  def  spd  sat  sdf

	db WATER, WATER ; type
	db 255 ; catch rate
	db 40 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, 3 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/feebas/front.dimensions"
	db 0, 0	; abilities
	db 0	; hidden ability
	db GROWTH_ERRATIC ; growth rate
	dn EGG_DRAGON, EGG_WATER_1 ; egg groups 

	; tm/hm learnset
	tmhm
	; end