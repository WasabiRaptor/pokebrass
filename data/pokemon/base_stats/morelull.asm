	dw undefined ;national dex no
	
	db  40,  35,  55,  15,  65,  75
	evs  0,   0,   0,   0,   0,   1
	;   hp  atk  def  spd  sat  sdf
	
	db GRASS, FAIRY ; type
	db 50 ; catch rate
	db 200 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, NaN ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/morelull/front.dimensions"  
	db ILLUMINATE, EFFECT SPORE     ; abilities
	db RAIN DISH    ; hidden ability
	db MediumFast ; growth rate
	dn EGG_GRASS, EGG_GRASS ; egg groups
	
	; tm/hm learnset
	tmhm
	; end
