StartMenu:: ; 125cd
	ld a, [wPlayerStairsType]
	and a
	ret nz

	ld de, SFX_MENU
	call PlaySFX
StartMenuNoSFX::
	ld a, 1
	ldh [hRequestOpaque1bpp], a
	call ClearWindowData
	call OtherVariableWidthText

	farcall ReanchorBGMap_NoOAMUpdate

	ld hl, wStatusFlags2
	bit 2, [hl] ; ENGINE_BUG_CONTEST_TIMER
	ld hl, .MenuDataHeader
	jr z, .GotMenuData
	ld hl, .ContestMenuDataHeader
.GotMenuData:

	call LoadMenuDataHeader
	call .SetUpMenuItems
	ld a, [wBattleMenuCursorBuffer]
	ld [wMenuCursorBuffer], a
	call .DrawMenuClock
	call .DrawMenuAccount
	call DrawVariableLengthMenuBox
	call SafeUpdateSprites
	call BGMapAnchorTopLeft
	farcall LoadFonts_NoOAMUpdate
	call UpdateTimePals
	jr .Select

.Reopen:
	ld a, 1
	ldh [hRequestOpaque1bpp], a
	call OtherVariableWidthText
	call UpdateSprites
	call UpdateTimePals
	call .SetUpMenuItems
	ld a, [wBattleMenuCursorBuffer]
	ld [wMenuCursorBuffer], a

.Select:
	call .GetInput
	jr c, .Exit
	ld a, [wMenuCursorBuffer]
	ld [wBattleMenuCursorBuffer], a
	call PlayClickSFX
	call PlaceHollowCursor
	call .OpenMenu

; Menu items have different return functions.
; For example, saving exits the menu.
	ld hl, .MenuReturns
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.MenuReturns:
	dw .Reopen
	dw .Exit
	dw .ExitMenuCallFuncCloseText
	dw .ExitMenuRunScriptCloseText
	dw .ExitMenuRunScript
	dw .ReturnEnd
	dw .ReturnRedraw

.Exit:
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a
	call LoadFontsExtra
	pop af
	ldh [hOAMUpdate], a
.ReturnEnd:
	call ExitMenu
.ReturnEnd2:
	call CloseText
	jp UpdateTimePals

.GetInput:
; Return carry on exit, and no-carry on selection.
	xor a
	ldh [hBGMapMode], a
	call ._DrawMenuClock
	call ._DrawMenuAccount
	call SetUpMenu
	ld a, $ff
	ld [wMenuSelection], a
.loop
	call .PrintMenuClock
	call ReadMenuJoypad
	ld a, [hJoyPressed]
	cp B_BUTTON
	jr z, .b
	cp A_BUTTON
	jr z, .a
	and D_PAD
	jr nz, .dpad
	jr .loop
.a
	call PlayClickSFX
	and a
	ret
.b
	scf
	ret
.dpad
	call .PrintMenuAccount
	jr .loop
; 12691

.ExitMenuRunScript: ; 12691
	call ExitMenu
	ld a, HMENURETURN_SCRIPT
	ldh [hMenuReturn], a
	ret
; 12699

.ExitMenuRunScriptCloseText: ; 12699
	call ExitMenu
	ld a, HMENURETURN_SCRIPT
	ldh [hMenuReturn], a
	jr .ReturnEnd2
; 126a2

.ExitMenuCallFuncCloseText: ; 126a2
	call ExitMenu
	ld hl, wQueuedScriptBank
	call FarPointerCall
	jr .ReturnEnd2
; 126b1

.ReturnRedraw: ; 126b1
	call ClearBGPalettes
	call ExitMenu
	call ReloadTilesetAndPalettes
	call .DrawMenuClock
	call .DrawMenuAccount
	call DrawVariableLengthMenuBox
	call UpdateSprites
	call FinishExitMenu
	jp .Reopen
; 126b7

.MenuDataHeader:
	db $40 ; tile backup
	db 0, 12 ; start coords
	db 17, 19 ; end coords
	dw .MenuData
	db 1 ; default selection

.ContestMenuDataHeader:
	db $40 ; tile backup
	db 2, 12 ; start coords
	db 17, 19 ; end coords
	dw .MenuData
	db 1 ; default selection

.MenuData:
	db %10101000 ; x padding, wrap around, start can close
	dn 0, 0 ; rows, columns
	dw wMenuItemsList
	dw .MenuString
	dw .Items

.Items:
	dw StartMenu_Pokedex,  .PokedexString,  .PokedexDesc
	dw StartMenu_Pokemon,  .PartyString,    .PartyDesc
	dw StartMenu_Pack,     .PackString,     .PackDesc
	dw StartMenu_Status,   .StatusString,   .StatusDesc
	dw StartMenu_Save,     .SaveString,     .SaveDesc
	dw StartMenu_Option,   .OptionString,   .OptionDesc
	dw StartMenu_Exit,     .ExitString,     .ExitDesc
	dw StartMenu_Pokegear, .PokegearString, .PokegearDesc

.PokedexString: 	db "Pokédex@"
.PartyString:   	db "Pokémon@"
.PackString:    	db "Bag@"
.StatusString:  	db "Status@"
.SaveString:    	db "Save@"
.OptionString:  	db "Options@"
.ExitString:    	db "Exit@"
.PokegearString:	db "PokéPDA@"

; Menu accounts are removed; this is vestigial
.PokedexDesc:
	db "Pokémon database@"

.PartyDesc:
	db "Party status@"

.PackDesc:
	db "Contains items@"

.PokegearDesc:
	db "Traveler's device@"

.StatusDesc:
	db "Your own status@"

.SaveDesc:
	db "Save and reset@"

.OptionDesc:
	db "Change settings@"

.ExitDesc:	; unused
	db   "Close this"
	next "menu@"

.QuitDesc:
	db   "Quit and"
	next "be judged.@"

.OpenMenu: ; 127e5
	ld a, [wMenuSelection]
	call .GetMenuAccountTextPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
; 127ef

.MenuString: ; 127ef
	push de
	ld a, [wMenuSelection]
	call .GetMenuAccountTextPointer
	inc hl
	inc hl
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	jp PlaceString
; 12800

