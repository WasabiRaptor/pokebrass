
	db  70,  75,  50,  50,  45,  50
    evs  0,   1,   0,   0,   0,   0
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, FIGHTING ; type
	db 140 ; catch rate
	db 68 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, 2 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/stufful/front.dimensions"
	db 0, 0	; abilities
	db 0	; hidden ability
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_FIELD, EGG_FIELD ; egg groups

	; tm/hm learnset
	tmhm
	; end
	