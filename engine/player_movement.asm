DoPlayerMovement:: ; 80000

	call .GetDPad
	ld a, movement_step_sleep_1
	ld [wMovementAnimation], a
	call .TranslateIntoMovement
	ld c, a
	ld a, [wMovementAnimation]
	ld [wPlayerNextMovement], a
	ret

.GetDPad:

	ldh a, [hJoyDown]
	ld [wCurInput], a

; Standing downhill instead moves down.

	ld hl, wOWState
	bit OWSTATE_BIKING_DOWNHILL, [hl]
	ret z

	ld c, a
	and D_PAD
	ret nz

	ld a, c
	or D_DOWN
	ld [wCurInput], a
	ret
; 8002d

.TranslateIntoMovement:
	ld a, [wPlayerState]
	and a ; cp PLAYER_NORMAL
	jr z, .Normal
	cp PLAYER_SURF
	jr z, .Surf
	cp PLAYER_SURF_PIKA
	jr z, .Surf
	cp PLAYER_BIKE
	jr z, .Normal
	cp PLAYER_SLIP
	jr z, .Ice

.Normal:
	call .CheckForced
	call .GetAction
	call .CheckTile
	ret c
	call .CheckTurning
	ret c
	call .TryDiagonalStairs
	ret c
	call .TryStep
	ret c
	call .TryJump
	ret c
	call .CheckWarp
	ret c
	jr .NotMoving

.Surf:
	call .CheckForced
	call .GetAction
	call .CheckTile
	ret c
	call .CheckTurning
	ret c
	call .TrySurf
	ret c
	jr .NotMoving

.Ice:
	call .CheckForced
	call .GetAction
	call .CheckTile
	ret c
	call .CheckTurning
	ret c
	call .TryDiagonalStairs
	ret c
	call .TryStep
	ret c
	call .TryJump
	ret c
	call .CheckWarp
	ret c
	ld a, [wWalkingDirection]
	cp STANDING
	jr z, .HitWall
	call .BumpSound
.HitWall:
	call .StandInPlace
	xor a
	ret

.NotMoving:
	ld a, [wWalkingDirection]
	cp STANDING
	jr z, .Standing

; Walking into an edge warp won't bump.
	ld a, [wEngineBuffer4]
	and a
	jr nz, .CantMove
	call .BumpSound
.CantMove:
	call ._WalkInPlace
	xor a
	ret

.Standing:
	call .StandInPlace
	xor a
	ret
; 800b7

.CheckTile: ; 800b7
; Tiles such as waterfalls and warps move the player
; in a given direction, overriding input.

	ld a, OBJECT_STANDING_TILE
	predef GetCenteredObjectStructParam
	ld c, a
	cp COLL_WHIRLPOOL
	jr nz, .not_whirlpool
	ld a, 3
	scf
	ret

.not_whirlpool
	and $f0
	cp $30 ; moving water
	jr z, .water
	cp $70 ; warps
	jr z, .warps
	jr .no_walk

.water
	ld a, c
	and 3
	ld c, a
	ld b, 0
	ld hl, .water_table
	add hl, bc
	ld a, [hl]
	ld [wWalkingDirection], a
	ld a, STEP_BIKE
	jr .finish

.water_table
	db RIGHT
	db LEFT
	db UP
	db DOWN

.warps
	ld a, c
	cp COLL_AWNING
	jr z, .up
	cp COLL_DOOR
	jr z, .down
	cp COLL_STAIRCASE
	jr z, .down
	cp COLL_CAVE
	jr nz, .no_walk

.down
	xor a ; DOWN
	jr .set_direction
.up
	ld a, UP
.set_direction
	ld [wWalkingDirection], a
	jr .continue_walk

.no_walk
	xor a
	ret

.continue_walk
	ld a, STEP_WALK
.finish
	call .DoStep
	ld a, 5
	scf
	ret
; 80147