.MenuClock:
	VWTextStart $c0
	ld hl, wOptions1
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	hlcoord 1, 1
	lb bc, 2, 7
	call ClearBox
	ldh a, [hHours]
	ld b, a
	ldh a, [hMinutes]
	ld c, a
	decoord 1, 2
	farcall PrintHoursMins
	call InitVariableWidthTiles
	ld hl, .DayText
	bccoord 1, 1
	call PlaceWholeStringInBoxAtOnce
	pop af
	ld [wOptions1], a
	ret

.DayText:
	text_jump UnknownText_0x1c5821
	db "@"

.MenuDesc:
	push de
	call InitVariableWidthText
	ld a, [wMenuSelection]
	cp $ff
	jr z, .none
	call .GetMenuAccountTextPointer
rept 4
	inc hl
endr
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	call PlaceString
	ret
.none
	pop de
	ret

.GetMenuAccountTextPointer: ; 12819
	ld e, a
	ld d, 0
	ld hl, wMenuData2PointerTableAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
rept 6
	add hl, de
endr
	ret
; 12829


.SetUpMenuItems: ; 12829
	xor a
	ld [wWhichIndexSet], a
	call .FillMenuList

	ld hl, wStatusFlags
	bit 0, [hl]
	jr z, .no_pokedex
	xor a ; pokedex
	call .AppendMenuList
.no_pokedex

	ld a, [wPartyCount]
	and a
	jr z, .no_pokemon
	ld a, 1 ; pokemon
	call .AppendMenuList
.no_pokemon

	ld a, [wLinkMode]
	and a
	jr nz, .no_pack
	ld hl, wStatusFlags2
	bit 2, [hl] ; ENGINE_BUG_CONTEST_TIMER
	jr nz, .no_pack
	ld a, 2 ; pack
	call .AppendMenuList
.no_pack

	ld hl, wPokegearFlags
	bit 7, [hl]
	jr z, .no_pokegear
	ld a, 7 ; pokegear
	call .AppendMenuList
.no_pokegear

	ld a, 3 ; status
	call .AppendMenuList

	ld a, [wLinkMode]
	and a
	jr nz, .no_save
	ld hl, wStatusFlags2
	bit 2, [hl] ; ENGINE_BUG_CONTEST_TIMER
	ld a, 8 ; quit
	jr nz, .write
	ld a, 4 ; save
.write
	call .AppendMenuList
.no_save

	ld a, 5 ; option
	call .AppendMenuList
	;ld a, 6 ; exit
	;call .AppendMenuList
	ld a, c
	ld [wMenuItemsList], a
	ret
; 1288d


.FillMenuList: ; 1288d
	xor a
	ld hl, wMenuItemsList
	ld [hli], a
	ld a, -1
	ld bc, wMenuItemsListEnd - (wMenuItemsList + 1)
	call ByteFill
	ld de, wMenuItemsList + 1
	ld c, 0
	ret
; 128a0

.AppendMenuList: ; 128a0
	ld [de], a
	inc de
	inc c
	ret
; 128a4

.DrawMenuClock:
	jp ._DrawMenuClock

.PrintMenuClock:
	call ._DrawMenuClock
	decoord 1, 1
	jp .MenuClock

._DrawMenuClock:
	hlcoord 0, 0
	lb bc, 2, 7
	call TextBox
	hlcoord 0, 0
	lb bc, 2, 7
	jp TextBoxPalette
	ret

.DrawMenuAccount:
	jp ._DrawMenuAccount

.PrintMenuAccount:
	call ._DrawMenuAccount
	decoord 1, 16
	jp .MenuDesc

._DrawMenuAccount:
	hlcoord 0, 15
	lb bc, 1, 18
	call TextBox
	hlcoord 0, 15
	lb bc, 1, 18
	;ld c, 8
	jp TextBoxPalette

StartMenu_Exit: ; 128ed
; Exit the menu.

	ld a, 1
	ret
; 128f0

StartMenu_Save: ; 1290b
; Save the game.

	call BufferScreen
	call ExitMenu
	call OtherVariableWidthText
	farcall SaveMenu
	call c, StartMenuNoSFX
	call CloseText
	jp UpdateTimePals
; 1291c


StartMenu_Option: ; 1291c
; Game options.

	call FadeToMenu
	farcall OptionsMenu
	ld a, 6
	ret
; 12928


StartMenu_Status: ; 12928
; Player status.

	call FadeToMenu
	farcall TrainerCard
	call CloseSubmenu
	xor a
	ret
; 12937


StartMenu_Pokedex: ; 12937

	ld a, [wPartyCount]
	and a
	jr z, .asm_12949

	call FadeToMenu
	farcall Pokedex
	call CloseSubmenu

.asm_12949
	xor a
	ret
; 1294c


StartMenu_Pokegear: ; 1294c

	call FadeToMenu
	farcall InitPokegearPalettes
	farcall PokeGear
	call CloseSubmenu
	call ApplyTilemapInVBlank
	call SetPalettes
	call DelayFrame
	xor a
	ret
; 1295b


StartMenu_Pack: ; 1295b

	call FadeToMenu
	call Pack
	ld a, [wcf66]
	and a
	jr nz, .used_item
	call CloseSubmenu
	xor a
	ret

.used_item
	call ExitAllMenus
	ld a, 4
	ret
; 12976


StartMenu_Pokemon: ; 12976

	ld a, [wPartyCount]
	and a
	jr z, .return

	call FadeToMenu

.choosemenu
	xor a
	ld [wPartyMenuActionText], a ; Choose a POKéMON.
	call ClearBGPalettes

.menu
	farcall LoadPartyMenuGFX
	farcall InitPartyMenuWithCancel
	farcall InitPartyMenuGFX

.menunoreload
	farcall WritePartyMenuTilemap
	farcall PrintPartyMenuText
	call ApplyTilemapInVBlank
	call SetPalettes ; load regular palettes?
	call DelayFrame
	farcall PartyMenuSelect
	jr c, .return ; if cancelled or pressed B

if DEF(DEBUG)
	ldh a, [hJoyDown]
	and START
	jr nz, .editor
endc

	call PokemonActionSubmenu
	push af
	call SFXDelay2
	pop af
	cp MONSUBMENU_RELOAD
	jr z, .menu
	cp MONSUBMENU_CHOOSE
	jr z, .choosemenu
	cp MONSUBMENU_NORELOAD
	jr z, .menunoreload
	cp MONSUBMENU_QUIT
	jr z, .quit

.return
	call CloseSubmenu
	xor a
	ret

if DEF(DEBUG)
.editor
	farcall EditPartyMon
