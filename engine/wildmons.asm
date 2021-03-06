; TODO:
;   Arg 4 (Shiny override [1] | Ability override [2] | Form override [5])
;   Arg 5 (AI)
;   Arg 6 (Item)


LoadWildMonData: ; 29ff8
	call _GrassWildmonLookup
	jr c, .copy ;if it found a map with a wild table it will copy the encounter rates for the time of day
	ld hl, wMornEncounterRate
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	jr .done_copy

.copy
	inc hl
	inc hl;move past the two bytes of the map ID
	; Copy level minimum and maximum into WRAM
	ld de, wMinimumLevel
	ld bc, 2
	rst CopyBytes
	ld a, [hl]
	and MORN_ENCOUNTER_MASK
	ld b, 6
	call .shiftLoop
	call .checkEncounterRate
	ld [wMornEncounterRate], a
	ld a, [hl]
	and DAY_ENCOUNTER_MASK
	ld b, 4
	call .shiftLoop
	call .checkEncounterRate
	ld [wDayEncounterRate], a
	ld a, [hl]
	and DUSK_ENCOUNTER_MASK
	ld b, 2
	call .shiftLoop
	call .checkEncounterRate
	ld [wDuskEncounterRate], a
	ld a, [hl]
	and NIGHT_ENCOUNTER_MASK
	call .checkEncounterRate
	ld [wNightEncounterRate], a
.done_copy
	call _WaterWildmonLookup
	ld a, 0 ; not xor a; preserve carry flag
	jr nc, .no_copy
	inc hl
	inc hl
	; Copy level minimum and maximum into WRAM
	ld de, wMinimumLevel
	ld bc, 2
	rst CopyBytes
	ld a, [hl]
.no_copy
	ld [wWaterEncounterRate], a
	ret

.shiftLoop
	sla a
	dec b
	jr nz, .shiftLoop
	ret

.checkEncounterRate
	cp COMMON
	jr nz, .not_common
	ld a, COMMON_RATE
	ret
.not_common
	cp UNCOMMON
	jr nz, .not_uncommon
	ld a, UNCOMMON_RATE
	ret
.not_uncommon
	cp RARE
	jr nz, .not_rare
	ld a, RARE_RATE
	ret
.not_rare
	cp VERY_RARE
	jr nz, .error_rate
	ld a, VERY_RARE_RATE
	ret
.error_rate
	ld a, $ff
	ret

FindNest: ; 2a01f
; Parameters:
; e: 0 = Invar, 1 = Kanto, 2 = Orange
; wNamedObjectIndexBuffer: species
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	ld a, e
	decoord 0, 0

;here it is getting the region table to load not *very* important, but just mainly which data table it is loading into hl and ending up looking at, easily swapped out
	ld hl, InvarGrassWildMons
	call .FindGrass
; it calls find grass or find water because they are indeed structured differently, as I don't believe water mons take time of day into account in the current form
	ld hl, InvarWaterWildMons
	call .FindWater
	call .RoamMon1
	call .RoamMon2
	jp .RoamMon3

.FindGrass: ; 2a052
	ld a, [hl]
	cp -1
	ret z
	push hl

	; assume that navel rock is the first off-screen map, and end the search early
	;first two bytes are the map ID
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push bc
; next for bytes are the percentages for the time of day, skip them for now
	ld bc, WILD_GRASS_SIZE - 1
	add hl, bc
	pop bc
	;7 grass mons per time of day, and 4 times of day
	ld a, NUM_GRASSMON * 4
	call .SearchMapForMon
	jr nc, .next_grass
	ld [de], a
	inc de

.next_grass ;on to the next map I believe this might actually be broken because I don't think I truly verified that GRASS_WILDDATA_LENGTH matched right since it was always getting the first group available
	pop hl
	ld bc, GRASS_WILDDATA_LENGTH
	add hl, bc
	jr .FindGrass
; 2a06e
; never tested water
.FindWater: ; 2a06e
	ld a, [hl]
	cp -1
	ret z
	push hl
	;check mapgroup
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	;only one percentage due to water not caring about time of day
	inc hl
	ld a, 3
	call .SearchMapForMon
	jr nc, .next_water
	ld [de], a
	inc de

.next_water
	pop hl
	ld bc, 3 * 3
	add hl, bc
	jr .FindWater
; 2a088

