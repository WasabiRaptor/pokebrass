	dw undefined ;national dex no
	
	db 120,  95,  95,  20,  55,  75
	evs  2,   0,   0,   0,   0,   0
	;   hp  atk  def  spd  sat  sdf
	
	db NORMAL, NORMAL ; type
	db 50 ; catch rate
	db 200 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, NaN ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/greedent/front.dimensions"  
	db CHEEK POUCH, CHEEK POUCH     ; abilities
	db GLUTTONY    ; hidden ability
	db MediumFast ; growth rate
	dn EGG_FIELD, EGG_FIELD ; egg groups
	
	; tm/hm learnset
	tmhm
	; end