endc

.quit
	ld a, b
	push af
	call ExitAllMenus
	pop af
	ret
; 129d5

HasNoItems: ; 129d5
	ld a, [wNumItems]
	and a
	ret nz
	ld a, [wNumMedicine]
	and a
	ret nz
	ld a, [wNumBalls]
	and a
	ret nz
	ld a, [wNumBerries]
	and a
	ret nz
	;ld a, [wNumKeyItems]
	;and a
	ret nz
	scf
	ret

TossItemFromPC: ; 129f4
	push de
	call PartyMonItemName
	farcall CheckTossableItem
	ld a, [wItemAttributeParamBuffer]
	and a
	jr nz, .key_item
	ld hl, .TossHowMany
	call MenuTextBox
	farcall SelectQuantityToToss
	push af
	call CloseWindow
	call ExitMenu
	pop af
	jr c, .quit
	ld hl, .ConfirmToss
	call MenuTextBox
	call YesNoBox
	push af
	call ExitMenu
	pop af
	jr c, .quit
	pop hl
	ld a, [wCurItemQuantity]
	call TossItem
	call PartyMonItemName
	ld hl, .TossedThisMany
	call MenuTextBox
	call ExitMenu
	and a
	ret

.key_item
	call .CantToss
.quit
	pop hl
	scf
	ret

.TossHowMany:
	; Toss out how many @ (S)?
	text_jump UnknownText_0x1c1a90
	db "@"

.ConfirmToss:
	; Throw away @ @ (S)?
	text_jump UnknownText_0x1c1aad
	db "@"

.TossedThisMany:
	; Discarded @ (S).
	text_jump UnknownText_0x1c1aca
	db "@"

.CantToss:
	ld hl, .TooImportantToToss
	jp MenuTextBoxBackup

.TooImportantToToss:
	; That's too impor- tant to toss out!
	text_jump UnknownText_0x1c1adf
	db "@"
; 0x12a60

CantUseItem: ; 12a60
	ld hl, CantUseItemText
	jp MenuTextBoxWaitButton
; 12a67

CantUseItemText: ; 12a67
	text_jump Text_ICantUseThatNow
	db "@"
; 12a6c


PartyMonItemName: ; 12a6c
	ld a, [wCurItem]
	ld [wd265], a
	call GetItemName
	jp CopyName1
; 12a79


CancelPokemonAction: ; 12a79
	farcall InitPartyMenuWithCancel
	farcall UnfreezeMonIcons
	ld a, 1
	ret
; 12a88


PokemonActionSubmenu: ; 12a88
	call InitVariableWidthText
	hlcoord 1, 15
	lb bc, 2, 18
	call ClearBox
	farcall MonSubmenu
	call InitVariableWidthText
	farcall GetCurNick
	ld a, [wMenuSelection]
	ld hl, .Actions
	ld de, 3
	call IsInArray
	jr nc, .nothing

	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.nothing
	xor a
	ret

.Actions:
	dbw MONMENU_CUT,        MonMenu_Cut ; Cut
	dbw MONMENU_FLY,        MonMenu_Fly ; Fly
	dbw MONMENU_SURF,       MonMenu_Surf ; Surf
	dbw MONMENU_STRENGTH,   MonMenu_Strength ; Strength
	dbw MONMENU_FLASH,      MonMenu_Flash ; Flash
	dbw MONMENU_WHIRLPOOL,  MonMenu_Whirlpool ; Whirlpool
	dbw MONMENU_DIG,        MonMenu_Dig ; Dig
	dbw MONMENU_TELEPORT,   MonMenu_Teleport ; Teleport
	dbw MONMENU_SOFTBOILED, MonMenu_Softboiled_MilkDrink ; Softboiled
	dbw MONMENU_MILKDRINK,  MonMenu_Softboiled_MilkDrink ; MilkDrink
	dbw MONMENU_HEADBUTT,   MonMenu_Headbutt ; Headbutt
	dbw MONMENU_WATERFALL,  MonMenu_Waterfall ; Waterfall
	dbw MONMENU_ROCKSMASH,  MonMenu_RockSmash ; RockSmash
	dbw MONMENU_STATS,      OpenPartyStats
	dbw MONMENU_SWITCH,     SwitchPartyMons
	dbw MONMENU_ITEM,       GiveTakePartyMonItem
	dbw MONMENU_CANCEL,     CancelPokemonAction
	dbw MONMENU_MOVE,       ManagePokemonMoves ; move
	dbw MONMENU_FOLLOW,     SetFollower
	dbw MONMENU_STOPFOLLOW, StopFollower
; 12aec


SwitchPartyMons: ; 12aec

; Don't try if there's nothing to switch!
	ld a, [wPartyCount]
	cp 2
	jr c, .DontSwitch

	ld a, [wCurPartyMon]
	inc a
	ld [wSwitchMon], a

	farcall HoldSwitchmonIcon
	farcall InitPartyMenuNoCancel

	ld a, 4
	ld [wPartyMenuActionText], a
	farcall WritePartyMenuTilemap
	farcall PrintPartyMenuText

	hlcoord 0, 1
	ld bc, 20 * 2
	ld a, [wSwitchMon]
	dec a
	rst AddNTimes
	ld [hl], "▷"
	call ApplyTilemapInVBlank
	call SetPalettes
	call DelayFrame

	farcall PartyMenuSelect
	bit 1, b
	jr c, .DontSwitch

	farcall _SwitchPartyMons

	xor a
	ld [wPartyMenuActionText], a

	farcall LoadPartyMenuGFX
	farcall InitPartyMenuWithCancel
	farcall InitPartyMenuGFX

	ld a, MONSUBMENU_NORELOAD
	ret

.DontSwitch:
	xor a
	ld [wPartyMenuActionText], a
	jp CancelPokemonAction
; 12b60


GiveTakePartyMonItem: ; 12b60
; Eggs can't hold items!
	ld a, MON_IS_EGG
	predef GetPartyParamLocation
	bit MON_IS_EGG_F, [hl]
	jr nz, .cancel

	call GetPartyItemLocation
	ld a, [hl]
	and a
	ld de, .noItemString
	jr z, .not_holding_anything
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld de, wStringBuffer1
.not_holding_anything
	hlcoord 1, 16
	call PlaceString
	ld hl, GiveTakeItemMenuData
	call LoadMenuDataHeader
	call VerticalMenu
	call ExitMenu
	jr c, .cancel

	farcall GetCurNick
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ld a, [wMenuCursorY]
	cp 1
	jr nz, .take

	call LoadStandardMenuDataHeader
	call ClearPalettes
	call .GiveItem
	call ClearPalettes
	call LoadFontsBattleExtra
	call ExitMenu
	ld a, MONSUBMENU_CHOOSE
	ret

