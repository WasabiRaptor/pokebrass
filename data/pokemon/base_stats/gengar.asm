
	db  60,  65,  60, 110, 130,  75
    evs  0,   0,   0,   0,   3,   0
	;   hp  atk  def  spd  sat  sdf

	db GHOST, POISON ; type
	db 45 ; catch rate
	db 225 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_50, 3 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/gengar/front.dimensions"
	db 0, 0	; abilities
	db 0	; hidden ability
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_AMORPHOUS, EGG_AMORPHOUS ; egg groups

	; tmhm
	tmhm DYNAMICPUNCH, CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, RAIN_DANCE, GIGA_DRAIN, THUNDERBOLT, THUNDER, RETURN, PSYCHIC, SHADOW_BALL, DOUBLE_TEAM, SLUDGE_BOMB, SUBSTITUTE, FACADE, REST, ATTRACT, THIEF, DAZZLINGLEAM, ROCK_SMASH, LEECH_LIFE, FOCUS_BLAST, ENERGY_BALL, DARK_PULSE, ENDURE, DRAIN_PUNCH, WILL_O_WISP, EXPLOSION, SHADOW_CLAW, POISON_JAB, GIGA_IMPACT, STRENGTH, BODY_SLAM, COUNTER, DOUBLE_EDGE, DREAM_EATER, FIRE_PUNCH, HEADBUTT, ICE_PUNCH, ICY_WIND, KNOCK_OFF, SEISMIC_TOSS, SKILL_SWAP, SLEEP_TALK, SUCKER_PUNCH, SWAGGER, THUNDERPUNCH, TRICK, ZAP_CANNON
	; end