.CheckTurning: ; 80147
; If the player is turning, change direction first. This also lets
; the player change facing without moving by tapping a direction.

	ld a, [wPlayerTurningDirection]
	cp 0
	jr nz, .not_turning
	ld a, [wWalkingDirection]
	cp STANDING
	jr z, .not_turning

	ld e, a
	ld a, OBJECT_DIRECTION
	predef GetCenteredObjectStructParam

	rrca
	rrca
	and 3
	cp e
	jr z, .not_turning

	ld a, STEP_TURN
	call .DoStep
	ld a, 2
	scf
	ret

.not_turning
	xor a
	ret
; 8016b

.TryStep: ; 8016b

; Surfing actually calls .TrySurf directly instead of passing through here.
	ld a, [wPlayerState]
	cp PLAYER_SURF
	jr z, .TrySurf
	cp PLAYER_SURF_PIKA
	jr z, .TrySurf

	call .CheckLandPerms
	jr c, .bump

	call .CheckNPC
	and a
	jr z, .bump
	cp 2
	jr z, .bump

	ld a, [wSpinning]
	and a
	jr nz, .spin

	ld a, OBJECT_STANDING_TILE
	predef GetCenteredObjectStructParam
	cp COLL_ICE
	jr z, .ice

	ld a, [wOptions2]
	and 1 << RUNNING_SHOES
	jr nz, .RunByDefault

	call .RunCheck
	jr z, .run
	jp .DoNotRun

.RunByDefault
	call .RunCheck
	jr nz, .run

.DoNotRun
; Downhill riding is slower when not moving down.
	call .BikeCheck
	jr nz, .walk

	ld hl, wOWState
	bit OWSTATE_BIKING_DOWNHILL, [hl]
	jr z, .fast

	ld a, [wWalkingDirection]
	cp DOWN
	jr z, .fast

	ld a, STEP_WALK
	call .DoStep
	scf
	ret

.fast
	ld a, STEP_BIKE
	call .DoStep
	scf
	ret

.walk
	ld a, STEP_WALK
	call .DoStep
	scf
	ret

.ice
	ld a, STEP_ICE
	call .DoStep
	scf
	ret

.run
	ld a, STEP_RUN
	call .DoStep
;   Trainer faces player -- not a current feature
;	push af
;	ld a, [wWalkingDirection]
;	cp STANDING
;	jr z, .skip_trainer
;	call CheckTrainerRun
;.skip_trainer
;	pop af
	scf
	ret

.spin
	ld de, SFX_SQUEAK
	call PlaySFX
	ld a, STEP_SPIN
	call .DoStep
	scf
	ret

.bump
	xor a
	ld [wSpinning], a
	ret
; 801c0

.TrySurf: ; 801c0

	call .CheckNPC
	and a
	jr z, .surf_bump
	cp 2
	jr z, .surf_bump

	call .CheckSurfPerms
	jr c, .surf_bump

	and a
	jr nz, .ExitWater

	ld a, [wOWState]
	set OWSTATE_SURF, a
	ld [wOWState], a
	ld a, STEP_FAST
	call .DoStep
	scf
	ret

.ExitWater:
	call .GetOutOfWater
	call PlayMapMusic
	ld a, STEP_WALK
	call .DoStep
	ld a, 6
	scf
	ret

.surf_bump
	xor a
	ret
; 801f3

.TryJump: ; 801f3
	ld a, OBJECT_STANDING_TILE
	predef GetCenteredObjectStructParam
	ld e, a
	and $f0
	cp $a0 ; ledge
	jr nz, .DontJumpOrDiagonalStairs

	ld a, e
	and 7
	ld e, a
	ld d, 0
	ld hl, .data_8021e
	add hl, de
	ld a, [wFacingDirection]
	and [hl]
	jr z, .DontJumpOrDiagonalStairs

	ld de, SFX_JUMP_OVER_LEDGE
	call PlaySFX
	ld a, STEP_LEDGE
	call .DoStep
	ld a, 7
	scf
	ret

