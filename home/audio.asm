; Audio interfaces.

MapSetup_Sound_Off:: ; 3b4e

	push hl
	push de
	push bc
	push af

	ldh a, [hROMBank]
	push af
	ld a, BANK(_MapSetup_Sound_Off)
	rst Bankswitch

	call _MapSetup_Sound_Off

	pop af
	rst Bankswitch

	pop af
	pop bc
	pop de
	pop hl
	ret
; 3b6a


UpdateSound:: ; 3b6a

	push hl
	push de
	push bc
	push af

	ldh a, [hROMBank]
	push af
	ld a, BANK(_UpdateSound)
	rst Bankswitch

	call _UpdateSound

	pop af
	rst Bankswitch

	pop af
	pop bc
	pop de
	pop hl
	ret
; 3b86


_LoadMusicByte:: ; 3b86
; wCurMusicByte = [a:de]
EXPORT LoadMusicByte

	rst Bankswitch

	ld a, [de]
	ld [wCurMusicByte], a
	ld a, BANK(LoadMusicByte)

	rst Bankswitch
	ret
; 3b97


PlayMusicAfterDelay::
	push de
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	pop de
	ld a, e
	ld [wMapMusic], a
PlayMusic:: ; 3b97
; Play music de.

	push hl
	push de
	push bc
	push af

	ldh a, [hROMBank]
	push af
	ld a, BANK(_PlayMusic) ; and BANK(_MapSetup_Sound_Off)
	rst Bankswitch

	ld a, e
	and a
	jr z, .nomusic

	call _PlayMusic
	jr .end

.nomusic
	call _MapSetup_Sound_Off

.end
	pop af
	rst Bankswitch
	pop af
	pop bc
	pop de
	pop hl
	ret
; 3bbc


PlayMusic2:: ; 3bbc
; Stop playing music, then play music de.

	push hl
	push de
	push bc
	push af

	ldh a, [hROMBank]
	push af
	ld a, BANK(_PlayMusic)
	rst Bankswitch

	push de
	ld de, MUSIC_NONE
	call _PlayMusic
	call DelayFrame
	pop de
	call _PlayMusic

	pop af
	rst Bankswitch

	pop af
	pop bc
	pop de
	pop hl
	ret

; 3be3


PlayCryHeader:: ; 3be3
; Play cry header at d:hl.
	anonbankpush KantoCries
	ld a, d
	rst Bankswitch

PlayCryHeader_BankPush:
	ld a, [hli]
	cp $ff
	jr z, .ded
	ld e, a
	ld d, 0

	ld a, [hli]
	ld [wCryPitch], a
	ld a, [hli]
	ld [wCryPitch + 1], a
	ld a, [hli]
	ld [wCryLength], a
	ld a, [hl]
	ld [wCryLength + 1], a

	ld a, BANK(_PlayCryHeader)
	rst Bankswitch
	jp _PlayCryHeader

.ded
	ld e, 0
	call LoadDEDCryHeader
	jp PlayDEDCry

; 3c23

GetRelevantCryPointers::
	ld a, [wCurGroup]
; return *Cries in hl and BANK(*Cries) in d
; returns c for variants, nc for normal species
	ld hl, RegionalCryTable
		ld de, 3
	call IsInArray
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a


	ld a, [wCurSpecies]
	ld de, 4
	call IsInArray
	inc hl
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCurForm]
	ret c
	ld a, [wCurSpecies]
	dec a
	ret

INCLUDE "data/pokemon/variant_cry_table.asm"

WaitPlaySFX::
	call WaitSFX
	; fallthrough
PlaySFX:: ; 3c23
; Play sound effect de.
; Sound effects are ordered by priority (highest to lowest)

	push hl
	push de
	push bc
	push af

	; Is something already playing?
	call CheckSFX
	jr nc, .play

	; Does it have priority?
	ld a, [wCurSFX]
	cp e
	jr c, .done

.play
	ldh a, [hROMBank]
	push af
	ld a, BANK(_PlaySFX)
	rst Bankswitch

	ld a, e
	ld [wCurSFX], a
	call _PlaySFX

	pop af
	rst Bankswitch

.done
	pop af
	pop bc
	pop de
	pop hl
	ret
; 3c4e


WaitSFX:: ; 3c55
; infinite loop until sfx is done playing

	push hl
	jr .handleLoop
.wait
	call DelayFrame
.handleLoop
	ld hl, wChannel5Flags
	bit 0, [hl]
	jr nz, .wait
	ld hl, wChannel6Flags
	bit 0, [hl]
	jr nz, .wait
	ld hl, wChannel7Flags
	bit 0, [hl]
	jr nz, .wait
	ld hl, wChannel8Flags
	bit 0, [hl]
	jr nz, .wait

	pop hl
	ret
; 3c74

IsSFXPlaying:: ; 3c74
; Return carry if no sound effect is playing.
; The inverse of CheckSFX.
	push hl

	ld hl, wChannel5Flags
	bit 0, [hl]
	jr nz, .playing
	ld hl, wChannel6Flags
	bit 0, [hl]
	jr nz, .playing
	ld hl, wChannel7Flags
	bit 0, [hl]
	jr nz, .playing
	ld hl, wChannel8Flags
	bit 0, [hl]
	jr nz, .playing

	pop hl
	scf
	ret

.playing
	pop hl
	and a
	ret
; 3c97

MaxVolume:: ; 3c97
	ld a, $77 ; max
	ld [wVolume], a
	ret
; 3c9d

LowVolume:: ; 3c9d
	ld a, $33 ; 40%
	ld [wVolume], a
	ret
; 3ca3

