; Boolean checks
FALSE EQU 0
TRUE  EQU 1

; flag manipulation
RESET_FLAG EQU 0
SET_FLAG   EQU 1
CHECK_FLAG EQU 2

SAVE_CHECK_VALUE_1 EQU 99
SAVE_CHECK_VALUE_2 EQU 127

HMENURETURN_SCRIPT EQU %10000000
HMENURETURN_ASM    EQU %11111111

DAWN_HOUR EQU 6
MIDDAY_HOUR EQU 12
DUSK_HOUR EQU 18
MIDNIGHT_HOUR EQU 21

GRASS_SCANLINE_PX EQU 55
GRASS_SCANLINE_COVER EQU 4

NO_RTC_SPEEDUP EQU 6

	const_def
	const CYCLE_NO_EVENT
	const CYCLE_ITS_RIGHT_NEAR_EVENT
	const CYCLE_ITS_GETTING_CLOSER_EVENT
	const CYCLE_SOMETHING_IS_APPROACHING_EVENT
	const CYCLE_SOMETHING_IS_STIRRING_EVENT
	const CYCLE_24_HOURS_REMAIN_EVENT
	const CYCLE_48_HOURS_REMAIN_EVENT
	const CYCLE_72_HOURS_REMAIN_EVENT
	const CYCLE_96_HOURS_REMAIN_EVENT
	const CYCLE_120_HOURS_REMAIN_EVENT
	const CYCLE_144_HOURS_REMAIN_EVENT
	const CYCLE_168_HOURS_REMAIN_EVENT

; mail
MAIL_STRUCT_LENGTH EQU $2f
MAILBOX_CAPACITY   EQU 10
MAIL_MSG_LENGTH    EQU $20

SHINY_NUMERATOR         EQU 16 ; 16/65536 = 1/4096
CHARMED_SHINY_NUMERATOR EQU 48 ; 48/65536 = 3/4096

; movement
	const_def
	const STEP_SLOW
	const STEP_WALK
	const STEP_BIKE
	const STEP_RUN
	const STEP_LEDGE
	const STEP_ICE
	const STEP_TURN
	const STEP_BACK_LEDGE
	const STEP_WALK_IN_PLACE
	const STEP_SPIN
	const STEP_FAST ; same as STEP_RUN but without doubling animation speed
	const STEP_DIAGONAL_STAIRS

const_value = 1
	const HAPPINESS_GAINLEVEL         ; 01
	const HAPPINESS_USEDITEM          ; 02
	const HAPPINESS_USEDXITEM         ; 03
	const HAPPINESS_GYMBATTLE         ; 04
	const HAPPINESS_LEARNMOVE         ; 05
	const HAPPINESS_FAINTED           ; 06
	const HAPPINESS_POISONFAINT       ; 07
	const HAPPINESS_BEATENBYSTRONGFOE ; 08
	const HAPPINESS_YOUNGCUT1         ; 09
	const HAPPINESS_YOUNGCUT2         ; 0a
	const HAPPINESS_YOUNGCUT3         ; 0b
	const HAPPINESS_OLDERCUT1         ; 0c
	const HAPPINESS_OLDERCUT2         ; 0d
	const HAPPINESS_OLDERCUT3         ; 0e
	const HAPPINESS_BITTERPOWDER      ; 0f
	const HAPPINESS_ENERGYROOT        ; 10
	const HAPPINESS_REVIVALHERB       ; 11
	const HAPPINESS_MASSAGE           ; 12
	const HAPPINESS_GAINLEVELATHOME   ; 13
	const HAPPINESS_PHOTOGRAPH        ; 14
	const HAPPINESS_BLESSING          ; 15
