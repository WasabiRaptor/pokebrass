	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $05, $2e
	db $2f, $30, $31, $05, $32, $33, $34, $35, $36, $37, $38, $39
	db $05, $3a, $3b, $3c, $3d, $3e
.frame2
	db $01 ; bitmask
	db $05, $05, $3f, $40, $41, $05, $42, $43, $2c, $44, $05, $45
	db $46, $30, $47, $05, $05, $32, $33, $48, $05, $49, $4a, $4b
	db $4c, $05, $4d, $05, $05, $4e, $4f
.frame3
	db $01 ; bitmask
	db $05, $05, $05, $05, $05, $50, $51, $43, $2c, $44, $52, $53
	db $46, $30, $47, $54, $05, $32, $33, $05, $05, $55, $4a, $56
	db $05, $05, $05, $05, $57, $58, $05
.frame4
	db $01 ; bitmask
	db $05, $59, $5a, $5b, $5c, $5d, $5e, $5f, $60, $61, $62, $63
	db $64, $30, $65, $66, $05, $67, $33, $68, $69, $6a, $6b, $6c
	db $6d, $05, $6e, $6f, $70, $71, $4f
.frame5
	db $02 ; bitmask
	db $30, $72, $33