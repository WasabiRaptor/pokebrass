
	dw 00821 ;national dex no

	db  38,  47,  35,  57,  33,  35
	evs  0,   0,   0,   1,   0,   0
	;   hp  atk  def  spd  sat  sdf

	db FLYING, FLYING ; type
	db 50 ; catch rate
	db 200 ; base exp
	dw 0 ; field capabilities
	dn FEMALE_50, 3 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/rookidee/front.dimensions"
	db KEEN_EYE, UNNERVE     ; abilities
	db BIG_PECKS    ; hidden ability
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_FLYING, EGG_FLYING ; egg groups
	db 3 ; number of portrait emotes

	; tm/hm learnset
	tmhm
	; end