.SearchMapForMon: ; 2a088
	inc hl
.ScanMapLoop:
	push af
	ld a, [wNamedObjectIndexBuffer]
	cp [hl]
	inc hl
	jr z, .found
.notfound
	ld bc, WILD_POKE_SIZE
	add hl, bc
	pop af
	dec a
	jr nz, .ScanMapLoop
	and a
	ret

.found
	ld a, [wCurGroup]
	cp [hl]
	jp nz, .notfound
	pop af
	; fallthrough

.AppendNest: ; 2a09c
	push de
	call GetWorldMapLocation
	ld c, a
	hlcoord 0, 0
	ld de, SCREEN_WIDTH * SCREEN_HEIGHT
.AppendNestLoop:
	ld a, [hli]
	cp c
	jr z, .found_nest
	dec de
	ld a, e
	or d
	jr nz, .AppendNestLoop
	ld a, c
	pop de
	scf
	ret

.found_nest
	pop de
	and a
	ret
; 2a0b7

.RoamMon1: ; 2a0b7
	ld a, [wRoamMon1Species]
	ld b, a
	ld a, [wNamedObjectIndexBuffer]
	cp b
	ret nz
	ld a, [wRoamMon1MapGroup]
	ld b, a
	ld a, [wRoamMon1MapNumber]
	ld c, a
	call .AppendNest
	ret nc
	ld [de], a
	inc de
	ret
; 2a0cf

.RoamMon2: ; 2a0cf
	ld a, [wRoamMon2Species]
	ld b, a
	ld a, [wNamedObjectIndexBuffer]
	cp b
	ret nz
	ld a, [wRoamMon2MapGroup]
	ld b, a
	ld a, [wRoamMon2MapNumber]
	ld c, a
	call .AppendNest
	ret nc
	ld [de], a
	inc de
	ret
; 2a0e7

.RoamMon3: ; 2a0cf
	ld a, [wRoamMon3Species]
	ld b, a
	ld a, [wNamedObjectIndexBuffer]
	cp b
	ret nz
	ld a, [wRoamMon3MapGroup]
	ld b, a
	ld a, [wRoamMon3MapNumber]
	ld c, a
	call .AppendNest
	ret nc
	ld [de], a
	inc de
	ret

TryWildEncounter::
; Try to trigger a wild encounter.
	; Do this first, because this affects some abilities messing with encounter rate
	call ChooseWildEncounter
	jr nz, .no_battle
	call .EncounterRate
	jr nc, .no_battle
	call CheckRepelEffect
	jr nc, .no_battle
	xor a
	ret

.no_battle
	xor a ; BATTLETYPE_NORMAL
	ld [wTempWildMonSpecies], a
	ld [wTempWildMonGroup], a
	ld [wBattleType], a
	ld a, 1
	and a
	ret

.EncounterRate:
	call GetMapEncounterRate
	call ApplyMusicEffectOnEncounterRate
	call ApplyCleanseTagEffectOnEncounterRate
	call SetBattlerLevel
	call ApplyAbilityEffectsOnEncounterMon
	call Random
	cp b
	ret

GetMapEncounterRate: ; 2a111
	ld hl, wMornEncounterRate
	;call CheckOnWater
	;ld a, 3
	;jr z, .ok
	ld a, [wTimeOfDay]
.ok
	ld c, a
	ld b, 0
	add hl, bc
	ld b, [hl]
	ret
; 2a124

ApplyMusicEffectOnEncounterRate:: ; 2a124
; Pokemon March and Ruins of Alph signal double encounter rate.
; Pokemon Lullaby halves encounter rate.
	ld a, [wMapMusic]
	cp MUSIC_POKEMON_MARCH
	jr z, .double
	cp MUSIC_RUINS_OF_ALPH_RADIO
	jr z, .double
	cp MUSIC_POKEMON_LULLABY
	ret nz
	srl b
	ret

.double
	sla b
	ret
; 2a138

ApplyCleanseTagEffectOnEncounterRate::
; Cleanse Tag halves encounter rate.
	ld hl, wPartyMon1Item
	ld de, PARTYMON_STRUCT_LENGTH
	ld a, [wPartyCount]
	ld c, a
.loop
	ld a, [hl]
	cp CLEANSE_TAG
	jr z, .cleansetag
	add hl, de
	dec c
	jr nz, .loop
	ret

.cleansetag
	srl b
	ret

