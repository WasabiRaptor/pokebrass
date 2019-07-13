INCLUDE "data/pokemon/kanto_menu_icon_pals.asm"
INCLUDE "data/pokemon/johto_menu_icon_pals.asm"
INCLUDE "data/pokemon/hoenn_menu_icon_pals.asm"

LoadOverworldMonIcon: ; 8e82b
	ld a, e
	ld [wCurIcon], a
	jp GetRelevantIconPointersAndBank

; 8e83f

SetMenuMonIconColor:
	push hl
	push de
	push bc
	push af

	ld a, [wd265]
	ld [wCurPartySpecies], a
	call GetMenuMonIconPalette
	jr ProcessMenuMonIconColor

SetMenuMonIconColor_NoShiny:
	push hl
	push de
	push bc
	push af

	ld a, [wd265]
	ld [wCurPartySpecies], a
	and a
	call GetMenuMonIconPalette.got_shininess
	jr ProcessMenuMonIconColor

LoadFlyMonColor:
	push hl
	push de
	push bc
	push af
	ld a, MON_GROUP_SPECIES_AND_FORM
	call GetPartyParamLocation
	ld a, MON_SHINY
	call GetPartyParamLocation
	call GetMenuMonIconPalette
	jp ProcessMenuMonIconColor

LoadPartyMenuMonIconColors:
	push hl
	push de
	push bc
	push af

	ld a, [wPartyCount]
	sub c
	ld [wCurPartyMon], a

	ld d, 0
	ld e, a

	ld hl, wPartyMon1Item
	call GetPartyLocation
	ld a, [hl]
	ld [wCurIconMonHasItemOrMail], a

	ld a, MON_GROUP_SPECIES_AND_FORM
	call GetPartyParamLocation
	
	ld a, MON_SHINY
	call GetPartyParamLocation
	call GetMenuMonIconPalette
	push af

	ld hl, wSprites + 3
	ld a, [wCurPartyMon]
	swap a

	ld d, 0
	ld e, a

	add hl, de
	pop af

	ld de, 4
	ld [hl], a
	add hl, de
	ld [hl], a
	add hl, de
	push hl
	add hl, de
	ld [hl], a
	pop hl
	ld d, a
	ld a, [wCurIconMonHasItemOrMail]
	and a
	ld a, PAL_OW_RED ; same color for item or mail
	jr nz, .ok
	ld a, d
.ok
	ld [hl], a
	jr ProcessMenuMonIconColor.finish

ProcessMenuMonIconColor:
	ld hl, wSprites + 3
	ld c, 4
	ld de, 4

.colorIcon
	ld [hl], a
	add hl, de
	dec c
	jr nz, .colorIcon

.finish
	pop af
	pop bc
	pop de
	pop hl
	ret

GetMonIconPalette::
	push af
	ld a, [wCurIcon]
	and a
	jr GetMenuMonIconPalette.got_species

GetMenuMonIconPalette::
; check shininess at hl
	ld a, [hl]
	and SHINY_MASK
	jr z, .not_shiny
	scf
	jr .got_shininess
.not_shiny
	and a
.got_shininess:
	push af
	;inc hl ;byte after shiny is form
	;call GetPartyMonGroupSpeciesAndForm
.got_species:
	call GetRelevantMonIconColors
	ld a, [wCurPartySpecies]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld e, [hl]
	pop af
	ld a, e
	jr c, .shiny
	swap a
.shiny
	and $f
.done
	ld l, a
	ret

LoadPartyMenuMonIcon:
	call LoadPartyMenuMonIconColors
	push hl
	push de
	push bc

	call InitPartyMenuIcon
	call .SpawnItemIcon
	call SetPartyMonIconAnimSpeed

	pop bc
	pop de
	pop hl
	ret

.SpawnItemIcon: ; 8e8df (23:68df)
	ldh a, [hObjectStructIndexBuffer]
	ld hl, wPartyMon1Item
	call GetPartyLocation
	ld a, [hl]
	and a
	ret z
	ld d, a
	ld a, SPRITE_ANIM_FRAMESET_PARTY_MON_WITH_ITEM
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
	ret

LoadNamingScreenMonIcon:
	push hl
	push de
	push bc

	ld hl, wTempMonShiny
	call SetMenuMonIconColor

	ld a, [wd265]
	ld [wCurIcon], a
	xor a
	call GetIconGFX
	depixel 4, 4, 4, 0
	ld a, SPRITE_ANIM_INDEX_PARTY_MON
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_SEQ_NULL

	pop bc
	pop de
	pop hl
	ret

LoadMoveMenuMonIcon:
	push hl
	push de
	push bc

	ld a, MON_SHINY
	call GetPartyParamLocation
	call SetMenuMonIconColor

	ld a, [wd265]
	ld [wCurIcon], a
	xor a
	call GetIconGFX
	depixel 3, 4, 2, 4
	ld a, SPRITE_ANIM_INDEX_PARTY_MON
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_SEQ_NULL

	pop bc
	pop de
	pop hl
	ret

LoadTradeAnimationMonIcon:
	push hl
	push de
	push bc

	call SetMenuMonIconColor_NoShiny

	ld a, [wd265]
	ld [wCurIcon], a
	ld a, $62
	ld [wCurIconTile], a
	call GetMemIconGFX

	pop bc
	pop de
	pop hl
	ret

InitPartyMenuIcon: ; 8e908 (23:6908)
	ld a, [wCurIconTile]
	push af
	ldh a, [hObjectStructIndexBuffer]
	ld hl, wPartySpecies
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	ld [wCurIcon], a
	call GetMemIconGFX
	ldh a, [hObjectStructIndexBuffer]
