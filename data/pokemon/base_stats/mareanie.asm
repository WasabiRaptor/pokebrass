	dw undefined ;national dex no
	
	db  50,  53,  62,  45,  43,  52
	evs  0,   0,   1,   0,   0,   0
	;   hp  atk  def  spd  sat  sdf
	
	db POISON, WATER ; type
	db 50 ; catch rate
	db 200 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, NaN ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/mareanie/front.dimensions"  
	db MERCILESS, LIMBER     ; abilities
	db REGENERATOR    ; hidden ability
	db MediumFast ; growth rate
	dn EGG_WATER_1, EGG_WATER_1 ; egg groups
	
	; tm/hm learnset
	tmhm
	; end