SetBattlerLevel:
; Sets c to the level of the first nonfainted mon (to be sent first into wild fights)
	push bc
	ld hl, wPartyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH - 1
.loop
	ld a, [hli]
	or [hl]
	jr nz, .ok
	add hl, bc
	jr .loop

.ok
	pop bc
	; Set hl to level of said mon
rept 4
	dec hl
endr
	ld c, [hl]
	ret

ChooseWildEncounter: ; 2a14f
	ld c, $ff
_ChooseWildEncounter:
	push bc
	call LoadWildMonDataPointer ;get the pointer for the list of pokemon on this map again
	pop bc
	jp nc, .nowildbattle
	;push bc
	;call CheckEncounterRoamMon ; just gonna not worry about that for now
	;pop bc
	;jp c, .startwildbattle

	inc hl
	inc hl
	inc hl
	push bc
	call CheckOnWater
	jr nz, .notWater
	ld bc, WILD_WATER_SIZE - 3
	add hl, bc
	pop bc
	jr .got_table ;water only has one percentage so if so we're done

.notWater
	ld bc, WILD_GRASS_SIZE - 3
	add hl, bc
	pop bc

.got_table
	; Check if we want to force a type
	inc c
	jr .get_random_mon

; TODO - NEEDS TO BE UPDATED
	dec c
	; Check if we can actually encounter a valid species of the given type
	push de	; Probability Table 1
	push hl	; Address? 2
.force_loop
	inc hl ; We don't care about level
	ld a, [hli]
	ld [wCurSpecies], a
	ld a, [hli]
	ld [wCurGroup], a
	push bc	; inA 3
	push hl	; 4
	call GetBaseData
	pop hl	; 4
	pop bc	; 3
	ld a, [wBaseType1]
	cp c
	jr z, .can_force_type
	ld a, [wBaseType2]
	cp c
	jr z, .can_force_type
	;each grassmon is three bytes so lets make sure to dec b three times to make sure everything still lines up
	dec b
	dec b
	dec b
	jr nz, .force_loop
	ld c, $ff
.can_force_type
	inc c
	pop hl	; 2
	pop de	; 1
; END TODO

.get_random_mon
	dec c
	push bc	; Pokemon area size
	ld a, 100
	call RandomRange
	ld c, a
	ld de, WILD_POKE_SIZE
; This next loop chooses which mon to load up.
.prob_bracket_loop
	ld a, [hl]
	inc a
	jp nz, .continue
	pop bc
	jp .nowildbattle

.continue
	dec a
	push af	; 3
	and ENCOUNTER_TIME_MASK
	ld b, a
	ld a, [wTimeOfDay]
	cp DAWN
	jr nz, .notMorn
	bit 7, b
	jr nz, .rightTime
	pop af	; 3
	jp .nextMon

.notMorn
	cp MIDDAY
	jr nz, .notDay
	bit 6, b
	jr nz, .rightTime
	pop af	; 3
	jp .nextMon

.notDay
	cp DUSK
	jr nz, .notDusk
	bit 5, b
	jr nz, .rightTime
	pop af
	jp .nextMon

.notDusk
	bit 4, b
	jr nz, .rightTime
	pop af	; 3
	jp .nextMon

.rightTime
	pop af	; 3

checkpercent: MACRO
	cp WILD_\1P
	jr nz, .not\1
	ld a, c
	sub \1
	jr .doneSubtracting
.not\1
ENDM

	and WILD_PERCENT_MASK
	checkpercent 75
	checkpercent 60
	checkpercent 50
	checkpercent 45
	checkpercent 40
	checkpercent 35
	checkpercent 30
	checkpercent 25
	checkpercent 20
	checkpercent 15
	checkpercent 10
	checkpercent 9
	checkpercent 5
	checkpercent 4
	checkpercent 1
	ld a, c
.doneSubtracting
	ld c, a
	jr nc, .nextMon
	jr .got_it

.nextMon
	add hl, de
	jp .prob_bracket_loop

.got_it
	pop bc ; 2
	inc hl
	ld a, [hli] ; Gets species
	ld [wCurSpecies], a
	ld a, [hli]	; Gets group
	ld [wCurGroup], a
	ld [wTempWildMonGroup], a
	; Check if we're forcing type
	inc c
	jp .loadwildmon

	push bc
	push hl
	call GetBaseData
	pop hl
	pop bc
	ld a, [wBaseType1]
	cp c
	jr z, .loadwildmon
	ld a, [wBaseType2]
	cp c
	jr z, .loadwildmon
	jp .get_random_mon