.take
	call TakePartyItem
	ld a, MONSUBMENU_RELOAD
	ret

.cancel
	ld a, MONSUBMENU_RELOAD
	ret
; 12ba9

.noItemString
	db "No held item@"

.GiveItem:

	call DepositSellInitPackBuffers

.loop
	call DepositSellPack

	ld a, [wcf66]
	and a
	ret z

	ld a, [wCurrPocket]
	cp KEY_ITEM - 1
	jr z, .next
	cp TM_HM - 1
	jr z, .next

	farcall CheckTossableItem
	ld a, [wItemAttributeParamBuffer]
	and a
	jr nz, .next

	jp TryGiveItemToPartymon

.next
	ld hl, CantBeHeldText
	call MenuTextBoxBackup
	jr .loop
; 12bd9


TryGiveItemToPartymon: ; 12bd9

	call SpeechTextBox
	call PartyMonItemName
	call GetPartyItemLocation
	ld a, [hl]
	and a
	jr z, .give_item_to_mon

	ld d, a
	ld a, [hl]
	jr .already_holding_item

.give_item_to_mon
	call GiveItemToPokemon
	ld hl, MadeHoldText
	call MenuTextBoxBackup
	jp GivePartyItem

.already_holding_item
	ld [wd265], a
	call GetItemName
	ld hl, SwitchAlreadyHoldingText
	call StartMenuYesNo
	ret c

	call GiveItemToPokemon
	ld a, [wd265]
	push af
	ld a, [wCurItem]
	ld [wd265], a
	pop af
	ld [wCurItem], a
	call ReceiveItemFromPokemon
	jr nc, .bag_full

	ld hl, TookAndMadeHoldText
	call MenuTextBoxBackup
	ld a, [wd265]
	ld [wCurItem], a
	jp GivePartyItem

.bag_full
	ld a, [wd265]
	ld [wCurItem], a
	call ReceiveItemFromPokemon
	ld hl, ItemStorageIsFullText
	jp MenuTextBoxBackup
; 12c4c


GivePartyItem: ; 12c4c

	call GetPartyItemLocation
	ld a, [wCurItem]
	ld [hl], a
	ld d, a
	ret
; 12c60


TakePartyItem: ; 12c60

	call SpeechTextBox
	call GetPartyItemLocation
	ld a, [hl]
	and a
	jr z, .asm_12c8c

	ld [wCurItem], a
	call ReceiveItemFromPokemon
	jr nc, .asm_12c94

	call GetPartyItemLocation
	ld a, [hl]
	ld [wd265], a
	ld [hl], NO_ITEM
	call GetItemName
	ld hl, TookFromText
	jp MenuTextBoxBackup

.asm_12c8c
	ld hl, IsntHoldingAnythingText
	jp MenuTextBoxBackup

.asm_12c94
	ld hl, ItemStorageIsFullText
	jp MenuTextBoxBackup
; 12c9b


GiveTakeItemMenuData: ; 12c9b
	db %01010000
	db 12, 13 ; start coords
	db 17, 19 ; end coords
	dw .Items
	db 1 ; default option

.Items:
	db %10000000 ; x padding
	db 2 ; # items
	db "Give@"
	db "Take@"
; 12caf


TookAndMadeHoldText: ; 12caf
	text_jump UnknownText_0x1c1b2c
	db "@"
; 12cb4

MadeHoldText: ; 12cb4
	text_jump UnknownText_0x1c1b57
	db "@"
; 12cb9

PleaseRemoveMailText: ; 12cb9
	text_jump UnknownText_0x1c1b6f
	db "@"
; 12cbe

IsntHoldingAnythingText: ; 12cbe
	text_jump UnknownText_0x1c1b8e
	db "@"
; 12cc3

ItemStorageIsFullText: ; 12cc3
	text_jump UnknownText_0x1c1baa
	db "@"
; 12cc8

TookFromText: ; 12cc8
	text_jump UnknownText_0x1c1bc4
	db "@"
; 12ccd

SwitchAlreadyHoldingText: ; 12ccd
	text_jump UnknownText_0x1c1bdc
	db "@"
; 12cd2

CantBeHeldText: ; 12cd2
	text_jump UnknownText_0x1c1c09
	db "@"
; 12cd7


GetPartyItemLocation: ; 12cd7
	push af
	ld a, MON_ITEM
	predef GetPartyParamLocation
	pop af
	ret
; 12cdf


ReceiveItemFromPokemon: ; 12cdf
	ld a, $1
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	jp ReceiveItem
; 12cea


GiveItemToPokemon: ; 12cea (4:6cea)
	ld a, $1
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	jp TossItem

StartMenuYesNo: ; 12cf5
	call MenuTextBox
	call YesNoBox
	jp ExitMenu
; 12cfe

OpenPartyStats: ; 12e00
	call LoadStandardMenuDataHeader
	call ClearSprites
; PartyMon
	xor a
	ld [wMonType], a
	call LowVolume
	predef StatsScreenInit
	call MaxVolume
	call ExitMenu
	ld a, MONSUBMENU_CHOOSE
	ret
; 12e1b


MonMenu_Cut: ; 12e1b
	farcall CutFunction
_MonMenu_StandardCheck:
	ld a, [wFieldMoveSucceeded]
	cp $1
	jr nz, _MonMenu_StandardFail
_MonMenu_StandardSuccess:
	ld b, $4
	ld a, $2
	ret

_MonMenu_StandardFail:
	ld a, MONSUBMENU_RELOAD
	ret
; 12e30

MonMenu_Fly: ; 12e30
	farcall FlyFunction
	ld a, [wFieldMoveSucceeded]
	cp $0
	jr z, .Error
	cp $2
	jr z, _MonMenu_StandardFail
	jr _MonMenu_StandardSuccess

.Error:
	ld a, MONSUBMENU_CHOOSE
	ret

MonMenu_Flash: ; 12e55
	farcall OWFlash
	jr _MonMenu_StandardCheck
; 12e6a

