	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $31, $32, $33
.frame2
	db $01 ; bitmask
	db $31, $34, $35, $36, $37
.frame3
	db $02 ; bitmask
	db $31, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e
	db $00, $00, $3f, $40, $41, $42
.frame4
	db $03 ; bitmask
	db $31, $34, $35, $36, $37, $43, $44, $45, $46, $47, $48, $49
	db $4a, $4b, $4c, $00, $00, $4d, $4e, $4f, $50
.frame5
	db $04 ; bitmask
	db $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $5b, $5c
	db $5d, $5e, $5f, $60, $61, $62, $00
.frame6
	db $05 ; bitmask
	db $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $5b, $63
	db $5e, $5f
