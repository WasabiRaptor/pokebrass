
	dw 00043 ;national dex no

	db  45,  50,  55,  30,  75,  65
	evs  0,   0,   0,   0,   1,   0
	;   hp  atk  def  spd  sat  sdf

	db GRASS, POISON ; type
	db 50 ; catch rate
	db 200 ; base exp
	dw 0 ; field capabilities
	dn FEMALE_50, 4 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/oddish/front.dimensions"
	db CHLOROPHYLL, CHLOROPHYLL     ; abilities
	db RUN_AWAY    ; hidden ability
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GRASS, EGG_GRASS ; egg groups
	db 3 ; number of portrait emotes

	; tm/hm learnset
	tmhm
	; end