MonMenu_Strength: ; 12e6a
	farcall StrengthFunction
	jr _MonMenu_StandardCheck
; 12e7f

MonMenu_Whirlpool: ; 12e7f
	farcall WhirlpoolFunction
	jr _MonMenu_StandardCheck
; 12e94

MonMenu_Waterfall: ; 12e94
	farcall WaterfallFunction
	jr _MonMenu_StandardCheck
; 12ea9

MonMenu_Teleport: ; 12ea9
	farcall TeleportFunction
_MonMenu_AlternateCheck:
	ld a, [wFieldMoveSucceeded]
	and a
	jr z, _MonMenu_StandardFail
	jr _MonMenu_StandardSuccess
; 12ebd

MonMenu_Surf: ; 12ebd
	farcall SurfFunction
	jr _MonMenu_AlternateCheck
; 12ed1

MonMenu_Dig: ; 12ed1
	farcall DigFunction
	jr _MonMenu_StandardCheck
; 12ee6

MonMenu_Headbutt: ; 12f26
	farcall HeadbuttFunction
	jr _MonMenu_StandardCheck
; 12f3b

MonMenu_RockSmash: ; 12f3b
	farcall RockSmashFunction
	jr _MonMenu_StandardCheck
; 12f50

MonMenu_Softboiled_MilkDrink: ; 12ee6
	call .CheckMonHasEnoughHP
	jr nc, .NotEnoughHP
	farcall Softboiled_MilkDrinkFunction
	jr .finish

.NotEnoughHP:
	ld hl, .Text_NotEnoughHP
	call PrintText

.finish
	xor a
	ld [wPartyMenuActionText], a
	ld a, MONSUBMENU_RELOAD
	ret
; 12f00

.Text_NotEnoughHP:
	; Not enough HP!
	text_jump UnknownText_0x1c1ce3
	db "@"
; 0x12f05

.CheckMonHasEnoughHP:
; Need to have at least (MaxHP / 5) HP left.
	ld a, MON_MAXHP
	predef GetPartyParamLocation
	ld a, [hli]
	ldh [hDividend + 0], a
	ld a, [hl]
	ldh [hDividend + 1], a
	ld a, 5
	ldh [hDivisor], a
	ld b, 2
	call Divide
	ld a, MON_HP + 1
	predef GetPartyParamLocation
	ldh a, [hQuotient + 2]
	sub [hl]
	dec hl
	ldh a, [hQuotient + 1]
	sbc [hl]
	ret
; 12f26

	const_def
	const MOVESCREEN_NORMAL
	const MOVESCREEN_DELETER
	const MOVESCREEN_NEWMOVE
	const MOVESCREEN_REMINDER

ChooseMoveToDelete:
	ld hl, wOptions1
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call LoadFontsBattleExtra
	ld a, MOVESCREEN_DELETER
	ld [wMoveScreenMode], a
	call MoveScreenLoop
	pop bc
	push af
	ld a, b
	ld [wOptions1], a
	call ClearBGPalettes
	pop af
	ret

ChooseMoveToForget:
	ld hl, wOptions1
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call LoadTileMapToTempTileMap
	call LoadFontsBattleExtra
	ld a, MOVESCREEN_NEWMOVE
	ld [wMoveScreenMode], a
	call MoveScreenLoop
	pop bc
	push af
	ld a, b
	ld [wOptions1], a
	call ClearBGPalettes
	ld a, [wBattleMode]
	and a
	jr z, .tm_tutor

	; Level up in battle
	call ClearTileMap
	call ClearSprites
	call ClearPalettes
	call DelayFrame
	call UpdateSprites
	farcall FinishBattleAnim
	farcall _LoadBattleFontsHPBar
	farcall GetMonBackpic
	call LoadTempTileMapToTileMap
	jr .done

.tm_tutor
	farcall LoadPartyMenuGFX
	farcall InitPartyMenuWithCancel
	farcall InitPartyMenuGFX
	farcall WritePartyMenuTilemap
	farcall PrintPartyMenuText
	call SpeechTextBox
.done
	call ApplyTilemapInVBlank
	call SetPalettes
	call DelayFrame
	pop af
	ret

ChooseMoveToRelearn:
	ld hl, wOptions1
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call LoadFontsBattleExtra
	ld a, MOVESCREEN_REMINDER
	ld [wMoveScreenMode], a
	call MoveScreenLoop
	pop bc
	push af
	ld a, b
	ld [wOptions1], a
	jr c, .no_moves
	call ClearBGPalettes
	ld a, [wCurPartyMon]
	push af
	farcall LoadPartyMenuGFX
	farcall InitPartyMenuWithCancel
	farcall InitPartyMenuGFX
	farcall WritePartyMenuTilemap
	farcall PrintPartyMenuText
	pop af
	ld [wCurPartyMon], a
	pop af
	push af
	call nz, SpeechTextBox
	call ApplyTilemapInVBlank
	call SetPalettes
	call DelayFrame
.no_moves
	pop af
	ret

ManagePokemonMoves: ; 12fba
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	ld hl, wOptions1
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	xor a
	ld [wMoveScreenMode], a
	call MoveScreenLoop
	pop af
	ld [wOptions1], a
	call ClearBGPalettes

.egg
	ld a, MONSUBMENU_CHOOSE
	ret
; 12fd5

MoveScreenLoop:
; Returns:
; a = >0: f = nc|nz; selected move (index in wMoveScreenSelectedMove)
; a =  0: f = nc|z;  user pressed B
;         f = c;     no options existed, move screen was aborted early
	xor a
	ld [wMoveScreenSelectedMove], a
	ld [wMoveScreenSelectedMove+1], a
	ld [wMoveScreenCursor], a
	ld [wMoveScreenOffset], a
	ld [wMoveScreenNumMoves], a

	; Zero the first 4 moves to avoid oddities if we have less than 4 total
	ld hl, wMoveScreenMoves
	ld b, NUM_MOVES * 2
	xor a
.zero_movescreenmoves
	ld [hli], a
	dec b
	jr nz, .zero_movescreenmoves
	ld a, [wMoveScreenMode]
	cp MOVESCREEN_REMINDER
	jr z, .movecopy_reminder

	; Copy over moves from the party struct
	ld a, MON_MOVES
	predef GetPartyParamLocation
	ld de, wMoveScreenMoves
	ld bc, NUM_MOVES