.DontJumpOrDiagonalStairs:
	xor a
	ret

.data_8021e
	db FACE_RIGHT
	db FACE_LEFT
	db FACE_UP
	db FACE_DOWN
	db FACE_RIGHT | FACE_DOWN
	db FACE_DOWN | FACE_LEFT
	db FACE_UP | FACE_RIGHT
	db FACE_UP | FACE_LEFT
; 80226

.TryDiagonalStairs:
	ld a, [wPlayerGoingUpStairs]
	and a
	jr nz, .DontJumpOrDiagonalStairs

	ld a, OBJECT_STANDING_TILE
	predef GetCenteredObjectStructParam
	ld e, a
	and $f0
	cp HI_NYBBLE_DIAGONAL_STAIRS
	jr nz, .DontJumpOrDiagonalStairs

	ld a, e
	and $0f
	ld e, a
	ld d, 0
	ld hl, .FacingStairsTable
	add hl, de
	add hl, de
	add hl, de
	ld a, [wFacingDirection]
	and [hl]
	jr z, .DontJumpOrDiagonalStairs
	inc hl
	cp FACE_LEFT
	ld a, [hli]
	ld b, [hl]
	jr z, .dont_swap
	swap a
	swap b
.dont_swap
	and $f
	ld [wPlayerGoingUpStairs], a
	ld a, b
	and $f
	ld [wPlayerStairsType], a

	ld a, [wFacingDirection]
	ld [wPlayerGoingLeftRightStairs], a

	ld a, STEP_DIAGONAL_STAIRS
	call .DoStep
	ld a, 7
	scf
	ret

.FacingStairsTable:
	stairtable FACE_RIGHT, 				DOWN+1, DOWN+1,  %11,  %11 ;COLL_STAIRS_RIGHT_DOWN
	stairtable FACE_LEFT, 				DOWN+1, DOWN+1,  %11,  %11 ;COLL_STAIRS_LEFT_DOWN
	stairtable FACE_RIGHT, 				UP+1, 	UP+1,  	 %10,  %10 ;COLL_STAIRS_RIGHT_UP
	stairtable FACE_LEFT, 				UP+1, 	UP+1, 	 %10,  %10 ;COLL_STAIRS_LEFT_UP
	stairtable FACE_RIGHT | FACE_LEFT,	UP+1, 	DOWN+1,	 %10,  %10 ;COLL_STAIRS_RIGHT_UP_FLAT
	stairtable FACE_RIGHT | FACE_LEFT,	DOWN+1, UP+1,  	 %10,  %10 ;COLL_STAIRS_LEFT_UP_FLAT
	stairtable FACE_RIGHT | FACE_LEFT,	UP+1, 	DOWN+1,	%111, %111 ;COLL_STAIRS_RIGHT_UP_MID
	stairtable FACE_RIGHT | FACE_LEFT,	DOWN+1, UP+1, 	%111, %111 ;COLL_STAIRS_LEFT_UP_MID
	stairtable FACE_RIGHT | FACE_LEFT,	UP+1, 	DOWN+1,	%111, %100 ;COLL_STAIRS_RIGHT_UP_BOTTOM
	stairtable FACE_RIGHT | FACE_LEFT,	DOWN+1, UP+1, 	%100, %111 ;COLL_STAIRS_LEFT_UP_BOTTOM
	stairtable FACE_RIGHT | FACE_LEFT,	UP+1, 	DOWN+1, %101, %111 ;COLL_STAIRS_RIGHT_UP_TOP
	stairtable FACE_RIGHT | FACE_LEFT,	DOWN+1, UP+1, 	%111, %101 ;COLL_STAIRS_LEFT_UP_TOP
	stairtable FACE_RIGHT | FACE_LEFT,	UP+1, 	DOWN+1, %101, %100 ;COLL_STAIRS_RIGHT_UP_HALF
	stairtable FACE_RIGHT | FACE_LEFT,	DOWN+1, UP+1, 	%100, %101 ;COLL_STAIRS_LEFT_UP_HALF