VolumeOff:: ; 3ca3
	xor a
	ld [wVolume], a
	ret
; 3ca8

FadeInMusic:: ; 3cae
	ld a, 4 | 1 << 7
	ld [wMusicFade], a
	ret
; 3cb4

SkipMusic::
; Skip a frames of music.
	ldh [hBuffer], a
	ld a, [wMusicPlaying]
	push af
	xor a
	ld [wMusicPlaying], a
	ldh a, [hBuffer]
.loop
	call UpdateSound
	dec a
	jr nz, .loop
	pop af
	ld [wMusicPlaying], a
	ret

FadeToMapMusic:: ; 3cbc
	push hl
	push de
	push bc
	push af

	call GetMapMusic
	ld a, [wMapMusic]
	cp e
	jr z, .done

	ld a, 8
	ld [wMusicFade], a
	ld a, e
	ld [wMusicFadeIDLo], a
	ld a, d
	ld [wMusicFadeIDHi], a
	ld a, e
	ld [wMapMusic], a

.done
	pop af
	pop bc
	pop de
	pop hl
	ret
; 3cdf

PlayMapMusic:: ; 3cdf
	push hl
	push de
	push bc
	push af

	call GetMapMusic
	ld a, [wMapMusic]
	cp e
	call nz, PlayMusicAfterDelay

	pop af
	pop bc
	pop de
	pop hl
	ret
; 3d03

EnterMapMusic:: ; 3d03
	push hl
	push de
	push bc
	push af

	xor a
	ld [wDontPlayMapMusicOnReload], a
	call GetMapMusic
	call PlayMusicAfterDelay

	pop af
	pop bc
	pop de
	pop hl
	ret
; 3d2f

TryRestartMapMusic:: ; 3d2f
	ld a, [wDontPlayMapMusicOnReload]
	and a
	jp z, RestoreMusic
	xor a
	ld [wMapMusic], a
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	xor a
	ld [wDontPlayMapMusicOnReload], a
	ret
; 3d47

RestartMapMusic:: ; 3d47
	push hl
	push de
	push bc
	push af
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	ld a, [wMapMusic]
	ld e, a
	ld d, 0
	call PlayMusic
	pop af
	pop bc
	pop de
	pop hl
	ret
; 3d62

GetMapMusic::
	ld hl, SpecialMusicMaps
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
.loop:
	ld a, [hli]
	and a
	jr z, GetPlayerStateMusic
	cp b
	jr nz, .wrong_group
	ld a, [hli]
	cp c
	jr nz, .wrong_map
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.wrong_group:
	inc hl
.wrong_map:
	inc hl
	inc hl
	jr .loop

GetCyclingRoadMusic:
	ld de, MUSIC_BICYCLE_XY
	ld a, [wPlayerState]
	cp PLAYER_BIKE
	ret z
	jr GetPlayerStateMusic

GetBugCatchingContestMusic:
	ld de, MUSIC_BUG_CATCHING_CONTEST_RANKING
	ld a, [wStatusFlags2]
	bit 2, a ; ENGINE_BUG_CONTEST_TIMER
	ret nz
	; fallthrough

GetPlayerStateMusic:
	ld a, [wPlayerState]
	cp PLAYER_BIKE
	jr z, .bike
	cp PLAYER_SURF
	jr z, .surf
	cp PLAYER_SURF_PIKA
	jr z, .surf_pikachu
	jp GetMapHeaderMusic

.bike:
	call RegionCheck
	ld a, e
	ld de, MUSIC_BICYCLE_RB
	cp KANTO_REGION
	ret z
;	ld de, MUSIC_BICYCLE_RSE
;	cp ORANGE_REGION
;	ret z
	ld de, MUSIC_BICYCLE
	ret

.surf:
	call RegionCheck
	ld a, e
	ld de, MUSIC_SURF_KANTO
	cp KANTO_REGION
	ret z
	ld de, MUSIC_SURF_HOENN
	cp ORANGE_REGION
	ret z
	ld de, MUSIC_SURF
	ret

.surf_pikachu:
	ld de, MUSIC_SURFING_PIKACHU
	ret

SpecialMusicMaps:
music_map: MACRO
	map_id \1
	dw \2
ENDM
	;music_map ROUTE_23, GetMapHeaderMusic
	db 0 ; end

CheckSFX:: ; 3dde
; Return carry if any SFX channels are active.
	ld a, [wChannel5Flags]
	bit 0, a
	jr nz, .playing
	ld a, [wChannel6Flags]
	bit 0, a
	jr nz, .playing
	ld a, [wChannel7Flags]
	bit 0, a
	jr nz, .playing
	ld a, [wChannel8Flags]
	bit 0, a
	jr nz, .playing
	and a
	ret
.playing
	scf
	ret
; 3dfe

TerminateExpBarSound:: ; 3dfe
	xor a
	ld [wChannel5Flags], a
	ld [wSoundInput], a
	ldh [rNR10], a
	ldh [rNR11], a
	ldh [rNR12], a
	ldh [rNR13], a
	ldh [rNR14], a
	ret
; 3e10


ChannelsOff:: ; 3e10
; Quickly turn off music channels
	xor a
	ld [wChannel1Flags], a
	ld [wChannel2Flags], a
	ld [wChannel3Flags], a
	ld [wChannel4Flags], a
	ld [wSoundInput], a
	ret
; 3e21

SFXChannelsOff:: ; 3e21
; Quickly turn off sound effect channels
	xor a
	ld [wChannel5Flags], a
	ld [wChannel6Flags], a
	ld [wChannel7Flags], a
	ld [wChannel8Flags], a
	ld [wSoundInput], a
	ret
; 3e32