.loadwildmon
	ld a, [wCurSpecies]	; Make sure Species is in a
	ld [wTempWildMonSpecies], a
	ld a, [hli]	; Gets Level info
	bit 7, a	; Check if Level is offset or override
	jr nz, .levelOverride
	ld b, a
	farcall CalculatePartyAverage
	add b
	ld c, a
	ld a, [wMinimumLevel]
	cp c	; min(avg, minLevel)
	jr nc, .gotLevel
	ld a, [wMaximumLevel]
	cp c	; max(avg, maxLevel)
	jr c, .gotLevel
	ld a, c
	jr .gotLevel

.levelOverride
	and WILD_LVL_MASK
.gotLevel
	ld [wCurPartyLevel], a
	ld a, [hli]	; Get Shiny/Ability/Form
    and FORM_MASK
	ld [wTempWildMonForm], a
	ld a, [hli]	; Get AI
	ld [wTempWildMonAI], a
	ld a, [hli]	; Get Item
	ld [wTempWildMonItem], a
.startwildbattle
	xor a
	ret

.nowildbattle
	ld a, 1
	and a
	ret
; 2a1cb

;INCLUDE "data/wild/probabilities.asm"

CheckRepelEffect::
; If there is no active Repel, there's no need to be here.
	ld a, [wRepelEffect]
	and a
	jr z, .encounter
	call SetBattlerLevel

	ld a, [wCurPartyLevel]
	cp c
.encounter
	ccf
	ret

ApplyAbilityEffectsOnEncounterMon:
; Consider making the abilities more useful in non-faithful
	farcall GetLeadAbility
	ret z
	ld hl, .AbilityEffects
	jp BattleJumptable

.AbilityEffects:
	dbw ARENA_TRAP,   .ArenaTrap    ; double rate
	dbw HUSTLE,       .Hustle       ; high level
	dbw ILLUMINATE,   .Illuminate   ; double rate
	dbw INTIMIDATE,   .Intimidate   ; half low level
	dbw KEEN_EYE,     .KeenEye      ; half low level
	dbw MAGNET_PULL,  .MagnetPull   ; steel
	dbw NO_GUARD,     .NoGuard      ; semi-double rate
	dbw PRESSURE,     .Pressure     ; high level
	dbw QUICK_FEET,   .QuickFeet    ; half rate
	dbw STATIC,       .Static       ; electric
	dbw STENCH,       .Stench       ; half rate
	dbw SWARM,        .Swarm        ; semi-double rate
	dbw VITAL_SPIRIT, .VitalSpirit  ; high level
	dbw -1, -1

.ArenaTrap:
.Illuminate:
.double_encounter_rate
	sla b
	jr .avoid_rate_overflow

.NoGuard:
.Swarm:
.semidouble_encounter_rate
	ld a, b
	srl b
	add b
	ld b, a
.avoid_rate_overflow
	ret nc
	ld b, $ff
	ret

.QuickFeet:
.Stench:
.halve_encounter_rate
	srl b
.avoid_rate_underflow
	ld a, b
	and a
	ret nz
	ld b, 1
	ret

.Hustle:
.Pressure:
.VitalSpirit:
; Vanilla 3gen+: 50% to force upper bound in a level range
; Since we don't have level ranges, 50% to increase level by 1/8 (min 1)
	call Random
	rrca
	ret c
	ld a, c
	cp 100
	ret nc
	inc c
	ret

.Intimidate:
.KeenEye:
; Halve encounter rate if enemy is 5+ levels below leading nonfainted mon
	ld a, [wCurPartyLevel]
	add 5
	cp c
	ret nc
	jr .halve_encounter_rate

.MagnetPull:
	push bc
	ld c, STEEL
	jr .force_wildtype
.Static:
	push bc
	ld c, ELECTRIC
.force_wildtype
	; Force type (if we can) 50% of the time
	call Random
	and 1
	call z, _ChooseWildEncounter
	pop bc
	ret

LoadWildMonDataPointer: ; 2a200
	call CheckOnWater
	jr z, _WaterWildmonLookup