.CheckWarp: ; 80226

	ld a, [wWalkingDirection]
	cp STANDING
	jr z, .not_warp
	ld e, a
	ld d, 0
	ld hl, .EdgeWarps
	add hl, de
	ld a, OBJECT_STANDING_TILE
	predef GetCenteredObjectStructParam
	cp [hl]
	jr nz, .not_warp

	ld a, [wWalkingDirection]
	cp STANDING
	jr z, .not_warp

	ld e, a
	ld a, OBJECT_DIRECTION
	predef GetCenteredObjectStructParam

	rrca
	rrca
	and 3
	cp e
	jr nz, .not_warp
	call WarpCheck
	jr nc, .not_warp

	call .StandInPlace
	scf
	ld a, 1
	ret

.not_warp
	xor a
	ret

.EdgeWarps:
	db COLL_WARP_CARPET_DOWN
	db COLL_WARP_CARPET_UP
	db COLL_WARP_CARPET_LEFT
	db COLL_WARP_CARPET_RIGHT
; 8025f

.DoStep:
	ld e, a
	ld d, 0
	ld hl, .Steps
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [wWalkingDirection]
	ld e, a
	cp STANDING
	jp z, .StandInPlace

	ld a, [hl]
	cp movement_turn_step_down
	jr z, .turn_step
	ld a, [wHasPlayerMoved]
	inc a
	inc a
	jr z, .turn_step
	dec a
	ld [wHasPlayerMoved], a
.turn_step
	add hl, de
	ld a, [hl]
	ld [wMovementAnimation], a

	ld hl, .InPlace
	add hl, de
	ld a, [hl]
	ld [wPlayerTurningDirection], a
	ld a, 4
	ret

.Steps:
	dw .SlowStep ; x0.5
	dw .NormalStep ; x1
	dw .FastStep ; x4
	dw .Run ; x2, doubles animation speed
	dw .JumpStep
	dw .SlideStep
	dw .TurningStep
	dw .BackJumpStep
	dw .InPlace
	dw .SpinStep
	dw .Fast ; x2
	dw .DiagonalStairsStep

.SlowStep:
	slow_step_down
	slow_step_up
	slow_step_left
	slow_step_right
.NormalStep:
	step_down
	step_up
	step_left
	step_right
.FastStep:
	big_step_down
	big_step_up
	big_step_left
	big_step_right
.Run
	run_step_down
	run_step_up
	run_step_left
	run_step_right
.JumpStep:
	jump_step_down
	jump_step_up
	jump_step_left
	jump_step_right
.SlideStep:
	fast_slide_step_down
	fast_slide_step_up
	fast_slide_step_left
	fast_slide_step_right
.BackJumpStep:
	jump_step_up
	jump_step_down
	jump_step_right
	jump_step_left
.TurningStep:
	turn_step_down
	turn_step_up
	turn_step_left
	turn_step_right
.InPlace:
	db $80 + movement_turn_head_down
	db $80 + movement_turn_head_up
	db $80 + movement_turn_head_left
	db $80 + movement_turn_head_right
.SpinStep
	turn_in_down
	turn_in_up
	turn_in_left
	turn_in_right
.Fast
	fast_step_down
	fast_step_up
	fast_step_left
	fast_step_right
.DiagonalStairsStep:
	stairs_step DOWN
	stairs_step UP
	stairs_step LEFT
	stairs_step RIGHT

.StandInPlace: ; 802b3
	call SetTallGrassAttributes
	ld a, movement_step_sleep_1
	ld [wMovementAnimation], a
	xor a
	ld [wPlayerTurningDirection], a
	ret
; 802bf

