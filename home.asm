INCLUDE "constants.asm"


SECTION "NULL", ROM0

NULL::

INCLUDE "home/rst.asm"
INCLUDE "home/interrupts.asm"

SECTION "High Home", ROM0
INCLUDE "home/highhome.asm"

SECTION "Header", ROM0

Start::
	nop
	jp _Start


SECTION "Home", ROM0

INCLUDE "home/init.asm"
INCLUDE "home/vblank.asm"
INCLUDE "home/rtc.asm"
INCLUDE "home/fade.asm"
INCLUDE "home/lcd.asm"
INCLUDE "home/time.asm"
INCLUDE "home/serial.asm"
INCLUDE "home/joypad.asm"
INCLUDE "home/decompress.asm"
INCLUDE "home/palettes.asm"
INCLUDE "home/copy.asm"
INCLUDE "home/text.asm"
INCLUDE "home/video.asm"
INCLUDE "home/map_objects.asm"
INCLUDE "home/sine.asm"
INCLUDE "home/movement.asm"
INCLUDE "home/tilemap.asm"
INCLUDE "home/menu.asm"
INCLUDE "home/handshake.asm"
INCLUDE "home/game_time.asm"
INCLUDE "home/map.asm"
INCLUDE "home/farcall.asm"
INCLUDE "home/predef.asm"
INCLUDE "home/window.asm"
INCLUDE "home/flag.asm"
INCLUDE "home/restore_music.asm"

IsAPokemon::
	farjp _IsAPokemon

DisableSpriteUpdates:: ; 0x2ed3
; disables overworld sprite updating?
	xor a
	ldh [hMapAnims], a
	ld [wSpriteUpdatesEnabled], a
	ld a, [wVramState]
	res 0, a
	ld [wVramState], a
	ret
; 0x2ee4

EnableSpriteUpdates:: ; 2ee4
	ld a, $1
	ld [wSpriteUpdatesEnabled], a
	ldh [hMapAnims], a
	ld a, [wVramState]
	set 0, a
	ld [wVramState], a
	ret
; 2ef6

INCLUDE "home/string.asm"
INCLUDE "home/item.asm"
INCLUDE "home/random.asm"
INCLUDE "home/sram.asm"

INCLUDE "home/double_speed.asm"

ClearSprites:: ; 300b
; Erase OAM data
	ld hl, wSprites
	ld b, wSpritesEnd - wSprites
	xor a
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret
; 3016

HideSprites:: ; 3016
; Set all OAM y-positions to 160 to hide them offscreen
	ld hl, wSprites
	ld de, 4 ; length of an OAM struct
	ld b, (wSpritesEnd - wSprites) / 4 ; number of OAM structs
	ld a, 160 ; y
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	ret
; 3026

_Jumptable:
	push de
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	jp hl

LoadTileMapToTempTileMap:: ; 309d
; Load wTileMap into wTempTileMap
	ldh a, [rSVBK]
	push af
	ld a, BANK(wTempTileMap)
	ldh [rSVBK], a
	hlcoord 0, 0
	decoord 0, 0, wTempTileMap
	ld bc, wTileMapEnd - wTileMap
	rst CopyBytes
	pop af
	ldh [rSVBK], a
	ret
; 30b4

Call_LoadTempTileMapToTileMap:: ; 30b4
	xor a
	ldh [hBGMapMode], a
	call LoadTempTileMapToTileMap
	ld a, 1
	ldh [hBGMapMode], a
	ret
; 30bf

LoadTempTileMapToTileMap:: ; 30bf
; Load wTempTileMap into wTileMap
	ldh a, [rSVBK]
	push af
	ld a, BANK(wTempTileMap)
	ldh [rSVBK], a
	hlcoord 0, 0, wTempTileMap
	decoord 0, 0
	ld bc, wTileMapEnd - wTileMap
	rst CopyBytes
	pop af
	ldh [rSVBK], a
	ret
; 30d6

CopyName1:: ; 30d6
; Copies the name from de to wStringBuffer2
	ld hl, wStringBuffer2

CopyName2:: ; 30d9
; Copies the name from de to hl
.loop
	ld a, [de]
	inc de
	ld [hli], a
	cp "@"
	jr nz, .loop
	ret
; 30e1

SkipPokemonNames:: ; 0x30f4
; Skip a names.
	ld bc, PKMN_NAME_LENGTH
	and a
	ret z
