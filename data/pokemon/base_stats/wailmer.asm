
	dw 00320 ;national dex no

	db 130,  70,  35,  60,  70,  35
	evs  1,   0,   0,   0,   0,   0
	;   hp  atk  def  spd  sat  sdf

	db WATER, WATER ; type
	db 50 ; catch rate
	db 200 ; base exp
	dw 0 ; field capabilities
	dn FEMALE_50, 8 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/wailmer/front.dimensions"
	db WATER_VEIL, OBLIVIOUS     ; abilities
	db PRESSURE    ; hidden ability
	db GROWTH_FLUCTUATING ; growth rate
	dn EGG_FIELD, EGG_WATER_2 ; egg groups
	db 3 ; number of portrait emotes

	; tm/hm learnset
	tmhm
	; end
