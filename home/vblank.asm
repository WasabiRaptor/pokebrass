; VBlank is the interrupt responsible for updating VRAM.

; In Pokemon Crystal, VBlank has been hijacked to act as the
; main loop. After time-sensitive graphics operations have been
; performed, joypad input and sound functions are executed.

; This prevents the display and audio output from lagging.


VBlank::
	push af
	push bc
	push de
	push hl

	ldh a, [hBuffer]
	push af

	ldh a, [hROMBank]
	ldh [hROMBankBackup], a

	ldh a, [hHighRomBank]
	ldh [hHighROMBankBackup], a

	xor a
	ld [HighMBC5RomBank], a
	ldh [hHighRomBank], a


	ldh a, [hVBlank]
	cp 7
	jr z, .skipToGameTime
	and 7
	add a
	ld e, a
	ld d, 0
	ld hl, .VBlanks
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	call _hl_

.doGameTime
	call GameTimer

	ld hl, wVBlankOccurred
	ld a, [hl]
	and a
	ld [hl], 0
	jr nz, .noVBlankLeak
	ld a, $ff
	ldh [hDelayFrameLY], a
.noVBlankLeak

	pop af
	ldh [hBuffer], a

	ldh a, [hROMBankBackup]
	rst Bankswitch

	ldh a, [hHighROMBankBackup]
	ldh [hHighRomBank], a
	ld [HighMBC5RomBank], a

	pop hl
	pop de
	pop bc
	pop af
	reti

.skipToGameTime
; didn't we just back these up a few instructions ago?
	;ldh a, [hROMBank]
	;ldh [hROMBankBackup], a
	;ldh a, [hHighRomBank]
	;ldh [hHighROMBankBackup], a

	ldh a, [hRunPicAnim]
	and a
	jr z, .tryDoMapAnims
	dec a
	jr z, .doPokeAnim
	dec a
	jr z, .doGrowlOrRoarAnim
.tryDoMapAnims
	call AnimateTileset
	jr .doGameTime
.doGrowlOrRoarAnim
	ldh a, [rSVBK]
	push af
	ld a, $5 ;GBC video
	ldh [rSVBK], a

	call ForcePushOAM

	ld a, BANK(CopyGrowlOrRoarPals)
	rst Bankswitch

	ldh a, [hCGBPalUpdate]
	and a
	call nz, CopyGrowlOrRoarPals
	call RunOneFrameOfGrowlOrRoarAnim
	pop af
	ldh [rSVBK], a
	jr .doGameTime

.doPokeAnim
	call TransferAnimatingPicDuringHBlank
	ld a, BANK(SetUpPokeAnim)
	rst Bankswitch
	call SetUpPokeAnim
	jr .doGameTime

.VBlanks:
	dw VBlank0
	dw VBlank1
	dw VBlank2
	dw VBlank1
	dw VBlank1
	dw VBlank5
	dw VBlank6
	dw VBlank7


VBlank0::
; normal operation

; rng
; scx, scy, wy, wx
; bg map buffer
; palettes
; dma transfer
; bg map
; tiles
; oam
; joypad
; sound

	ldh a, [hSCX]
	ldh [rSCX], a
	ldh a, [hSCY]
	ldh [rSCY], a
	ldh a, [hWY]
	ldh [rWY], a
	ldh a, [hWX]
	ldh [rWX], a

	; There's only time to call one of these in one vblank.
	; Calls are in order of priority.

	call UpdateBGMapBuffer
	jr c, .done
	call UpdateCGBPals
	jr c, .done
	call DMATransfer
	jr c, .done
	call UpdateBGMap

	; These have their own timing checks.

	call Serve2bppRequest
	call Serve1bppRequest
	call AnimateTileset

.done

	call PushOAM
	; vblank-sensitive operations are done

	; inc frame counter
	ld hl, hVBlankCounter
	inc [hl]

	; advance random variables
	call UpdateDividerCounters
	call AdvanceRNGState

	ld a, [wOverworldDelay]
	and a
	jr z, .noDelay
	dec a
	ld [wOverworldDelay], a
.noDelay

	ld a, [wTextDelayFrames]
	and a
	jr z, .noDelay2
	dec a
	ld [wTextDelayFrames], a
.noDelay2
	call Joypad

	ldh a, [hSeconds]
	ldh [hSecondsBackup], a
	; fallthrough

VBlankUpdateSound::
; sound only
	ld a, BANK(_UpdateSound)
	rst Bankswitch
	jp _UpdateSound

VBlank2::
	jr VBlankUpdateSound

VBlank6::
; palettes
; tiles
; dma transfer
; sound
	; inc frame counter
	ld hl, hVBlankCounter
	inc [hl]

	call UpdateCGBPals
	jr c, VBlankUpdateSound

	call Serve2bppRequest
	call Serve1bppRequest
	call DMATransfer
	jr VBlankUpdateSound

VBlank1::
; scx, scy
; palettes
; bg map
; tiles
; oam
; sound / lcd stat
	ldh a, [hSCX]
	ldh [rSCX], a
	ldh a, [hSCY]
	ldh [rSCY], a

	call UpdateCGBPals
	jr c, VBlank1EntryPoint

	call UpdateBGMap
	call Serve2bppRequest
	call LYOverrideStackCopy
VBlank1EntryPoint:
	call PushOAM

	; get requested ints
	ldh a, [rIE]
	push af
	ldh a, [rIF]
	push af
	xor a
	ldh [rIF], a
	ld a, 1 << LCD_STAT
	ldh [rIE], a
	ldh [rIF], a

	ei
	call VBlankUpdateSound
	di

	; get requested ints
	ldh a, [rIF]
	ld b, a
	; discard requested ints
	pop af
	or b
	ld b, a
	xor a
	ldh [rIF], a
	; enable ints besides joypad
	pop af
	ldh [rIE], a
	; rerequest ints
	ld a, b
	ldh [rIF], a
	ret

VBlank7::
; special vblank routine
; copies tilemap in one frame without any tearing
; also updates oam, and pals if specified
	ld a, BANK(VBlankSafeCopyTilemapAtOnce)
	rst Bankswitch
	jp VBlankSafeCopyTilemapAtOnce

VBlank5::
; scx
; palettes
; bg map
; tiles
; joypad
; sound
	ldh a, [hSCX]
	ldh [rSCX], a

	call UpdateCGBPals
	jr c, .done

	call UpdateBGMap
	call Serve2bppRequest
.done
	call Joypad

	xor a
	ldh [rIF], a
	ldh a, [rIE]
	push af
	ld a, 1 << LCD_STAT ; lcd stat
	ldh [rIE], a
	; request lcd stat
	ldh [rIF], a

	ei
	call VBlankUpdateSound
	di

	xor a
	ldh [rIF], a
	; enable ints besides joypad
	pop af
	ldh [rIE], a
	ret
