
	dw 00196 ;national dex no

	db  65,  65,  60, 110, 130,  95
	evs  0,   0,   0,   0,   2,   0
	;   hp  atk  def  spd  sat  sdf

	db PSYCHIC, PSYCHIC ; type
	db 50 ; catch rate
	db 200 ; base exp
	dw 0 ; field capabilities
	dn FEMALE_50, 7 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/espeon/front.dimensions"
	db SYNCHRONIZE, SYNCHRONIZE     ; abilities
	db MAGIC_BOUNCE    ; hidden ability
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_FIELD, EGG_FIELD ; egg groups
	db 3 ; number of portrait emotes

	; tm/hm learnset
	tmhm
	; end