.loop
	add hl, bc
	dec a
	jr nz, .loop
	ret

SkipPlayerNames:: ; 0x30f4
; Skip a names.
	ld bc, PLAYER_NAME_LENGTH
	and a
	ret z
.loop
	add hl, bc
	dec a
	jr nz, .loop
	ret

; 0x30fe

INCLUDE "home/math.asm"

CopyDataUntil:: ; 318c
; Copy [hl .. bc) to de.

; In other words, the source data is
; from hl up to but not including bc,
; and the destination is de.

	ld a, [hli]
	ld [de], a
	inc de
	ld a, h
	cp b
	jr nz, CopyDataUntil
	ld a, l
	cp c
	jr nz, CopyDataUntil
	ret
; 0x3198

PrintNum:: ; 3198
	homecall _PrintNum
	ret
; 31a4

FarPrintText:: ; 31b0
	ldh [hBuffer], a
	homecall PrintText, [hBuffer]
	ret
; 31be

QueueScript:: ; 31cd
; Push pointer hl in the current bank to wQueuedScriptBank.
	ldh a, [hROMBank]

FarQueueScript:: ; 31cf
; Push pointer a:hl to wQueuedScriptBank.
	ld [wQueuedScriptBank], a
	ld a, l
	ld [wQueuedScriptAddr], a
	ld a, h
	ld [wQueuedScriptAddr + 1], a
	ret
; 31db

StringCmp:: ; 31db
; Compare c bytes at de and hl.
; Return z if they all match, c if hl>de.
.loop
	ld a, [de]
	cp [hl]
	ret nz
	inc de
	inc hl
	dec c
	jr nz, .loop
	ret
; 0x31e4

CompareLong:: ; 31e4
; Compare bc bytes at de and hl.
; Return carry if they all match.

	ld a, [de]
	cp [hl]
	jr nz, .Diff

	inc de
	inc hl
	dec bc

	ld a, b
	or c
	jr nz, CompareLong

	scf
	ret

.Diff:
	and a
	ret
; 31f3

SetPalettes:: ; 32f9
; Inits the Palettes
; depending on the system the monochromes palettes or color palettes
	push de
	ld a, %11100100
	call DmgToCgbBGPals
	lb de, %11100100, %11100100
	call DmgToCgbObjPals
	pop de
	ret
; 3317

ClearPalettes:: ; 3317
; Make all palettes white
	ldh a, [rSVBK]
	push af

	ld a, BANK(wBGPals)
	ldh [rSVBK], a

; Fill wBGPals and wOBPals with $ffff (white)
	ld hl, wBGPals
if !DEF(MONOCHROME)
	ld bc, 16 palettes
	ld a, $ff
	call ByteFill
else
	ld b, (16 palettes) / 2
.mono_loop
	ld a, PAL_MONOCHROME_WHITE % $100
	ld [hli], a
	ld a, PAL_MONOCHROME_WHITE / $100
	ld [hli], a
	dec b
	jr nz, .mono_loop
endc

	pop af
	ldh [rSVBK], a

; Request palette update
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret
; 333e

GetMemCGBLayout:: ; 333e
	ld b, CGB_RAM
GetCGBLayout:: ; 3340
	predef_jump Predef_LoadCGBLayout
; 334e

SetHPPal:: ; 334e
; Set palette for hp bar pixel length e at hl.
	call GetHPPal
	ld [hl], d
	ret
; 3353

GetHPPal:: ; 3353
; Get palette for hp bar pixel length e in d.
	ld d, HP_GREEN
	ld a, e
	cp 25
	ret nc
	inc d ; HP_YELLOW
	cp 10
	ret nc
	inc d ; HP_RED
	ret
; 335f

CountSetBits:: ; 0x335f
; Count the number of set bits in b bytes starting from hl.
; Return in a, c and [wd265].

	ld c, 0
.next
	ld a, [hli]
	ld e, a
	ld d, 8

.count
	srl e
	ld a, 0 ; not xor a; preserve carry flag?
	adc c
	ld c, a
	dec d
	jr nz, .count

	dec b
	jr nz, .next

	ld a, c
	ld [wd265], a
	ret
; 0x3376

GetWeekday:: ; 3376
	ld a, [wCurDay]
.mod
	sub 7
	jr nc, .mod
	add 7
	ret
; 3380

INCLUDE "home/pokedex_flags.asm"