_GrassWildmonLookup: ; 2a205
	ld hl, SwarmGrassWildMons
	ld bc, GRASS_WILDDATA_LENGTH
	call _SwarmWildmonCheck
	ret c
	call _GetGrassWildmonPointer
	ld bc, GRASS_WILDDATA_LENGTH
	jr _NormalWildmonOK

_WaterWildmonLookup: ; 2a21d
	ld hl, SwarmWaterWildMons
	ld bc, WATER_WILDDATA_LENGTH
	call _SwarmWildmonCheck
	ret c
	call _GetWaterWildmonPointer
	ld bc, WATER_WILDDATA_LENGTH
	jr _NormalWildmonOK

_GetGrassWildmonPointer:
	call RegionCheck
	ld a, e
	ld hl, InvarGrassWildMons
	;and a ; cp INVAR_REGION
	;ret z
	;ld hl, KantoGrassWildMons
	;dec a ; cp KANTO_REGION
	;ret z
	;ld hl, OrangeGrassWildMons
	ret

_GetWaterWildmonPointer:
	call RegionCheck
	ld a, e
	ld hl, InvarWaterWildMons
	;and a ; cp INVAR_REGION
	;ret z
	;ld hl, KantoWaterWildMons
	;dec a ; cp KANTO_REGION
	;ret z
	;ld hl, OrangeWaterWildMons
	ret

_SwarmWildmonCheck:
	call CopyCurrMapDE
	push hl
	ld hl, wSwarmFlags
	bit 2, [hl]
	pop hl
	jr z, .CheckYanma
	ld a, [wDunsparceMapGroup]
	cp d
	jr nz, .CheckYanma
	ld a, [wDunsparceMapNumber]
	cp e
	jr nz, .CheckYanma
	call LookUpWildmonsForMapDE
	jr nc, _NoSwarmWildmon
	scf
	ret

.CheckYanma:
	push hl
	ld hl, wSwarmFlags
	bit 3, [hl]
	pop hl
	jr z, _NoSwarmWildmon
	ld a, [wYanmaMapGroup]
	cp d
	jr nz, _NoSwarmWildmon
	ld a, [wYanmaMapNumber]
	cp e
	jr nz, _NoSwarmWildmon
	call LookUpWildmonsForMapDE
	jr nc, _NoSwarmWildmon
	scf
	ret

_NoSwarmWildmon:
	and a
	ret

_NormalWildmonOK:
	call CopyCurrMapDE
	jr LookUpWildmonsForMapDE
; 2a27f

CopyCurrMapDE: ; 2a27f
	ld a, [wMapGroup]
	ld d, a
	ld a, [wMapNumber]
	ld e, a
	ret
; 2a288

LookUpWildmonsForMapDE: ; 2a288
.loop
	push hl
	ld a, [hl]
	inc a ;checking for $ff for the end list
	jr z, .end ; if its the end of the list no wilds
	ld a, d ;check if the the list its at matches the map id in de
	cp [hl]
	jr nz, .next
	inc hl
	ld a, e
	cp [hl]
	jr z, .match
.next
	pop hl
	ld b, 0
	ld c, WILD_GRASS_SIZE
	add hl, bc
	ld c, WILD_POKE_SIZE
.poke_loop
	add hl, bc
	ld a, [hl]
	inc a
	jr nz, .poke_loop
	inc hl
	jr .loop

.end
	pop hl
	and a
	ret

.match ;carry flag is set when it finds the right list
	pop hl
	scf
	ret
; 2a2a0


InitRoamMons: ; 2a2a0
; initialize wRoamMon structs

; species
	;ld a, RAIKOU
	;ld [wRoamMon1Species], a
	;ld a, ENTEI
	;ld [wRoamMon2Species], a
;	ld a, SUICUNE
;	ld [wRoamMon3Species], a

; level
	;ld a, 40
	;ld [wRoamMon1Level], a
	;ld [wRoamMon2Level], a
;	ld [wRoamMon3Level], a

; raikou starting map
	;ld a, GROUP_ROUTE_42
	;ld [wRoamMon1MapGroup], a
	;ld a, MAP_ROUTE_42
	;ld [wRoamMon1MapNumber], a

; entei starting map
	;ld a, GROUP_ROUTE_37
	;ld [wRoamMon2MapGroup], a
	;ld a, MAP_ROUTE_37
	;ld [wRoamMon2MapNumber], a

