
	dw 00058 ;national dex no

	db  55,  70,  45,  60,  70,  50
	evs  0,   1,   0,   0,   0,   0
	;   hp  atk  def  spd  sat  sdf

	db FIRE, FIRE ; type
	db 50 ; catch rate
	db 200 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, 4 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/growlithe/front.dimensions"
	db INTIMIDATE, FLASH_FIRE     ; abilities
	db JUSTIFIED    ; hidden ability
	db GROWTH_SLOW ; growth rate
	dn EGG_FIELD, EGG_FIELD ; egg groups

	; tm/hm learnset
	tmhm
	; end