NamesPointers:: ; 33ab
	dba KantoNames
	dba MoveNames
	dba ApricornNames
	dba ItemNames
	dbw 0, wPartyMonOT
	dbw 0, wOTPartyMonOT
	dba TrainerClassNames
	dba KeyItemNames
; 33c0

GetName:: ; 33c3
; Return name wCurSpecies from name list wNamedObjectTypeBuffer in wStringBuffer1.

	ldh a, [hROMBank]
	push af
	push hl
	push bc
	push de

	ld a, [wNamedObjectTypeBuffer]
	cp PKMN_NAME
	jr nz, .NotPokeName

	ld a, [wCurSpecies]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, PKMN_NAME_LENGTH
	add hl, de
	ld e, l
	ld d, h
	jr .done

.NotPokeName:
	ld a, [wNamedObjectTypeBuffer]
	dec a
	ld e, a
	ld d, 0
	ld hl, NamesPointers
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	rst Bankswitch
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [wCurSpecies]
	dec a
	call GetNthString

	ld de, wStringBuffer1
	ld bc, ITEM_NAME_LENGTH
	rst CopyBytes

.done
	pop de
	pop bc
	pop hl
	pop af
	rst Bankswitch
	ret
; 3411

GetNthString:: ; 3411
; Return the address of the
; ath string starting from hl.

	and a
	ret z

	push bc
	ld b, a
.readChar
	ld a, [hli]
	cp "@"
	jr nz, .readChar
	dec b
	jr nz, .readChar
	pop bc
	ret
; 3420

GetPokemonName:: ; 343b
; Get Pokemon name wNamedObjectIndexBuffer.

	ldh a, [hROMBank]
	push af
	push hl

; given species in a, return *NamePointers in hl and BANK(*NamePointers) in d
; returns c for variants, nc for normal species
	ld a, [wCurGroup]

	ld hl, VariantNamePointerTable
	ld de, 4
	call IsInArray
	inc hl
	ld a, [hli]
	rst Bankswitch
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [wNamedObjectIndexBuffer]
	dec a
	call GetNthString
	
; Terminator
	ld de, wStringBuffer1
	push de
	ld bc, PKMN_NAME_LENGTH - 1
	rst CopyBytes
	ld hl, wStringBuffer1 + PKMN_NAME_LENGTH - 1
	ld [hl], "@"
	pop de

	pop hl
	pop af
	rst Bankswitch
	ret
; 3468

INCLUDE "data/pokemon/variant_name_table.asm"

GetCurItemName::
; Get item name from item in CurItem
	ld a, [wCurItem]
	ld [wNamedObjectIndexBuffer], a
GetItemName:: ; 3468
; Get item name wNamedObjectIndexBuffer.

	push hl
	push bc
	ld a, [wNamedObjectIndexBuffer]
	ld [wCurSpecies], a
	ld a, ITEM_NAME
	jr PutNameInBufferAndGetName

GetCurKeyItemName::
; Get item name from item in CurItem
	ld a, [wCurKeyItem]
	ld [wNamedObjectIndexBuffer], a
GetKeyItemName:: ; 3468
; Get key item item name wNamedObjectIndexBuffer.
	push hl
	push bc
	ld a, [wNamedObjectIndexBuffer]
	ld [wCurSpecies], a
	ld a, KEY_ITEM_NAME
	jr PutNameInBufferAndGetName

GetApricornName::
; Get apricorn name wNamedObjectIndexBuffer.
	push hl
	push bc
	ld a, [wNamedObjectIndexBuffer]
	ld [wCurSpecies], a
	ld a, APRICORN_NAME
PutNameInBufferAndGetName::
	ld [wNamedObjectTypeBuffer], a
	call GetName
	ld de, wStringBuffer1
	pop bc
	pop hl
	ret

GetTMHMName:: ; 3487
; Get TM/HM name by item id wNamedObjectIndexBuffer.

	push hl
	push de
	push bc
	ld a, [wNamedObjectIndexBuffer]
	push af

; TM/HM prefix
	cp HM01
	push af
	jr c, .TM

	ld hl, .HMText
	ld bc, .HMTextEnd - .HMText
	jr .asm_34a1

.TM:
	ld hl, .TMText
	ld bc, .TMTextEnd - .TMText

.asm_34a1
	ld de, wStringBuffer1
	rst CopyBytes

; TM/HM number
	ld a, [wNamedObjectIndexBuffer]
	ld c, a

