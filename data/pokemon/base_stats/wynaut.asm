	dw undefined ;national dex no
	
	db  95,  23,  48,  23,  23,  48
	evs  1,   0,   0,   0,   0,   0
	;   hp  atk  def  spd  sat  sdf
	
	db PSYCHIC, PSYCHIC ; type
	db 50 ; catch rate
	db 200 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, NaN ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/wynaut/front.dimensions"  
	db SHADOW TAG, SHADOW TAG     ; abilities
	db TELEPATHY    ; hidden ability
	db MediumFast ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups
	
	; tm/hm learnset
	tmhm
	; end
