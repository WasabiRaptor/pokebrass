	dw undefined ;national dex no
	
	db  45,  49,  49,  45,  65,  65
	evs  0,   0,   0,   0,   1,   0
	;   hp  atk  def  spd  sat  sdf
	
	db GRASS, POISON ; type
	db 50 ; catch rate
	db 200 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, NaN ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/bulbasaur/front.dimensions"  
	db OVERGROW, OVERGROW     ; abilities
	db CHLOROPHYLL    ; hidden ability
	db MediumSlow ; growth rate
	dn EGG_MONSTER, EGG_GRASS ; egg groups
	
	; tm/hm learnset
	tmhm
	; end