; HM numbers start from 51, not 1
	pop af
	ld a, c
	jr c, .asm_34b9
	sub NUM_TMS
.asm_34b9
	inc a

; Divide and mod by 10 to get the top and bottom digits respectively
	ld b, "0"
.mod10
	sub 10
	jr c, .asm_34c2
	inc b
	jr .mod10
.asm_34c2
	add 10

	push af
	ld a, b
	ld [de], a
	inc de
	pop af

	ld b, "0"
	add b
	ld [de], a

; End the string
	inc de
	ld a, "@"
	ld [de], a

	pop af
	ld [wNamedObjectIndexBuffer], a
	pop bc
	pop de
	pop hl
	ld de, wStringBuffer1
	ret

.TMText:
	db "TM"
.TMTextEnd:
	db "@"

.HMText:
	db "HM"
.HMTextEnd:
	db "@"
; 34df

IsHM:: ; 34df
	cp HM01
	jr c, .NotHM
	scf
	ret
.NotHM:
	and a
	ret
; 34e7

IsHMMove:: ; 34e7
	ld hl, .HMMoves
	ld de, 1
	jp IsInArray

.HMMoves:
	db CUT
	db FLY
	db SURF
	db STRENGTH
	db WATERFALL
	db WHIRLPOOL
	db -1
; 34f8

GetMoveName:: ; 34f8
	push hl

	ld a, MOVE_NAME
	ld [wNamedObjectTypeBuffer], a

	ld a, [wNamedObjectIndexBuffer] ; move id
	ld [wCurSpecies], a

	call GetName
	ld de, wStringBuffer1

	pop hl
	ret
; 350c

ScrollingMenu:: ; 350c
	call CopyMenuData2
	ldh a, [hROMBank]
	push af

	ld a, BANK(_ScrollingMenu)
	rst Bankswitch

	call _InitScrollingMenu
	call .UpdatePalettes
	call _ScrollingMenu

	pop af
	rst Bankswitch

	ld a, [wMenuJoypad]
	ret
; 3524

.UpdatePalettes: ; 3524
	ld hl, wVramState
	bit 0, [hl]
	jp nz, UpdateTimePals
	jp SetPalettes
; 352f

; 354b

JoyTextDelay_ForcehJoyDown:: ; 354b joypad
	call DelayFrame

	ldh a, [hInMenu]
	push af
	ld a, $1
	ldh [hInMenu], a
	call JoyTextDelay
	pop af
	ldh [hInMenu], a

	ldh a, [hJoyLast]
	and D_RIGHT + D_LEFT + D_UP + D_DOWN
	ld c, a
	ldh a, [hJoyPressed]
	and A_BUTTON + B_BUTTON + SELECT + START
	or c
	ld c, a
	ret
; 3567

HandleStoneQueue:: ; 3567
	ldh a, [hROMBank]
	push af

	call SwitchToMapScriptHeaderBank
	call .WarpAction

	pop bc
	ld a, b
	rst Bankswitch
	ret
; 3574

.WarpAction: ; 3574
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, de
	ld a, [hl]
	cp $ff
	jr z, .nope

	ld l, a
	push hl
	call .IsPersonOnWarp
	pop hl
	jr nc, .nope
	ld d, a
	ld e, l
	call .IsObjectInStoneTable
	jr nc, .nope
	call CallMapScript
	farcall EnableScriptMode
	scf
	ret

.nope
	and a
	ret
; 3599

.IsPersonOnWarp: ; 3599
	push de

	ld hl, OBJECT_NEXT_MAP_X
	add hl, de
	ld a, [hl]
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, de
	ld e, [hl]

	sub 4
	ld d, a
	ld a, e
	sub 4
	ld e, a
	call .check_on_warp

	pop de
	ret
; 35b0

.check_on_warp ; 35b0
	ld hl, wCurrMapWarpHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCurrMapWarpCount]
	and a
	jr z, .nope2

.loop
	push af
	ld a, [hl]
	cp e
	jr nz, .not_on_warp
	inc hl
	ld a, [hld]
	cp d
	jr nz, .not_on_warp
	pop af
	ld d, a
	ld a, [wCurrMapWarpCount]
	sub d
	inc a
	scf
	ret

.not_on_warp
	ld a, 5
	add l
	ld l, a
	jr nc, .no_carry
	inc h
.no_carry

	pop af
	dec a
	jr nz, .loop

.nope2
	and a
	ret
