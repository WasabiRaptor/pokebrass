
	db  49,  49,  56,  66,  49,  61
    evs  0,   0,   0,   1,   0,   0
	;   hp  atk  def  spd  sat  sdf

	db WATER, WATER ; type
	db 190 ; catch rate
	db 66 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, 3 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/finneon/front.dimensions"
	db 0, 0	; abilities
	db 0	; hidden ability
	db GROWTH_ERRATIC ; growth rate
	dn EGG_WATER_2, EGG_WATER_2 ; egg groups 

	; tm/hm learnset
	tmhm
	; end
	