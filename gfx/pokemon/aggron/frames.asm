	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47, $48
	db $49, $4a, $4b, $4c
.frame2
	db $01 ; bitmask
	db $4d, $4e, $4f, $50, $51, $52, $53
.frame3
	db $02 ; bitmask
	db $54, $06, $55, $56, $57, $58, $59, $5a, $5b
.frame4
	db $02 ; bitmask
	db $5c, $06, $5d, $5e, $5f, $58, $59, $5a, $5b