	dw undefined ;national dex no
	
	db  48,  48,  48,  48,  48,  48
	evs  1,   0,   0,   0,   0,   0
	;   hp  atk  def  spd  sat  sdf
	
	db NORMAL, NORMAL ; type
	db 50 ; catch rate
	db 200 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, NaN ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/ditto/front.dimensions"  
	db LIMBER, LIMBER     ; abilities
	db IMPOSTER    ; hidden ability
	db MediumFast ; growth rate
	dn EGG_DITTO, EGG_DITTO ; egg groups
	
	; tm/hm learnset
	tmhm
	; end