.movecopy_loop
	ld a, [hli]
	and a
	jr z, .movecopy_done
	ld [de], a
	inc de
	push hl
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	ld [de], a
	inc de
	pop hl
	inc b
	dec c
	jr nz, .movecopy_loop

.movecopy_done
	; If we're learning a new move, append the move to the move list buffer
	ld a, [wMoveScreenMode]
	cp MOVESCREEN_NEWMOVE
	jr nz, .newmove_done
	ld a, [wPutativeTMHMMove]
	ld [de], a
	inc de
	ld a, [wPutativeTMHMMove+1]
	ld [de], a
	inc b
	jr .newmove_done

.movecopy_reminder
	call GetForgottenMoves
	ld b, c
.newmove_done
	ld a, b
	ld [wMoveScreenNumMoves], a
	sub 1
	ret c ; no moves

	; Initialize the interface
	call SetUpMoveScreenBG
	call MoveScreen_ListMoves
	jr .loop
.outer_loop
	call MoveScreen_ListMovesFast
.pressed_start
	ld c, 5
	call DelayFrames
.loop
	farcall PlaySpriteAnimationsAndDelayFrame
	call JoyTextDelay

	; allow d-pad to be held, but not a/b/start/select
	ldh a, [hJoyPressed]
	and BUTTONS
	ld b, a
	ldh a, [hJoyDown]
	and D_PAD
	or b
	rrca
	jr c, .pressed_a
	rrca
	jr c, .pressed_b
	rrca
	jr c, .pressed_select
	rrca
	jr c, .pressed_start
	rrca
	jp c, .pressed_right
	rrca
	jp c, .pressed_left
	rrca
	jp c, .pressed_up
	rrca
	jp c, .pressed_down
	jr .loop
.pressed_a
	ld a, [wMoveScreenMode]
	and a ; cp MOVESCREEN_NORMAL
	jr z, .swap_move
	ld de, SFX_ACCEPT
	call PlaySFX
	ld a, [wMoveScreenCursor]
	ld c, a
	ld a, [wMoveScreenOffset]
	add c
	ld c, a
	ld b, 0
	ld hl, wMoveScreenMoves
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wMoveScreenSelectedMove], a
	ld a, [hl]
	and MOVE_HIGH_MASK
	ld [wMoveScreenSelectedMove+1], a
	ld a, [wMoveScreenMode]
	cp MOVESCREEN_NEWMOVE
	ld a, c
	jr nz, .ok
	push bc
	ld a, [wMoveScreenSelectedMove]
	ld c, a
	ld a, [wMoveScreenSelectedMove+1]
	ld b, a
	call IsHMMove
	pop bc
	ld a, c
	jr nc, .ok
	cp 4 ; selected new move
	jr z, .ok
	ld hl, Text_CantForgetHM
	call PrintTextNoBox
	jp .outer_loop
.ok
	inc a
	and a
	ret
.pressed_b
	ld de, SFX_CANCEL
	call PlaySFX
	ld a, [wMoveSwapBuffer]
	and a
	ret z
	xor a
	ld [wMoveSwapBuffer], a
	jp .outer_loop
.pressed_select
	ld a, [wMoveScreenMode]
	and a
	jp nz, .loop
.swap_move
	; check if we are in swap mode
	ld a, [wMoveSwapBuffer]
	and a
	jp nz, .perform_swap
	ld a, [wMoveScreenCursor]
	inc a
	ld [wMoveSwapBuffer], a
	jp .outer_loop
.pressed_right
	ld a, [wMoveScreenMode]
	and a
	jr z, .species_right
	ld a, [wMoveScreenCursor]
	cp 3
	jp z, .far_down
	ld a, [wMoveScreenNumMoves]
	dec a
	cp 4
	jp c, .update_screen_cursor
	ld a, 3
	jp .update_screen_cursor
.species_right
	ld a, [wPartyCount]
	ld d, a
	ld a, [wCurPartyMon]
	dec d
	cp d
	jp z, .loop
.loop_right
	inc a
	ld d, a
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1IsEgg
	rst AddNTimes
	ld a, [hl]
	and IS_EGG_MASK
	ld a, d
	jr nz, .loop_right_invalid
	ld hl, wPartyMon1Group
	rst AddNTimes
	predef GetPartyMonGroupSpeciesAndForm
	ld a, [wCurPartySpecies]
	farcall IsAPokemon
	ld a, d
	jr c, .loop_right_invalid
	ld [wCurPartyMon], a
	jp MoveScreenLoop
.loop_right_invalid
	ld a, [wPartyCount]
	dec a
	cp d
	ld a, d
	jp z, .loop
	jr .loop_right
.pressed_left
	ld a, [wMoveScreenMode]
	and a
	jp z, .species_left
	ld a, [wMoveScreenCursor]
	and a
	jr z, .far_up
	xor a
	jr .update_screen_cursor
.species_left
	ld a, [wCurPartyMon]
	and a
	jp z, .loop
.loop_left
	dec a
	ld d, a
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1IsEgg
	rst AddNTimes
	ld a, [hl]
	and IS_EGG_MASK
	ld a, d
	jr nz, .loop_left_invalid
	ld hl, wPartyMon1Group
	rst AddNTimes
	predef GetPartyMonGroupSpeciesAndForm
	ld a, [wCurPartySpecies]
	farcall IsAPokemon
	ld a, d
	jr c, .loop_left_invalid
	ld [wCurPartyMon], a
	jp MoveScreenLoop
.loop_left_invalid
	and a
	jp z, .loop
	jr .loop_left
.pressed_up
	ld a, [wMoveScreenCursor]
	and a
	jr z, .scroll_up
	dec a
	jr .update_screen_cursor
.pressed_down
	ld a, [wMoveScreenNumMoves]
	ld b, a
	ld a, [wMoveScreenCursor]
	cp 3
	jr z, .scroll_down
	inc a
	cp b
	jp nc, .outer_loop ; less than 4 moves
.update_screen_cursor
	ld [wMoveScreenCursor], a
	jp .outer_loop
.far_up
	ld a, [wMoveScreenOffset]
	sub 4
	jr nc, .update_screen_offset
	xor a
	jr .update_screen_offset
.scroll_up
	ld a, [wMoveScreenOffset]
	and a
	jp z, .outer_loop
	dec a
	jr .update_screen_offset