; 35de

.IsObjectInStoneTable: ; 35de
	ld hl, CMDQUEUE_ADDR
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop2
	ld a, [hli]
	cp $ff
	jr z, .nope3
	cp d
	jr nz, .next_inc3
	ld a, [hli]
	cp e
	jr nz, .next_inc2
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr .yes

.next_inc3
	inc hl

.next_inc2
	inc hl
	inc hl
	jr .loop2

.nope3
	and a
	ret

.yes
	scf
	ret
; 3600

CheckTrainerBattle2:: ; 3600

	ldh a, [hROMBank]
	push af

	call SwitchToMapScriptHeaderBank
	call CheckTrainerBattle

	pop bc
	ld a, b
	rst Bankswitch
	ret
; 360d

CheckTrainerBattle:: ; 360d
; Check if any trainer on the map sees the player and wants to battle.

; Skip the player object.
	ld a, 1
	ld de, wMapObjects + OBJECT_LENGTH

.loop

; Start a battle if the object:

	push af
	push de

; Has a sprite
	ld hl, MAPOBJECT_SPRITE
	add hl, de
	ld a, [hl]
	and a
	jr z, .next

; Is a trainer
	ld hl, MAPOBJECT_COLOR
	add hl, de
	ld a, [hl]
	and $f
	cp PERSONTYPE_TRAINER
	jr z, .is_trainer
	cp PERSONTYPE_GENERICTRAINER
	jr nz, .next
.is_trainer

; Is visible on the map
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, de
	ld a, [hl]
	cp -1
	jr z, .next

; Is facing the player...
	call GetObjectStruct
	call FacingPlayerDistance_bc
	jr nc, .next

; ...within their sight range
	ld hl, MAPOBJECT_RANGE
	add hl, de
	ld a, [hl]
	cp b
	jr c, .next

; And hasn't already been beaten
	push bc
	push de
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	pop de
	pop bc
	and a
	jr z, .startbattle

.next
	pop de
	ld hl, OBJECT_LENGTH
	add hl, de
	ld d, h
	ld e, l

	pop af
	inc a
	cp NUM_OBJECTS
	jr nz, .loop
	xor a
	ret

.startbattle
	pop de
	pop af
	ldh [hLastTalked], a
	ld a, b
	ld [wEngineBuffer2], a
	ld a, c
	ld [wEngineBuffer3], a
	jr LoadTrainer_continue
; 3674

TalkToTrainer:: ; 3674
	ld a, 1
	ld [wEngineBuffer2], a
	ld a, -1
	ld [wEngineBuffer3], a

LoadTrainer_continue:: ; 367e
	ld a, [wMapScriptHeaderBank]
	ld [wEngineBuffer1], a

	ldh a, [hLastTalked]
	call GetMapObject

	ld hl, MAPOBJECT_COLOR
	add hl, bc
	ld a, [hl]
	and $f
	cp PERSONTYPE_GENERICTRAINER
	push af
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, bc
	ld a, [wEngineBuffer1]
	call GetFarHalfword
	ld de, wTempTrainerHeader
	pop af
	push af
	ld bc, wGenericTempTrainerHeaderEnd - wTempTrainerHeader
	jr z, .skipCopyingLossPtrAndScriptPtr
	ld bc, wTempTrainerHeaderEnd - wTempTrainerHeader
.skipCopyingLossPtrAndScriptPtr
	ld a, [wEngineBuffer1]
	call FarCopyBytes
	pop af
	jr nz, .notGenericTrainer
	push de
	ld d, h
	ld e, l
	pop hl
	; store 0 loss pointer
	xor a
	ld [hli], a
	ld [hli], a
	; store generic trainer script in script pointer
	ld a, .generic_trainer_script % $100
	ld [hli], a
	ld [hl], .generic_trainer_script / $100
	; store after-battle text in wStashedTextPointer
	ld hl, wStashedTextPointer
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
.notGenericTrainer
	xor a
	ld [wRunningTrainerBattleScript], a
	scf
	ret
; 36a5

.generic_trainer_script
	end_if_just_battled
	jumpstashedtext

FacingPlayerDistance_bc:: ; 36a5
	push de
	call FacingPlayerDistance
	ld b, d
	ld c, e
	pop de
	ret
; 36ad

