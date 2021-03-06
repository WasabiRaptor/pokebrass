; strings
PLAYER_NAME_LENGTH EQU 13
BOX_NAME_LENGTH EQU 9
PKMN_NAME_LENGTH EQU 14
PKMN_TILE_NAME_LENGTH EQU 10
MOVE_NAME_LENGTH EQU 13
ITEM_NAME_LENGTH EQU 14
TRAINER_CLASS_NAME_LENGTH EQU 13

; GetName types
PKMN_NAME     EQU 1
MOVE_NAME     EQU 2
APRICORN_NAME EQU 3
ITEM_NAME     EQU 4
PARTY_OT_NAME EQU 5
ENEMY_OT_NAME EQU 6
TRAINER_NAME  EQU 7
KEY_ITEM_NAME EQU 8

; textbox options
TEXTBOX_FRAME_MASK  EQU %00001111
TEXTBOX_VOICE_MASK  EQU %01110000
TEXTBOX_VOICE_SHIFT EQU 4
NO_VOICE      EQU 0 << TEXTBOX_VOICE_SHIFT
DEFAULT_VOICE EQU 1 << TEXTBOX_VOICE_SHIFT
HIGH_VOICE    EQU 2 << TEXTBOX_VOICE_SHIFT
LOW_VOICE     EQU 3 << TEXTBOX_VOICE_SHIFT

; text
BORDER_WIDTH   EQU 2
TEXTBOX_WIDTH  EQU SCREEN_WIDTH
TEXTBOX_INNERW EQU TEXTBOX_WIDTH - BORDER_WIDTH
TEXTBOX_HEIGHT EQU 5
TEXTBOX_INNERH EQU TEXTBOX_HEIGHT - BORDER_WIDTH
TEXTBOX_X      EQU 0
TEXTBOX_INNERX EQU TEXTBOX_X + 1
TEXTBOX_Y      EQU SCREEN_HEIGHT - TEXTBOX_HEIGHT
TEXTBOX_INNERY EQU TEXTBOX_Y + 1

; portraits
PORTRAIT_WIDTH  EQU 4 + BORDER_WIDTH
PORTRIAT_INNERW EQU PORTRAIT_WIDTH - BORDER_WIDTH
PORTRAIT_HEIGHT EQU PORTRAIT_WIDTH
PORTRAIT_INNERH EQU PORTRAIT_HEIGHT - BORDER_WIDTH
PORTRAIT_X      EQU TEXTBOX_X
PORTRAIT_INNERX EQU PORTRAIT_X + 1
PORTRAIT_Y      EQU TEXTBOX_Y - PORTRAIT_HEIGHT + 1
PORTRAIT_INNERY EQU PORTRAIT_Y + 1

; nameplates
NAMEPLATE_WIDTH  EQU TEXTBOX_WIDTH - PORTRAIT_WIDTH + 1
NAMEPLATE_INNERW EQU NAMEPLATE_WIDTH - BORDER_WIDTH
NAMEPLATE_HEIGHT EQU 3
NAMEPLATE_INNERH EQU NAMEPLATE_HEIGHT - BORDER_WIDTH
NAMEPLATE_X      EQU TEXTBOX_X + PORTRAIT_WIDTH - 1
NAMEPLATE_INNERX EQU NAMEPLATE_X + 1
NAMEPLATE_Y      EQU TEXTBOX_Y - NAMEPLATE_HEIGHT + 1
NAMEPLATE_INNERY EQU NAMEPLATE_Y + 1
NAMEPLATE_FLAG   EQU 0


; PrintNum bit flags

PRINTNUM_MONEY_F        EQU 5
PRINTNUM_LEFTALIGN_F    EQU 6
PRINTNUM_LEADINGZEROS_F EQU 7

PRINTNUM_MONEY          EQU 1 << PRINTNUM_MONEY_F
PRINTNUM_LEFTALIGN      EQU 1 << PRINTNUM_LEFTALIGN_F
PRINTNUM_LEADINGZEROS   EQU 1 << PRINTNUM_LEADINGZEROS_F