.far_down
	ld a, [wMoveScreenNumMoves]
	sub 4
	ld b, a
	ld a, [wMoveScreenOffset]
	add 4
	cp b
	jr c, .update_screen_offset
	ld a, b
	jr .update_screen_offset
.scroll_down
	ld a, [wMoveScreenNumMoves]
	ld b, a
	ld a, [wMoveScreenOffset]
	add 4
	sub b
	jp nc, .outer_loop
	ld a, [wMoveScreenOffset]
	inc a
.update_screen_offset
	ld [wMoveScreenOffset], a
	call MoveScreen_ListMoves
	jp .loop

.perform_swap
	ld a, [wBattleMode]
	and a
	jr z, .regular_swap_move

	; If we're transformed, the Moves screen shows our original moveset.
	; So swapping in the moves screen swap our original moves, while
	; swapping in the battle interface swaps our temporary moves.
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .regular_swap_move
	ld a, [wMoveScreenCursor]
	inc a
	ld [wMenuCursorY], a
	farcall SwapBattleMoves
	jr .finish_swap

.regular_swap_move
	ld a, MON_MOVES
	predef GetPartyParamLocation
	call .swap_location
	ld a, MON_MOVES_HIGH
	predef GetPartyParamLocation
	call .swap_location
	ld a, MON_CUR_PP
	predef GetPartyParamLocation
	call .swap_location

.finish_swap
	ld hl, wMoveScreenMoves
	call .swap_location_two
	ld de, SFX_SWITCH_POKEMON
	call PlaySFX
	call WaitSFX
	ld de, SFX_SWITCH_POKEMON
	call PlaySFX
	call WaitSFX
	xor a
	ld [wMoveSwapBuffer], a
	call MoveScreen_ListMoves
	jp .loop

.swap_location
	ld a, [wMoveScreenCursor]
	ld b, 0
	ld c, a
	push hl
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wMoveSwapBuffer]
	dec a
	ld c, a
	add hl, bc
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	ret

.swap_location_two
	ld a, [wMoveScreenCursor]
	ld b, 0
	ld c, a
	push hl
	add hl, bc
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wMoveSwapBuffer]
	dec a
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [de]
	ld b, [hl]
	ld [hli], a
	ld a, b
	ld [de], a
	inc de
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	ret

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

GetForgottenMoves::
; retrieve a list of a mon's forgotten moves, excluding ones beyond level
; and moves the mon already knows
	ld a, MON_GROUP_SPECIES_AND_FORM
	predef GetPartyParamLocation
	ld a, [wCurGroup]
	farcall GetRelevantEvosAttacksPointers
.skip_evos
	ld a, d ;bank
	call GetFarByte
	inc hl
	and a
	jr nz, .skip_evos

	push de ;1
	ld de, wMoveScreenMoves
	ld c, a
	ld b, 100 ; Gen VII behaviour
	inc b ; so that we can use jr nc
.loop
	pop af ;0
	push af;1
	call GetFarByte
	inc hl
	inc sp ;0
	and a
	ret z
	dec sp ;1
	cp b
	ret nc
	pop af ; 0
	push af; 1
	call GetFarByte
	inc hl

	; exclude moves the user already knows
	push hl ;2
	push bc ;3
	ld b, a
	ld a, MON_MOVES
	predef GetPartyParamLocation
	ld c, NUM_MOVES
	ld a, b
	call .move_exists
	jr z, .already_knows_move
	pop bc ;2
	push bc;3
	jr .move_ok
	ld b, 0
	ld hl, wMoveScreenMoves
	call .move_exists
	jr z, .already_knows_move
.move_ok
	pop bc ;2
	pop hl ;1
	ld [de], a
	inc de
	inc c
	jr .loop
.already_knows_move
	pop bc ;2
	pop hl ;1
	jr .loop

.move_exists
	ld b, a
.move_exists_loop
	ld a, [hli]
	cp b
	ret z
	dec c
	jr nz, .move_exists_loop
	pop af;0
	inc c ; ret nz
	ld a, b
	ret

String_MoveSwap: ; 1316b
	db "Switch with?@"
; 13172

SetUpMoveScreenBG: ; 13172
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	xor a
	ldh [hBGMapMode], a
	ld b, CGB_PARTY_MENU
	call GetCGBLayout
	farcall LoadStatsGFX
	farcall ClearSpriteAnims2
	ld a, [wCurPartyMon]
	ld e, a
	ld d, $0
	ld hl, wPartySpecies
	add hl, de
	ld a, [hl]
	ld [wd265], a
	farcall LoadMoveMenuMonIcon
	hlcoord 0, 1
	lb bc, 9, 18
	call TextBox
	hlcoord 0, 11
	lb bc, 5, 18
	call TextBox
	hlcoord 2, 0
	lb bc, 2, 3
	call ClearBox
	xor a
	ld [wMonType], a
	VWTextStart $c6
	ld hl, wPartyMonNicknames
	ld a, [wCurPartyMon]
	predef GetNick
	hlcoord 5, 1
	call PlaceString
	push bc
	farcall CopyPkmnToTempMon
	pop hl
	inc hl
	farcall PrintLevel
	ld hl, wPlayerHPPal
	call SetHPPal
	call SetPalettes
	hlcoord 16, 0
	lb bc, 1, 3
	jp ClearBox
; 131ef

MoveScreen_ListMoves:
	ld c, 2
	call DelayFrames
	hlcoord 1, 2
	lb bc, 14, 18
	call ClearBox
	xor a
	ldh [hBGMapMode], a
	ld hl, wMoveScreenMoves
	ld b, a
	ld a, [wMoveScreenOffset]
	ld c, a
	add hl, bc
	add hl, bc
	ld de, wListMoves_MoveIndicesBuffer
	ld c, NUM_MOVES
.ChangeIndexOrderLoop
	ld a, [hli]
	ld [de], a
	inc de
	push de
	inc de
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	pop de
	dec c
	jr nz, .ChangeIndexOrderLoop

	ld a, SCREEN_WIDTH * 2 ; move list spacing
	ld [wBuffer1], a
	call OtherVariableWidthText
	hlcoord 2, 3
	predef ListMoves

	; Get PP -- either current PP, or default PP for the move
	ld hl, wListMoves_MoveIndicesBuffer
	ld de, wTempMonMoves
	ld bc, NUM_MOVES*2
	rst CopyBytes

	; Get default PP for moves
	ld c, NUM_MOVES
	ld hl, wTempMonMoves
	ld de, wTempMonCurPP
