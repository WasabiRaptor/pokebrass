	dw undefined ;national dex no
	
	db  82,  80,  86,  72,  85,  75
	evs  0,   0,   2,   0,   0,   0
	;   hp  atk  def  spd  sat  sdf
	
	db FAIRY, FAIRY ; type
	db 50 ; catch rate
	db 200 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, NaN ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/slurpuff/front.dimensions"  
	db SWEET VEIL, SWEET VEIL     ; abilities
	db UNBURDEN    ; hidden ability
	db MediumFast ; growth rate
	dn EGG_FAIRY, EGG_FAIRY ; egg groups
	
	; tm/hm learnset
	tmhm
	; end
