
	dw 01168 ;national dex no

	db  92, 170, 115, 148,  80, 115
	evs  0,   0,   0,   3,   0,   0
	;   hp  atk  def  spd  sat  sdf

	db FAIRY, STEEL ; type
	db 50 ; catch rate
	db 200 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, 24 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/zacian_1/front.dimensions"
	db INTREPID_SWORD, INTREPID_SWORD     ; abilities
	db INTREPID_SWORD    ; hidden ability
	db GROWTH_SLOW ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm
	; end