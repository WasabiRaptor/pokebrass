	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $00, $34, $35, $36, $37, $38, $39, $3a, $3b
	db $3c, $3d, $3e, $2b, $3f, $40, $41, $00, $42, $43, $44, $45
	db $46, $00, $47, $48, $49, $4a
.frame2
	db $01 ; bitmask
	db $4b, $4c, $4d, $4e, $00, $4f, $50, $51, $52, $53, $54, $55
	db $56, $00, $57, $58, $59, $5a, $00, $5b, $5c, $5d, $00, $5e
	db $5f, $60, $61, $62, $00, $63, $64, $65, $66, $67
.frame3
	db $02 ; bitmask
	db $4b, $68, $69, $6a, $00, $4f, $50, $6b, $6c, $53, $54, $55
	db $56, $00, $57, $58, $59, $5a, $00, $5b, $5c, $5d, $00, $5e
	db $5f, $60, $6d, $6e, $00, $63, $64, $65, $6f
.frame4
	db $03 ; bitmask
	db $70, $71, $72, $73, $00, $74, $75, $76, $77, $00, $78, $79
	db $7a, $00, $7b, $7c, $7d, $00, $7e, $7f, $80, $00, $81, $82
	db $83, $84, $85, $00, $86, $87, $88, $89, $8a
.frame5
	db $04 ; bitmask
	db $70, $71, $72, $73, $00, $74, $75, $76, $77, $8b, $8c, $00
	db $78, $79, $7a, $8d, $8e, $00, $7b, $7c, $7d, $00, $7e, $7f
	db $80, $8f, $00, $81, $82, $83, $84, $85, $00, $86, $87, $88
	db $89, $8a
.frame6
	db $05 ; bitmask
	db $70, $71, $72, $73, $90, $91, $00, $74, $75, $76, $77, $92
	db $93, $00, $78, $79, $7a, $00, $7b, $7c, $7d, $00, $7e, $7f
	db $80, $00, $81, $82, $83, $84, $94, $95, $00, $86, $87, $88
	db $89, $8a