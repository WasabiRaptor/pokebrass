
	db  78,  84,  78, 100, 109,  85
    evs  0,   0,   0,   0,   3,   0
	;   hp  atk  def  spd  sat  sdf

	db FIRE, FIRE ; type
	db 45 ; catch rate
	db 240 ; base exp
	db NO_ITEM, NO_ITEM ; items
	dn FEMALE_12_5, 3 ; gender, step cycles to hatch
	INCBIN "gfx/pokemon/typhlosion/front.dimensions"
	db 0, 0	; abilities
	db 0	; hidden ability
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_FIELD, EGG_FIELD ; egg groups

	; tmhm
	tmhm DYNAMICPUNCH, CURSE, ROAR, TOXIC, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, BULLDOZE, SOLAR_BEAM, IRON_TAIL, EARTHQUAKE, RETURN, DIG, DOUBLE_TEAM, FLAMETHROWER, FIRE_BLAST, SWIFT, AERIAL_ACE, SUBSTITUTE, FACADE, WILD_CHARGE, REST, ATTRACT, ROCK_SLIDE, ROCK_SMASH, FOCUS_BLAST, ENDURE, WILL_O_WISP, SHADOW_CLAW, GIGA_IMPACT, GYRO_BALL, CUT, STRENGTH, BODY_SLAM, COUNTER, DEFENSE_CURL, DOUBLE_EDGE, EARTH_POWER, FIRE_PUNCH, HEADBUTT, ROLLOUT, SEISMIC_TOSS, SLEEP_TALK, SWAGGER, THUNDERPUNCH
	; end
