	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27, $00, $28, $29, $2a, $2b, $2c, $2d, $2e
	db $2f, $30, $31, $32, $33, $34, $35
.frame2
	db $01 ; bitmask
	db $24, $25, $26, $27, $00, $28, $29, $2a, $2b, $2c, $2d, $2e
	db $2f, $30, $31, $32, $36, $34, $37, $38, $39, $00, $3a, $3b
.frame3
	db $02 ; bitmask
	db $24, $25, $26, $27, $00, $28, $29, $2a, $2b, $2c, $2d, $2e
	db $2f, $30, $31, $32, $36, $34, $3c, $3d, $3e, $3f, $40
.frame4
	db $03 ; bitmask
	db $24, $25, $26, $27, $00, $28, $29, $2a, $2b, $41, $42, $2c
	db $2d, $2e, $2f, $30, $43, $31, $32, $33, $34, $35