; suicune starting map
;	ld a, GROUP_ROUTE_38
;	ld [wRoamMon3MapGroup], a
;	ld a, MAP_ROUTE_38
;	ld [wRoamMon3MapNumber], a

; hp
	xor a ; generate new stats
	;ld [wRoamMon1HP], a
	;ld [wRoamMon2HP], a
;	ld [wRoamMon3HP], a

	ret
; 2a2ce


CheckEncounterRoamMon: ; 2a2ce
	push hl
; Don't trigger an encounter if we're on water.
	call CheckOnWater
	jr z, .DontEncounterRoamMon
; Load the current map group and number to de
	call CopyCurrMapDE
; Randomly select a beast.
	call Random
	cp 100 ; 25/64 chance
	jr nc, .DontEncounterRoamMon
	and %00000011 ; Of that, a 3/4 chance.  Running total: 75/256, or around 29.3%.
	jr z, .DontEncounterRoamMon
	dec a ; 1/3 chance that it's Entei, 1/3 chance that it's Raikou
; Compare its current location with yours
	ld hl, wRoamMon1MapGroup
	ld c, a
	ld b, 0
	ld a, wRoamMon1End - wRoamMon1 ; length of the RoamMon struct
	rst AddNTimes
	ld a, d
	cp [hl]
	jr nz, .DontEncounterRoamMon
	inc hl
	ld a, e
	cp [hl]
	jr nz, .DontEncounterRoamMon
; We've decided to take on a beast, so stage its information for battle.
	dec hl
	dec hl
	dec hl
	ld a, [hli]
	ld [wTempWildMonSpecies], a
	ld a, [hl]
	ld [wCurPartyLevel], a
	ld a, BATTLETYPE_ROAMING
	ld [wBattleType], a

	pop hl
	scf
	ret

.DontEncounterRoamMon:
	pop hl
	and a
	ret
; 2a30d


UpdateRoamMons: ; 2a30d
	ld a, [wRoamMon1MapGroup]
	cp GROUP_N_A
	jr z, .SkipRaikou
	ld b, a
	ld a, [wRoamMon1MapNumber]
	ld c, a
	call .Update
	ld a, b
	ld [wRoamMon1MapGroup], a
	ld a, c
	ld [wRoamMon1MapNumber], a

.SkipRaikou:
	ld a, [wRoamMon2MapGroup]
	cp GROUP_N_A
	jr z, .SkipEntei
	ld b, a
	ld a, [wRoamMon2MapNumber]
	ld c, a
	call .Update
	ld a, b
	ld [wRoamMon2MapGroup], a
	ld a, c
	ld [wRoamMon2MapNumber], a

.SkipEntei:
	ld a, [wRoamMon3MapGroup]
	cp GROUP_N_A
	jr z, .SkipSuicune
	ld b, a
	ld a, [wRoamMon3MapNumber]
	ld c, a
	call .Update
	ld a, b
	ld [wRoamMon3MapGroup], a
	ld a, c
	ld [wRoamMon3MapNumber], a

.SkipSuicune:
	jp _BackUpMapIndices
; 2a355


.Update: ; 2a355
	ld hl, RoamMaps
.loop
; Are we at the end of the table?
	ld a, [hl]
	cp -1
	ret z
; Is this the correct entry?
	ld a, b
	cp [hl]
	jr nz, .next
	inc hl
	ld a, c
	cp [hl]
	jr z, .yes
; We don't have the correct entry yet, so let's continue.  A 0 terminates each entry.
.next
	ld a, [hli]
	and a
	jr nz, .next
	jr .loop

; We have the correct entry now, so let's choose a random map from it.
.yes
	inc hl
	ld d, h
	ld e, l
.update_loop
	ld h, d
	ld l, e
; Choose which map to warp to.
	call Random
	and $1f ; 1/8n chance it moves to a completely random map, where n is the number of roaming connections from the current map.
	jr z, JumpRoamMon
	and 3
	cp [hl]
	jr nc, .update_loop ; invalid index, try again
	inc hl
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	ld a, [wRoamMons_LastMapGroup]
	cp [hl]
	jr nz, .done
	inc hl
	ld a, [wRoamMons_LastMapNumber]
	cp [hl]
	jr z, .update_loop
	dec hl

.done
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ret