FacingPlayerDistance:: ; 36ad
; Return carry if the sprite at bc is facing the player,
; and its distance in d.

	ld hl, OBJECT_NEXT_MAP_X ; x
	add hl, bc
	ld d, [hl]

	ld hl, OBJECT_NEXT_MAP_Y ; y
	add hl, bc
	ld e, [hl]

	ld a, [wPlayerStandingMapX]
	cp d
	jr z, .CheckY

	ld a, [wPlayerStandingMapY]
	cp e
	jr z, .CheckX

	and a
	ret

.CheckY:
	ld a, [wPlayerStandingMapY]
	sub e
	jr z, .NotFacing
	jr nc, .Above

; Below
	cpl
	inc a
	ld d, a
	ld e, OW_UP
	jr .CheckFacing

.Above:
	ld d, a
	ld e, OW_DOWN
	jr .CheckFacing

.CheckX:
	ld a, [wPlayerStandingMapX]
	sub d
	jr z, .NotFacing
	jr nc, .Left

; Right
	cpl
	inc a
	ld d, a
	ld e, OW_LEFT
	jr .CheckFacing

.Left:
	ld d, a
	ld e, OW_RIGHT

.CheckFacing:
	call GetSpriteDirection
	cp e
	jr nz, .NotFacing
	scf
	ret

.NotFacing:
	and a
	ret
; 36f5

PrintWinLossText:: ; 3718
	ld a, [wBattleResult]
	ld hl, wWinTextPointer
	and $f
	jr z, .ok
	ld hl, wLossTextPointer

.ok
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMapScriptHeaderBank]
	call FarPrintText
	call ApplyTilemapInVBlank
	jp WaitPressAorB_BlinkCursor
; 3741

PrepMonFrontpic:: ; 3786
	ld a, $1
	ld [wBoxAlignment], a

_PrepMonFrontpic:: ; 378b
	ld a, [wCurPartySpecies]
	call IsAPokemon
	jr c, .not_pokemon

	push hl
	ld de, VTiles2
	predef GetFrontpic
	pop hl
	xor a
	ldh [hGraphicStartTile], a
	lb bc, 7, 7
	predef PlaceGraphic
	xor a
	ld [wBoxAlignment], a
	ret

.not_pokemon
	xor a
	ld [wBoxAlignment], a
	inc a
	ld [wCurPartySpecies], a
	ret
; 37b6

INCLUDE "home/cry.asm"

; 384d

GetRelevantBaseData::
	ld a, [wCurGroup]
;check if pokemon is a variant and put *BaseData in hl and BANK(*BaseData) in d
; returns c for variants, nc for normal species
	ld hl, VariantBaseDataTable
	ld de, 4
	call IsInArray
	inc hl
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

INCLUDE "data/pokemon/variant_base_data_table.asm"

GetBaseData:: ; 3856
	push bc
	push de
	push hl
	ldh a, [hROMBank]
	push af

	call GetRelevantBaseData
	push hl

	ld a, [wCurSpecies]
	dec a
	ld b, a
	ld a, d
	rst Bankswitch
	
	ld a, b
; Get BaseData
	ld bc, BASEMON_STRUCT_LENGTH
	pop hl
	rst AddNTimes
	ld de, wCurBaseData
	ld bc, BASEMON_STRUCT_LENGTH
	rst CopyBytes

;turns out the nat dex no is backwards
	ld a, [wNatDexNo]
	ld d, a
	ld a, [wNatDexNo + 1]
	ld [wNatDexNo], a
	ld a, d
	ld [wNatDexNo + 1], a
	pop af
	rst Bankswitch
	pop hl
	pop de
	pop bc
	ret
; 389c


GetNature::
; 'b' contains the target Nature to check
; returns nature in b
	ld a, [wInitialOptions]
	bit NATURES_OPT, a
	jr z, .no_nature
	ld a, b
	and NATURE_MASK
	; assume nature is 0-24
	ld b, a
	ret

.no_nature:
	ld b, NO_NATURE
	ret


GetAbility::
; 'b' contains the target ability to check
; 'c' contains the target species
; returns ability in b
; preserves curspecies and base data
	push de
	ldh a, [hROMBank]
	push af
	push hl
	push bc

	call GetRelevantBaseData
	pop bc
	push bc
	ld a, c

	dec a
	ld bc, BASEMON_STRUCT_LENGTH
	rst AddNTimes
	ld a, d
	rst Bankswitch

	ld bc, wBaseAbility1 - wCurBaseData
	add hl, bc
	pop bc
	push bc
	ld a, b
	and ABILITY_MASK
	cp ABILITY_1
	jr z, .got_ability_ptr
	inc hl
	cp ABILITY_2
	jr z, .got_ability_ptr
	inc hl