; y coord
rept 4
	add a
endr
	add $1c
	ld d, a
; x coord
	ld e, $10
; type is partymon icon
	ld a, SPRITE_ANIM_INDEX_PARTY_MON
	call InitSpriteAnimStruct
	pop af
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], a
	ret

SetPartyMonIconAnimSpeed: ; 8e936 (23:6936)
	push bc
	ldh a, [hObjectStructIndexBuffer]
	ld b, a
	call .getspeed
	ld a, b
	pop bc
	ld hl, SPRITEANIMSTRUCT_DURATIONOFFSET
	add hl, bc
	ld [hl], a
	rlca
	rlca
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld [hl], a
	ret

.getspeed ; 8e94c (23:694c)
	farcall PlacePartymonHPBar
	call GetHPPal
	ld e, d
	ld d, 0
	ld hl, .speeds
	add hl, de
	ld b, [hl]
	ret
; 8e95e (23:695e)

.speeds ; 8e95e
	db $00, $40, $80
; 8e961

PokegearFlyMap_GetMonIcon: ; 8e9ac
; Load species icon into VRAM at tile a
	push de
	ld a, [wd265]
	ld [wCurIcon], a
	pop de
	ld a, e
	jp GetIconGFX
; 8e9bc

FlyFunction_GetMonIcon: ; 8e9bc (23:69bc)
	push de
	ld a, [wd265]
	ld [wCurIcon], a
	pop de
	ld a, e
	jp GetIcon_a
; 8e9cc (23:69cc)

GetMemIconGFX: ; 8e9db (23:69db)
	ld a, [wCurIconTile]
GetIconGFX: ; 8e9de
	call GetIcon_a
	ld de, $80 ; 8 tiles
	add hl, de
	ld de, HeldItemIcons
	lb bc, BANK(HeldItemIcons), 2
	call Request2bpp
	ld a, [wCurIconTile]
	add 10
	ld [wCurIconTile], a
	ret

HeldItemIcons:
INCBIN "gfx/icons/mail.2bpp"
INCBIN "gfx/icons/item.2bpp"
; 8ea17

GetIcon_a: ; 8ea1b
; Load icon graphics into VRAM starting from tile a.
	ld l, a
	ld h, 0

GetIcon: ; 8ea1e
; Load icon graphics into VRAM starting from tile hl.

; One tile is 16 bytes long.
rept 4
	add hl, hl
endr

	ld de, VTiles0
	add hl, de
	push hl
	push hl
; The icons are contiguous, in order and of the same
; size, so the pointer table is somewhat redundant.
	call GetRelevantIconPointersAndBank
	pop hl
	call Request2bpp
	pop hl
	ret
; 8ea3f

; Extended icon bank routine by com3tiin
; http://www.pokecommunity.com/showthread.php?t=338470
;GetMonIconBank:
;	ld a, [wCurIcon]
;	cp AZUMARILL ; first mon in Icons2
;	lb bc, BANK(Icons1), 8
;	ret c
;	lb bc, BANK(Icons2), 8
;	ret

FreezeMonIcons: ; 8ea4a
	ld hl, wSpriteAnimationStructs
	ld e, PARTY_LENGTH
	ld a, [wMenuCursorY]
	ld d, a
.loop
	ld a, [hl]
	and a
	jr z, .next
	cp d
	jr z, .loadwithtwo
	ld a, SPRITE_ANIM_SEQ_NULL
	jr .ok

.loadwithtwo
	ld a, SPRITE_ANIM_SEQ_PARTY_MON_SWITCH

.ok
	push hl
	ld c, l
	ld b, h
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], a
	pop hl

.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ret
; 8ea71

UnfreezeMonIcons: ; 8ea71
	ld hl, wSpriteAnimationStructs
	ld e, PARTY_LENGTH
.loop
	ld a, [hl]
	and a
	jr z, .next
	push hl
	ld c, l
	ld b, h
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_SEQ_PARTY_MON
	pop hl
.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ret
; 8ea8c (23:6a8c)

HoldSwitchmonIcon: ; 8ea8c
	ld hl, wSpriteAnimationStructs
	ld e, PARTY_LENGTH
	ld a, [wSwitchMon]
	ld d, a
.loop
	ld a, [hl]
	and a
	jr z, .next
	cp d
	jr z, .is_switchmon
	ld a, SPRITE_ANIM_SEQ_PARTY_MON_SELECTED
	jr .join_back

.is_switchmon
	ld a, SPRITE_ANIM_SEQ_PARTY_MON_SWITCH
.join_back
	push hl
	ld c, l
	ld b, h
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], a
	pop hl
.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ret

GetRelevantIconPointersAndBank:
; given species in wCurIcon, return *IconPointers in hl and BANK(*Icon) in b
; returns c for variants, nc for normal species
	ld a, [wCurGroup]
	ld hl, VariantIconPointerTable
	ld de, 3
	call IsInArray
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [wCurIcon]
	dec a
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	add hl, de
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld e, a
	ld d, [hl]
;get the bank
	ld c, 8
	ret

INCLUDE "data/pokemon/variant_menu_icon_pointer_table.asm"

GetRelevantMonIconColors:
	ld a, [wCurGroup]
; given species in a, return *PicPointers in hl 
; returns c for variants, nc for normal species
	ld hl, VariantIconPalTable
	ld de, 4
	call IsInArray
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
INCLUDE "data/pokemon/variant_menu_icon_pal_table.asm"