JumpRoamMons: ; 2a394
	ld a, [wRoamMon1MapGroup]
	cp GROUP_N_A
	jr z, .SkipRaikou
	call JumpRoamMon
	ld a, b
	ld [wRoamMon1MapGroup], a
	ld a, c
	ld [wRoamMon1MapNumber], a
.SkipRaikou:

	ld a, [wRoamMon2MapGroup]
	cp GROUP_N_A
	jr z, .SkipEntei
	call JumpRoamMon
	ld a, b
	ld [wRoamMon2MapGroup], a
	ld a, c
	ld [wRoamMon2MapNumber], a
.SkipEntei:

	ld a, [wRoamMon3MapGroup]
	cp GROUP_N_A
	jr z, .SkipSuicune
	call JumpRoamMon
	ld a, b
	ld [wRoamMon3MapGroup], a
	ld a, c
	ld [wRoamMon3MapNumber], a
.SkipSuicune:

	jp _BackUpMapIndices

JumpRoamMon: ; 2a3cd
.loop
	ld hl, RoamMaps
	call Random ; Choose a random number
	and $f ; Take the lower nybble only.  This gives a number between 0 and 15.
	inc a
	ld b, a
.innerloop ; Loop to get hl to the address of the chosen roam map.
	dec b
	jr z, .ok
.innerloop2 ; Loop to skip the current roam map, which is terminated by a 0.
	ld a, [hli]
	and a
	jr nz, .innerloop2
	jr .innerloop
; Check to see if the selected map is the one the player is currently in.  If so, try again.
.ok
	ld a, [wMapGroup]
	cp [hl]
	jr nz, .done
	inc hl
	ld a, [wMapNumber]
	cp [hl]
	jr z, .loop
	dec hl
; Return the map group and number in bc.
.done
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ret
; 2a3f6

_BackUpMapIndices: ; 2a3f6
	ld a, [wRoamMons_CurrentMapNumber]
	ld [wRoamMons_LastMapNumber], a
	ld a, [wRoamMons_CurrentMapGroup]
	ld [wRoamMons_LastMapGroup], a
	ld a, [wMapNumber]
	ld [wRoamMons_CurrentMapNumber], a
	ld a, [wMapGroup]
	ld [wRoamMons_CurrentMapGroup], a
	ret
; 2a40f

INCLUDE "data/wild/roammon_maps.asm"

ValidateTempWildMonSpecies: ; 2a4a0
; Due to a development oversight, this function is called with the wild Pokemon's level, not its species, in a.
	and a
	jr z, .nowildmon ; = 0
	cp NUM_POKEMON + 1 ; 252
	jr nc, .nowildmon ; >= 252
	and a ; 1 <= Species <= 251
	ret

.nowildmon
	scf
	ret
; 2a4ab

RandomPhoneRareWildMon: ; 2a4ab
; Related to the phone?
	farcall GetCallerLocation
	ld d, b
	ld e, c
	ld hl, InvarGrassWildMons
	ld bc, GRASS_WILDDATA_LENGTH
	call LookUpWildmonsForMapDE
	jr c, .GetGrassmon
	jr .done

.GetGrassmon:
	push hl
	ld bc, 5 + 4 * 2 ; Location of the level of the 5th wild Pokemon in that map
	add hl, bc
	ld a, [wTimeOfDay]
	ld bc, 7 * 2
	rst AddNTimes
.randloop1
	call Random
	and $3
	jr z, .randloop1
	dec a
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	add hl, bc
; We now have the pointer to one of the last (rarest) three wild Pokemon found in that area.
	inc hl
	ld c, [hl] ; Contains the species index of this rare Pokemon
	pop hl
	ld de, 5 + 0 * 3
	add hl, de
	inc hl ; Species index of the most common Pokemon on that route
	ld b, 4
.loop2
	ld a, [hli]
	cp c ; Compare this most common Pokemon with the rare one stored in c.
	jr z, .done
	inc hl
	dec b
	jr nz, .loop2
; This Pokemon truly is rare.
	push bc
	dec c
	ld a, c
	farcall CheckSeenMon
	pop bc
	jr nz, .done
; Since we haven't seen it, have the caller tell us about it.
	ld de, wStringBuffer1
	call CopyName1
	ld a, c
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, .SawRareMonText
	call PrintText
	xor a
	ld [wScriptVar], a
	ret

.done
	ld a, $1
	ld [wScriptVar], a
	ret

