	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $00, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b
	db $3c, $3d, $3e, $3f, $40, $41, $42, $43, $44, $00, $45, $46
	db $47, $48, $49, $00, $00, $00, $00, $00, $4a
.frame2
	db $01 ; bitmask
	db $00, $4b, $4c, $4d, $4e, $4f, $50, $51, $52, $53, $54, $55
	db $56, $57, $58, $59, $5a, $5b, $5c, $5d, $5e, $5f, $60, $61
	db $62, $63, $64, $00, $00, $65, $66, $67, $00, $00, $00, $00
	db $00, $4a
.frame3
	db $02 ; bitmask
	db $68, $69, $6a, $6b, $6c, $6d, $6e, $6f, $70, $71, $72, $73
.frame4
	db $03 ; bitmask
	db $74, $75, $76, $77, $78, $79, $7a, $7b, $7c, $7d, $7e, $7f
	db $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b
	db $8c, $8d, $8e, $8f, $90, $91, $92, $93, $94, $95, $96, $97
	db $98, $99, $9a, $9b
.frame5
	db $04 ; bitmask
	db $9c, $9d, $6d, $9e, $9f, $a0
.frame6
	db $03 ; bitmask
	db $74, $75, $76, $77, $78, $79, $7a, $a1, $a2, $7d, $7e, $7f
	db $80, $81, $a3, $a4, $84, $85, $86, $87, $88, $89, $8a, $8b
	db $8c, $8d, $8e, $8f, $90, $91, $92, $93, $94, $95, $96, $97
	db $98, $99, $9a, $9b
