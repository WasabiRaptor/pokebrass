	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $40, $00, $00, $00, $41, $00, $00, $00
.frame2
	db $01 ; bitmask
	db $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d
	db $4e, $4f, $50, $00, $00, $51, $40, $00, $00, $00, $41, $00
	db $00, $00
.frame3
	db $02 ; bitmask
	db $52, $53, $54, $55, $56, $57, $58
.frame4
	db $03 ; bitmask
	db $59, $5a