._WalkInPlace: ; 802bf
	ld a, movement_step_bump
	ld [wMovementAnimation], a
	xor a
	ld [wPlayerTurningDirection], a
	ld [wHasPlayerMoved], a
	ret
; 802cb

.CheckForced: ; 802cb
; When sliding on ice, input is forced to remain in the same direction.

	call CheckSpinning
	jr z, .not_spinning
	dec a
	jr .force

.not_spinning
	call CheckStandingOnIce
	ret nc

	ld a, [wPlayerTurningDirection]
	cp 0
	ret z

.force
	and 3
	ld e, a
	ld d, 0
	ld hl, .forced_dpad
	add hl, de
	ld a, [wCurInput]
	and BUTTONS
	or [hl]
	ld [wCurInput], a
	ret

.forced_dpad
	db D_DOWN, D_UP, D_LEFT, D_RIGHT
; 802ec

.GetAction: ; 802ec
; Poll player input and update movement info.

	ld a, [wPlayerOverworldStatus]
	bit 3, a
	ld hl, .tablePlayer
	jr z, .got_it
	ld hl, .tableFollower
.got_it

	ld de, .table2 - .table1
	ld a, [wCurInput]
	bit D_DOWN_F, a
	jr nz, .d_down
	bit D_UP_F, a
	jr nz, .d_up
	bit D_LEFT_F, a
	jr nz, .d_left
	bit D_RIGHT_F, a
	jr nz, .d_right
; Standing
	jr .update

.d_down 	add hl, de
.d_up   	add hl, de
.d_left 	add hl, de
.d_right	add hl, de

.update
	ld a, [hli]
	ld [wWalkingDirection], a
	ld a, [hli]
	ld [wFacingDirection], a
	ld a, [hli]
	ld [wWalkingX], a
	ld a, [hli]
	ld [wWalkingY], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	ld [wWalkingTile], a
	ret

.tablePlayer
; struct:
;	walk direction
;	facing
;	x movement
;	y movement
;	tile collision pointer
.table1
	db STANDING, FACE_CURRENT, 0, 0
	dw wPlayerStandingTile
.table2
	db RIGHT, FACE_RIGHT,  1,  0
	dw wTileRight
	db LEFT,  FACE_LEFT,  -1,  0
	dw wTileLeft
	db UP,    FACE_UP,     0, -1
	dw wTileUp
	db DOWN,  FACE_DOWN,   0,  1
	dw wTileDown
; 80341
.tableFollower
; struct:
;	walk direction
;	facing
;	x movement
;	y movement
;	tile collision pointer
.table11
	db STANDING, FACE_CURRENT, 0, 0
	dw wFollowerStandingTile
.table22
	db RIGHT, FACE_RIGHT,  1,  0
	dw wTileRight
	db LEFT,  FACE_LEFT,  -1,  0
	dw wTileLeft
	db UP,    FACE_UP,     0, -1
	dw wTileUp
	db DOWN,  FACE_DOWN,   0,  1
	dw wTileDown


.CheckNPC: ; 80341
; Returns 0 if there is an NPC in front that you can't move
; Returns 1 if there is no NPC in front
; Returns 2 if there is a movable NPC in front
	xor a
	ldh [hMapObjectIndexBuffer], a
; Load the next X coordinate into d
	ld a, OBJECT_STANDING_X
	predef GetCenteredObjectStructParam
	ld d, a
	ld a, [wWalkingX]
	add d
	ld d, a
; Load the next Y coordinate into e
	ld a, OBJECT_STANDING_Y
	predef GetCenteredObjectStructParam
	ld e, a
	ld a, [wWalkingY]
	add e
	ld e, a
; Find an object struct with coordinates equal to d,e
	farcall IsNPCAtCoord
	jr nc, .no_npc

	call .PushPetCheck
	jr nc, .no_npc

	call .CheckStrengthBoulder
	jr c, .no_bump

	xor a
	ret

.no_npc
	ld a, 1
	ret