.defaultpp_loop
	ld a, [hli]
	push hl
	push bc
	ld c, a
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	and MOVE_HIGH_MASK
	ld b, a
	dec bc
	ld hl, Moves + MOVE_PP
	ld a, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	ld [de], a
	inc de
	pop bc
	pop hl
	dec c
	jr nz, .defaultpp_loop

	; Get current PP for current moves
	ld a, [wMoveScreenMode]
	cp MOVESCREEN_REMINDER
	jr z, .got_pp
	ld a, MON_CUR_PP
	predef GetPartyParamLocation
	ld c, NUM_MOVES
	ld de, wTempMonCurPP
	ld a, [wMoveScreenOffset]
.currentpp_loop
	and a
	jr z, .currentpp_ok
	dec a
	jr .currentpp_next
.currentpp_ok
	push af
	ld a, [hl]
	ld [de], a
	inc de
	pop af
.currentpp_next
	inc hl
	dec c
	jr nz, .currentpp_loop

.got_pp
	; Now we have things set up correctly
	hlcoord 10, 4
	predef ListMovePP
	hlcoord 1, 12, wAttrMap
	ld bc, 6
	xor a
	call ByteFill

	farcall ApplyAttrMap

MoveScreen_ListMovesFast:
	hlcoord 0, 11
	lb bc, 5, 18
	call TextBox
	ld hl, wTempMonMoves
	ld a, [wMoveScreenCursor]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld [wCurMove], a
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	and MOVE_HIGH_MASK
	ld [wCurMoveHigh], a

	hlcoord 1, 1 ; 2 below topmost position
	ld bc, SCREEN_WIDTH * 2
	ld a, [wMoveSwapBuffer]
	ld d, a
	ld a, [wMoveScreenCursor]
	inc a
	ld e, a
	xor a
.cursor_loop
	inc a
	add hl, bc
	ld [hl], " "
	cp d
	jr nz, .not_selected_swap
	ld [hl], "▷"
.not_selected_swap
	cp e
	jr nz, .not_selected
	ld [hl], "▶"
.not_selected
	cp NUM_MOVES
	jr nz, .cursor_loop
	ld a, [wMoveScreenOffset]
	and a
	jr z, .skip_up
	hlcoord 18, 2
	ld a, "▲"
	ld [hl], a
.skip_up
	ld a, [wMoveScreenOffset]
	ld b, a
	ld a, [wMoveScreenNumMoves]
	sub b
	sub 5
	jr c, .skip_down
	hlcoord 18, 10
	ld a, "▼"
	ld [hl], a
.skip_down
	jp PlaceMoveData

PlaceMoveData:
	ld a, [wMoveSwapBuffer]
	and a
	jr z, .not_swapping
	call InitVariableWidthText
	hlcoord 1, 14
	ld de, String_MoveSwap
	call PlaceString
	ld a, $1
	ldh [hBGMapMode], a
	ret

.not_swapping
	xor a
	ldh [hBGMapMode], a
	ld a, $ff
	ld [wVariableWidthTextTile], a
	hlcoord 10, 12
	ld de, String_PowAcc
	call PlaceString
	VWTextStart $d7
	ld a, [wCurMove]
	ld c, a
	ld a, [wCurMoveHigh]
	ld b, a
	dec bc
	ld hl, Moves + MOVE_CATEGORY
	ld a, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	ld b, a
	push bc
	ld hl, CategoryIconGFX
	ld bc, 2 tiles
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, VTiles2 tile $59
	lb bc, BANK(CategoryIconGFX), 2
	call Request2bpp
	hlcoord 1, 12
	ld [hl], $59
	inc hl
	ld [hl], $5a

	ld a, [wCurMove]
	ld c, a
	ld a, [wCurMoveHigh]
	ld b, a
	dec bc
	ld hl, Moves + MOVE_TYPE
	ld a, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop bc
	ld c, a
	ld de, wUnknBGPals palette 0 + 2
	push af
	farcall LoadCategoryAndTypePals
	call SetPalettes

	pop af
	ld hl, TypeIconGFX
	ld bc, 4 * LEN_1BPP_TILE
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, VTiles2 tile $5b
	lb bc, BANK(TypeIconGFX), 4
	call Request1bpp
	hlcoord 3, 12
	ld [hl], $5b
	inc hl
	ld [hl], $5c
	inc hl
	ld [hl], $5d
	inc hl
	ld [hl], $5e

	ld a, [wCurMove]
	ld c, a
	ld a, [wCurMoveHigh]
	ld b, a
	dec bc
	ld hl, Moves + MOVE_POWER
	ld a, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	hlcoord 10, 12
	cp 2
	jr c, .no_power
	ld [wd265], a
	ld de, wd265
	lb bc, 1, 3
	predef PrintNum
	jr .place_accuracy
.no_power
	ld de, String_na
	call PlaceString

.place_accuracy
	ld a, [wCurMove]
	ld c, a
	ld a, [wCurMoveHigh]
	ld b, a
	dec bc
	ld hl, Moves + MOVE_ACC
	ld a, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	ldh [hMultiplicand], a
	ld a, 100
	ldh [hMultiplier], a
	call Multiply
	ldh a, [hProduct]
	; don't increase a for 0% moves
	and a
	jr z, .no_inc
	inc a
.no_inc
	hlcoord 15, 12
	cp 2
	jr c, .no_acc
	ld [wd265], a
	ld de, wd265
	lb bc, 1, 3
	predef PrintNum
	jr .description
.no_acc
	ld de, String_na
	call PlaceString

.description
	hlcoord 1, 14
	predef PrintMoveDesc
	ld a, $1
	ldh [hBGMapMode], a
	ret
; 132ba

String_na: ; 132cf
	db "---@"

String_PowAcc:
	db "   <BOLDP>/   %@"

Text_CantForgetHM:
; HM moves can't be forgotten now.
	text_jump UnknownText_0x1c5772
	db "@"

SetFollower::
	;break
	ld a, [wCurPartyMon]
	inc a
	ld b, a
	jr SaveFollower

StopFollower::
	xor a
	ld b, a
; fallthrough
SaveFollower:
	ld a, [wFollowerStatus]
	and ~FOLLOWER_MASK
	or b
	ld [wFollowerStatus], a
	ld a, MONSUBMENU_RELOAD
	ret
