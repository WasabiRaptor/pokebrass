	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21
.frame2
	db $00 ; bitmask
	db $19, $1a, $22, $1c, $1d, $1e, $1f, $20, $21
.frame3
	db $01 ; bitmask
	db $23, $24, $25, $26, $27, $28, $29, $2a, $2b
.frame4
	db $02 ; bitmask
	db $2c, $2d
