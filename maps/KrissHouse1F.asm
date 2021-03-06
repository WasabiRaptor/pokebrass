KrissHouse1F_MapScriptHeader:
	db 0 ; scene scripts

	db 0 ; callbacks

	db 3 ; warp events
	warp_event  8,  7, DANIELS_TOWN, 1
	warp_event  9,  7, DANIELS_TOWN, 1
	warp_event 11,  0, KRISS_HOUSE_2F, 1

	db 4 ; coord events
	coord_event 10,  4, 0, MomTrigger1
	coord_event 11,  4, 0, MomTrigger2
	coord_event  9,  1, 0, MomTrigger3
	coord_event  9,  2, 0, MomTrigger4

	db 4 ; bg events
	bg_event  1,  1, SIGNPOST_JUMPTEXT, FridgeText
	bg_event  2,  1, SIGNPOST_JUMPTEXT, SinkText
	bg_event  3,  1, SIGNPOST_JUMPTEXT, StoveText
	bg_event  6,  1, SIGNPOST_UP, TVScript

	db 3 ; object events
	object_event  9,  4, SPRITE_MOM, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, START_OF_CYCLE_EXIST, END_OF_CYCLE_EXIST, OW_NPC1, PAL_NPC_PURPLE, PERSONTYPE_SCRIPT, 0, MomScript, EVENT_KRISS_HOUSE_MOM_1
	object_event  3,  2, SPRITE_MOM, SPRITEMOVEDATA_STANDING_UP, 0, 0, START_OF_CYCLE_EXIST, END_OF_CYCLE_EXIST, OW_NPC1, PAL_NPC_PURPLE, PERSONTYPE_SCRIPT, 0, MomScript, EVENT_KRISS_HOUSE_MOM_2
	;object_event  9,  4, SPRITE_MOM, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, (1 << MIDDAY), 0, PERSONTYPE_SCRIPT, OW_NPC1, PAL_NPC_PURPLE, MomScript, EVENT_KRISS_HOUSE_MOM_2
	;object_event  1,  2, SPRITE_MOM, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, (1 << MIDNIGHT), 0, PERSONTYPE_SCRIPT, OW_NPC1, PAL_NPC_PURPLE, MomScript, EVENT_KRISS_HOUSE_MOM_2
	pokemon_event  6,  4, VULPIX, LOKI, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, START_OF_CYCLE_EXIST, END_OF_CYCLE_EXIST, OW_NPC2, 0, LokiScript, -1

	const_def 2 ; object constants
	const KRISSHOUSE1F_MOM1

MomTrigger1:
	playmusic MUSIC_MOM
	showemote EMOTE_SHOCK, KRISSHOUSE1F_MOM1, 15
	turnobject KRISSHOUSE1F_MOM1, RIGHT
	turnobject PLAYER, LEFT
	jump MomEventScript

MomTrigger2:
	playmusic MUSIC_MOM
	showemote EMOTE_SHOCK, KRISSHOUSE1F_MOM1, 15
	turnobject KRISSHOUSE1F_MOM1, RIGHT
	applyonemovement PLAYER, slow_step_left
	jump MomEventScript

MomTrigger3:
	playmusic MUSIC_MOM
	showemote EMOTE_SHOCK, KRISSHOUSE1F_MOM1, 15
	turnobject KRISSHOUSE1F_MOM1, UP
	applymovement PLAYER, .two_steps_down
	jump MomEventScript

.two_steps_down
	step_down
	step_down
	step_end

MomTrigger4:
	playmusic MUSIC_MOM
	showemote EMOTE_SHOCK, KRISSHOUSE1F_MOM1, 15
	turnobject KRISSHOUSE1F_MOM1, UP
	applyonemovement PLAYER, slow_step_down
MomEventScript:
	opentext
	;givepoke EEVEE, 5
	stringtotext GearName, $1
	callstd receiveitem
	setflag ENGINE_POKEGEAR
	setflag ENGINE_PHONE_CARD
	addcellnum PHONE_MOM
	setscene $1
	setevent EVENT_KRISS_HOUSE_MOM_1
	clearevent EVENT_KRISS_HOUSE_MOM_2
	closetext
	turnobject KRISSHOUSE1F_MOM1, LEFT
	special RestartMapMusic
	end

GearName:
	db "Pokegear@"

FridgeText:
	text "Let's see what's"
	line "in the fridge…"

	para "Fresh Water and"
	line "tasty Lemonade!"
	done

SinkText:
	text "The sink is spot-"
	line "less. Mom likes it"
	cont "clean."
	done

StoveText:
	text "Mom's specialty!"

	para "Cinnabar Volcano"
	line "Burger!"
	done

TVScript:
	thistext

	text "There's a movie on"
	line "TV: Stars dot the"

	para "sky as two boys"
	line "ride on a train…"

	para "I'd better get"
	line "rolling too!"
	done