.SawRareMonText:
	; I just saw some rare @  in @ . I'll call you if I see another rare Pokémon, OK?
	text_jump UnknownText_0x1bd34b
	db "@"
; 0x2a51f

RandomPhoneWildMon: ; 2a51f
	farcall GetCallerLocation
	ld d, b
	ld e, c
	ld hl, InvarGrassWildMons
	ld bc, GRASS_WILDDATA_LENGTH
	call LookUpWildmonsForMapDE
	ld bc, 5 + 0 * 2
	add hl, bc
	ld a, [wTimeOfDay]
	inc a
	ld bc, 7 * 2
.loop
	dec a
	jr z, .done
	add hl, bc
	jr .loop

.done
	call Random
	and $3
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	inc hl
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, wStringBuffer1
	ld de, wStringBuffer4
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ret
; 2a567

RandomPhoneMon: ; 2a567
; Get a random monster owned by the trainer who's calling.
	farcall GetCallerLocation
	ld hl, TrainerGroups
	ld a, d
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, BANK(TrainerGroups)
	call GetFarByte
	inc hl
	ld [wTrainerGroupBank], a
	ld a, BANK(TrainerGroups)
	call GetFarHalfword

.skip_trainer
	dec e
	jr z, .skipped
.skip
	ld a, [wTrainerGroupBank]
	call GetFarByte
	inc hl
	cp -1
	jr nz, .skip
	jr .skip_trainer
.skipped

.skip_name
	ld a, [wTrainerGroupBank]
	call GetFarByte
	inc hl
	cp "@"
	jr nz, .skip_name

	ld a, [wTrainerGroupBank]
	call GetFarByte
	inc hl

	; get trainer type
	ld b, a
	; nicknames have uneven length, so always use the first mon
	bit TRNTYPE_NICKNAME, b
	jr nz, .got_mon
	; TRAINERTYPE_NORMAL uses 2 bytes per mon
	ld c, 2
	; TRAINERTYPE_ITEM uses 1 more byte
	bit TRNTYPE_ITEM, b
	jr z, .no_item
	inc c
.no_item
	; TRAINERTYPE_EVs uses 1 more byte
	bit TRNTYPE_EVS, b
	jr z, .no_evs
	inc c
.no_evs
	; TRAINERTYPE_DVS uses 3 more bytes
	bit TRNTYPE_DVS, b
	jr z, .no_dvs
	inc c
	inc c
	inc c
.no_dvs
	; TRAINERTYPE_PERSONALITY uses 2 more bytes
	bit TRNTYPE_PERSONALITY, b
	jr z, .no_personality
	inc c
	inc c
.no_personality
	; TRAINERTYPE_MOVES uses 4 more bytes
	bit TRNTYPE_MOVES, b
	jr z, .no_moves
	inc c
	inc c
	inc c
	inc c
.no_moves
	; bc == size of mon sub-struct
	xor a
	ld b, a

	ld e, 0
	push hl
.count_mon
	inc e
	add hl, bc
	ld a, [wTrainerGroupBank]
	call GetFarByte
	cp -1
	jr nz, .count_mon
	pop hl

.rand
	call Random
	and 7
	cp e
	jr nc, .rand

	inc a
.get_mon
	dec a
	jr z, .got_mon
	add hl, bc
	jr .get_mon
.got_mon

	inc hl ; species
	ld a, [wTrainerGroupBank]
	call GetFarByte
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, wStringBuffer1
	ld de, wStringBuffer4
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ret
; 2a5e9


InvarGrassWildMons: ; 0x2a5e9
INCLUDE "data/wild/invar_grass.asm"

InvarWaterWildMons: ; 0x2b11d
INCLUDE "data/wild/invar_water.asm"

;KantoGrassWildMons: ; 0x2b274
;INCLUDE "data/wild/kanto_grass.asm"

;KantoWaterWildMons: ; 0x2b7f7
;INCLUDE "data/wild/kanto_water.asm"

;OrangeGrassWildMons:
;INCLUDE "data/wild/orange_grass.asm"

;OrangeWaterWildMons:
;INCLUDE "data/wild/orange_water.asm"

SwarmGrassWildMons: ; 0x2b8d0
INCLUDE "data/wild/swarm_grass.asm"

SwarmWaterWildMons: ; 0x2b92f
INCLUDE "data/wild/swarm_water.asm"
