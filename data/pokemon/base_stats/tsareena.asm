	dw undefined ;national dex no
	
	db  72, 120,  98,  72,  50,  98
	evs  0,   3,   0,   0,   0,   0
	;   hp  atk  def  spd  sat  sdf
	
	db GRASS, GRASS ; type
	db 50 ; catch rate
	db 200 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, NaN ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/tsareena/front.dimensions"  
	db LEAF GUARD, QUEENLY MAJESTY     ; abilities
	db SWEET VEIL    ; hidden ability
	db MediumSlow ; growth rate
	dn EGG_GRASS, EGG_GRASS ; egg groups
	
	; tm/hm learnset
	tmhm
	; end
