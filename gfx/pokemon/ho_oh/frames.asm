	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $30, $35, $36, $37, $38, $39, $30, $3a
	db $3b, $3c, $3d, $3e, $3f, $40
.frame2
	db $01 ; bitmask
	db $41, $42, $43, $44, $45, $46, $30, $47, $48, $49, $4a, $4b
	db $4c, $30, $4d, $4e, $4f, $50, $51, $3d, $3e, $52, $53, $54
	db $55, $40
.frame3
	db $02 ; bitmask
	db $56, $57, $58, $59, $5a, $5b, $30, $47, $5c, $5d, $5e, $5f
	db $60, $61, $4d, $62, $63, $50, $51, $64, $65, $66, $67, $68
	db $55, $40, $69, $6a, $6b, $6c, $6d, $6e, $6f, $70, $71, $72
	db $73, $74, $75, $76, $77
.frame4
	db $03 ; bitmask
	db $78, $79, $7a, $7b