.got_ability_ptr
	ld a, [hl]
	pop bc
	pop hl
.got_ability
	ld b, a
	pop af
	rst Bankswitch
	pop de
	ret

GetCurNick:: ; 389c
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames

GetNick:: ; 38a2
; Get nickname a from list hl.

	push hl
	push bc

	call SkipPokemonNames
	ld de, wStringBuffer1

	push de
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	pop de

	pop bc
	pop hl
	ret
; 38bb

GetEnemyPartyParamLocation::
	push bc
	ld hl, wOTPartyMons
	jr PkmnParamLocation
GetPartyParamLocation:: ; 3917
; Get the location of parameter a from wCurPartyMon in hl
	push bc
	ld hl, wPartyMons
PkmnParamLocation:
	cp MON_GROUP_SPECIES_AND_FORM
	jp z, .species_and_group

	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wCurPartyMon]
	call GetPartyLocation
	pop bc
	ret

.species_and_group
	ld a, [wCurPartyMon]
	call GetPartyLocation
	predef GetPartyMonGroupSpeciesAndForm
	pop bc
	ret
; 3927

GetPartyLocation::
; Add the length of a PartyMon struct to hl a times.
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	pop bc
	ret

INCLUDE "home/battle.asm"

HalveBC::
	srl b
	rr c
FloorBC::
	ld a, c
	or b
	ret nz
	inc c
	ret

PushLYOverrides:: ; 3b0c

	ldh a, [hLCDCPointer]
	and a
	ret z

	ld a, wLYOverridesBackup % $100
	ldh [hRequestedVTileSource], a
	ld a, wLYOverridesBackup / $100
	ldh [hRequestedVTileSource + 1], a

	ld a, wLYOverrides % $100
	ldh [hRequestedVTileDest], a
	ld a, wLYOverrides / $100
	ldh [hRequestedVTileDest + 1], a

	ld a, (wLYOverridesEnd - wLYOverrides) / 16
	ldh [hLYOverrideStackCopyAmount], a
	ret
; 3b2a

_InitSpriteAnimStruct:: ; 3b2a

	ld [wSpriteAnimIDBuffer], a
	ldh a, [hROMBank]
	push af

	ld a, BANK(InitSpriteAnimStruct)
	rst Bankswitch
	ld a, [wSpriteAnimIDBuffer]

	call InitSpriteAnimStruct

	pop af
	rst Bankswitch

	ret
; 3b3c

ReinitSpriteAnimFrame:: ; 3b3c

	ld [wSpriteAnimIDBuffer], a
	ldh a, [hROMBank]
	push af

	ld a, BANK(_ReinitSpriteAnimFrame)
	rst Bankswitch
	ld a, [wSpriteAnimIDBuffer]

	call _ReinitSpriteAnimFrame

	pop af
	rst Bankswitch

	ret
; 3b4e

INCLUDE "home/audio.asm"

Inc16BitNumInHL::
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ret


LoadPalette_White_Col1_Col2_Black::
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals)
	ldh [rSVBK], a

	ld a, (palred 31 + palgreen 31 + palblue 31) % $100
	ld [de], a
	inc de
	ld a, (palred 31 + palgreen 31 + palblue 31) / $100
	ld [de], a
	inc de

	ld c, 2 * 2
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop

	xor a ; RGB 00, 00, 00
rept 2
	ld [de], a
	inc de
endr

	pop af
	ldh [rSVBK], a
	ret
	
GetMonPalette::
	ldh a, [hROMBank]
	push af
; given species in wCurPartySpecies, return *Palette in bc
	push de
	push bc
	ld a, [wCurGroup]
	ld hl, VariantPaletteTable
	ld de, 4
	call IsInArray
	inc hl
	ld a, [hli]
	rst Bankswitch

	ld a, [hli]
	ld c, a
	ld b, [hl]

	ld a, [wCurPartySpecies]
	dec a	
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, bc
	pop bc
	homecall CheckShininess
	jp nc, .not_shiny
rept 4
	inc hl
endr
.not_shiny
	pop de

	call LoadPalette_White_Col1_Col2_Black

	pop af
	rst Bankswitch
	ret

INCLUDE "data/pokemon/variant_palette_table.asm"
