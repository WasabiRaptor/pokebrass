	dw undefined ;national dex no
	
	db  90,  92,  75,  60,  92,  85
	evs  0,   1,   0,   0,   1,   0
	;   hp  atk  def  spd  sat  sdf
	
	db GRASS, ICE ; type
	db 50 ; catch rate
	db 200 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, NaN ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/abomasnow/front.dimensions"  
	db SNOW WARNING, SNOW WARNING     ; abilities
	db SOUNDPROOF    ; hidden ability
	db Slow ; growth rate
	dn EGG_MONSTER, EGG_GRASS ; egg groups
	
	; tm/hm learnset
	tmhm
	; end