.no_bump
	ld a, 2
	ret
; 8036f

.CheckStrengthBoulder: ; 8036f

	ld hl, wOWState
	bit OWSTATE_STRENGTH, [hl]
	jr z, .not_boulder

	ld hl, OBJECT_WALKING
	add hl, bc
	ld a, [hl]
	cp STANDING
	jr nz, .not_boulder

	ld hl, OBJECT_PALETTE
	add hl, bc
	bit 6, [hl]
	jr z, .not_boulder

	ld hl, OBJECT_FLAGS2
	add hl, bc
	set 2, [hl]

	ld a, [wWalkingDirection]
	ld d, a
	ld hl, OBJECT_RANGE
	add hl, bc
	ld a, [hl]
	and $fc
	or d
	ld [hl], a

	scf
	ret

.not_boulder
	xor a
	ret
; 8039e

.PushPetCheck:
	ld a, [wPlayerOverworldStatus]
	bit 4, a
	jr nz, .move_disable

	ld a, [hObjectStructIndexBuffer]
	cp FOLLOWER
	jr z, .move_enable
	cp PLAYER
	jr z, .move_enable
.move_disable
	scf
	ret

.move_enable:
	xor a
	ret

.CheckLandPerms: ; 8039e
; Return 0 if walking onto land and tile permissions allow it.
; Otherwise, return carry.

	ld a, [wTilePermissions]
	ld d, a
	ld a, [wFacingDirection]
	and d
	jr nz, .NotWalkable

	ld a, [wWalkingTile]
	call .CheckWalkable
	jr c, .NotWalkable

	xor a
	ret

.NotWalkable:
	scf
	ret
; 803b4

.CheckSurfPerms: ; 803b4
; Return 0 if moving in water, or 1 if moving onto land.
; Otherwise, return carry.

	ld a, [wTilePermissions]
	ld d, a
	ld a, [wFacingDirection]
	and d
	jr nz, .NotSurfable

	ld a, [wWalkingTile]
	call .CheckSurfable
	jr c, .NotSurfable

	and a
	ret

.NotSurfable:
	scf
	ret
; 803ca

.BikeCheck: ; 803ca

	ld a, [wPlayerState]
	cp PLAYER_BIKE
	ret z
	cp PLAYER_SLIP
	ret
; 803d3

; Routine by Victoria Lacroix
; https://github.com/VictoriaLacroix/pokecrystal/commit/ed7f525d642cb02e84e856f2e506d2a6425d95db
.RunCheck:

	ld a, [wPlayerState]
	and a ; cp PLAYER_NORMAL
	ret nz
	ldh a, [hJoypadDown]
	and B_BUTTON
	cp B_BUTTON
	ret

.CheckWalkable: ; 803d3
; Return 0 if tile a is land. Otherwise, return carry.

	call GetTileCollision
	and a ; cp LANDTILE
	ret z
	scf
	ret
; 803da

.CheckSurfable: ; 803da
; Return 0 if tile a is water, or 1 if land.
; Otherwise, return carry.

	call GetTileCollision
	cp WATERTILE
	jr z, .Water

; Can walk back onto land from water.
	and a ; cp LANDTILE
	jr z, .Land

	jr .Neither

.Water:
	xor a
	ret

.Land:
	ld a, 1
	and a
	ret

.Neither:
	scf
	ret
; 803ee

.BumpSound: ; 803ee
	ld a, [wPlayerGoingUpStairs]
	and a
	ret nz

	call CheckSFX
	ret c
	ld de, SFX_BUMP
	jp PlaySFX
; 803f9

.GetOutOfWater: ; 803f9
	push bc
	ld a, PLAYER_NORMAL
	ld [wPlayerState], a
	farcall RemoveRidePokemon
	call ReplaceKrisSprite ; UpdateSprites
	pop bc
	ret
; 80404