MomScript:
	opentext
	playmusic MUSIC_NONE
	special RestartMapMusic
	givekeyitem BICYCLE
	;givepoke ZYGARDE_10, 5, SWEET_HONEY, TEN_PERCENT_ZYGARDE, CHERISH_BALL, HIDDEN_ABILITY
	closetext
	end

	faceplayer
	checkscene
	iffalse .MomEvent
	opentext
	checkevent EVENT_FIRST_TIME_BANKING_WITH_MOM
	iftrue_jumpopenedtext MomDoItText
	checkevent EVENT_TALKED_TO_MOM_AFTER_MYSTERY_EGG_QUEST
	iftrue .BankOfMom
	checkevent EVENT_GAVE_MYSTERY_EGG_TO_ELM
	iftrue .FirstTimeBanking
	checkevent EVENT_GOT_A_POKEMON_FROM_ELM
	iftrue_jumpopenedtext MomErrandText
	thisopenedtext

	text "Prof.Elm is wait-"
	line "ing for you."

	para "Hurry up, baby!"
	done

.FirstTimeBanking:
	setevent EVENT_FIRST_TIME_BANKING_WITH_MOM
.BankOfMom:
	setevent EVENT_TALKED_TO_MOM_AFTER_MYSTERY_EGG_QUEST
	special Special_BankOfMom
	waitendtext

.MomEvent:
	playmusic MUSIC_MOM
	jump MomEventScript

MomIntroText:
if DEF(DEBUG)
	text "Don't forget to use"
	line "your debug radio!"
	done
else
	text "Oh, <PLAYER>!"
	line "You're awake."

	para "Your friend Lyra"
	line "was just here."

	para "She said that our"
	line "neighbor, Prof."

	para "Elm, was looking"
	line "for you."

	para "Oh! I almost for-"
	line "got! Your Pokémon"

	para "Gear is back from"
	line "the repair shop."

	para "Here you go!"
	done
endc

MomPokegearText:
	text "Pokémon Gear, or"
	line "just #gear."

	para "It's essential if"
	line "you want to be a"
	cont "good trainer."

	para "Oh, the day of the"
	line "week isn't set."

	para "You mustn't forget"
	line "that!"
	done

MomDSTText:
	text "Is it Daylight"
	line "Saving Time now?"
	done

MomRunningShoesText:
	text "Come home to"
	line "adjust your clock"

	para "for Daylight"
	line "Saving Time."

	para "By the way, do"
	line "you know how to"

	para "use your new"
	line "Running Shoes?"
	done

MomInstructionsText:
	text "I'll read the"
	line "instructions."

	para "Just hold down the"
	line "B Button to run,"
	cont "indoors or out."

	para "Or use the Option"
	line "to always run, and"
	cont "hold B to walk."
	done

MomOutroText:
	text "Gee, aren't they"
	line "convenient?"
	done

MomErrandText:
	text "So, what was Prof."
	line "Elm's errand?"

	para "…"

	para "That does sound"
	line "challenging."

	para "But, you should be"
	line "proud that people"
	cont "rely on you."
	done

MomDoItText:
	text "<PLAYER>, do it!"

	para "I'm behind you all"
	line "the way!"
	done

LokiScript:
	faceplayer
	opentext
	portrait VULPIX, LOKI, 0
	checktime 1 << DAWN
	iftrue .MornScript
	checktime 1 << MIDDAY
	iftrue .DayScript
	checktime 1 << MIDNIGHT
	iftrue .NiteScript

.MornScript:
	writenamedtext .LokiNameText, .MornIntroText
	buttonsound
	jump .Main

.DayScript:
	writenamedtext .LokiNameText, .DayIntroText
	buttonsound
	jump .Main

.NiteScript:
	writenamedtext .LokiNameText, .NiteIntroText
	buttonsound
	jump .Main

.Main:
	;portrait LOKI_UWU
	writenamedtext .LokiNameText, .LokiText
	waitbutton
	closeportrait
	closetext
	turnobject LAST_TALKED, RIGHT
	end

.MornIntroText:
	text "This just feels really really"
	line "unnatural, but its very real."
	done

.DayIntroText:
	text "Somethimg Something VW Text"
	line ""
	done

.NiteIntroText:
	text "Oh hey, looks like I'm the test"
	line "NPC now"
	done

.LokiText:

	text ". "
	textdelay 10
	db ". "
	textdelay 10
	db ". "
	textdelay 10
	db ". "
	textdelay 20
	db ".  "
	textdelay 20
	db ".  "
	textdelay 20
	db ".  "
	textdelay 30
	db ".   "
	textdelay 30
	db ".   "
	textdelay 30
	db ".   "
	textdelay 40
	db ".    "
	textdelay 40
	db ".    "
	textdelay 40
	db ".    "
	textdelay 50
	db "meme"
	done

.LokiNameText:
	db "Loki@"
