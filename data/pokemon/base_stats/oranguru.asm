	dw undefined ;national dex no
	
	db  90,  60,  80,  60,  90, 110
	evs  0,   0,   0,   0,   0,   2
	;   hp  atk  def  spd  sat  sdf
	
	db NORMAL, PSYCHIC ; type
	db 50 ; catch rate
	db 200 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, NaN ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/oranguru/front.dimensions"  
	db INNER FOCUS, TELEPATHY     ; abilities
	db SYMBIOSIS    ; hidden ability
	db Slow ; growth rate
	dn EGG_FIELD, EGG_FIELD ; egg groups
	
	; tm/hm learnset
	tmhm
	; end