CheckStandingOnIce:: ; 80404
	ld a, [wPlayerTurningDirection]
	cp 0
	jr z, .not_ice
	cp $f0
	jr z, .not_ice
	ld a, OBJECT_STANDING_TILE
	predef GetCenteredObjectStructParam
	cp COLL_ICE
	jr z, .ice
	ld a, [wPlayerState]
	cp PLAYER_SLIP
	jr nz, .not_ice

.ice
	scf
	ret

.not_ice
	and a
	ret
; 80422

CheckSpinTile::
	cp COLL_SPIN_UP
	ld c, UP
	ret z
	cp COLL_SPIN_DOWN
	ld c, DOWN
	ret z
	cp COLL_SPIN_LEFT
	ld c, LEFT
	ret z
	cp COLL_SPIN_RIGHT
	ld c, RIGHT
	ret z
	ld c, STANDING
	ret

CheckSpinning::
	ld a, OBJECT_STANDING_TILE
	predef GetCenteredObjectStructParam
	call CheckSpinTile
	jr z, .start_spin
	cp COLL_STOP_SPIN
	jr z, .stop_spin
	ld a, [wSpinning]
	and a
	ret

.start_spin
	ld a, c
	inc a
	ld [wSpinning], a
	and a
	ret

.stop_spin
	xor a
	ld [wSpinning], a
	ret

StopPlayerForEvent:: ; 80422
	ld hl, wPlayerNextMovement
	ld a, movement_step_sleep_1
	cp [hl]
	ret z

	ld [hl], a
	xor a
	ld [wPlayerTurningDirection], a
	ret
; 80430

SetTallGrassAttributes::
	ld a, OBJECT_STANDING_TILE
	farcall GetFollowObjectStructParam
	cp COLL_TALL_GRASS
	call z, .setFollowerGrassAddress

	ld a, OBJECT_STANDING_TILE
	predef GetCenteredObjectStructParam
	cp COLL_TALL_GRASS
	ret nz
	xor a
	ld [wHasPlayerMoved], a
	call GetBGMapPlayerOffset
	ld bc, BG_MAP_WIDTH
	add hl, bc
	ld a, l
	ld [wGrassTileAddress], a
	ld a, h
	ld [wGrassTileAddress+1], a
	ret

.setFollowerGrassAddress:
	ld a, OBJECT_STANDING_X
	predef GetCenteredObjectStructParamAddress
	ld a, OBJECT_STANDING_X
	farcall GetFollowObjectStructParam
	cp [hl]
	jr c, .left
	inc hl ;wPlayer/FollowerStandingMapY
	ld a, OBJECT_STANDING_Y
	farcall GetFollowObjectStructParam
	cp [hl]
	jr z, .right
	jr c, .above
.below
	ld bc, BG_MAP_WIDTH * 3
	jr .done
.left
	ld bc, BG_MAP_WIDTH - 2
	jr .done
.right
	ld bc, BG_MAP_WIDTH + 2
	jr .done
.above
	ld bc, -BG_MAP_WIDTH
.done
	call GetBGMapPlayerOffset
	add hl, bc
	ld a, l
	ld [wFollowerGrassTileAddress], a
	ld a, h
	ld [wFollowerGrassTileAddress+1], a
	ret

GetBGMapPlayerOffset::
; hl = {wBGMapAnchor} + BG_MAP_WIDTH * 8 + 8 (player's top-left tile)
; de = wUnusedMapBuffer
	ld hl, wBGMapAnchor + 1
	ld a, [hld] ; a = HIGH({wBGMapAnchor})
	inc a ; move down 8 rows
	and HIGH(VBGMap0 + BG_MAP_WIDTH * BG_MAP_HEIGHT - 1) ; wrap vertically
	ld l, [hl]
	ld h, a
	ld a, l
	add a, 8 ; move right 8 rows
	; restore "row" bits (upper 3)
	xor l
	and BG_MAP_WIDTH - 1
	xor l
	ld l, a
	ret
