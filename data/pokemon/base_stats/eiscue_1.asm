
	dw 01165 ;national dex no

	db  75,  80,  70, 130,  65,  50
	evs  0,   0,   2,   0,   0,   0
	;   hp  atk  def  spd  sat  sdf

	db ICE, ICE ; type
	db 50 ; catch rate
	db 200 ; base exp
	dw 0 ; field capabilities
	dn FEMALE_50, 5 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/eiscue_1/front.dimensions"
	db ICE_FACE, ICE_FACE     ; abilities
	db ICE_FACE    ; hidden ability
	db GROWTH_SLOW ; growth rate
	dn EGG_WATER_1, EGG_FIELD ; egg groups
	db 3 ; number of portrait emotes

	; tm/hm learnset
	tmhm
	; end
