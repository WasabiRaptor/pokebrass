; rst vectors

SECTION "rst0", ROM0
	di
	jp Start

DisappearUser::
	farjp _DisappearUser

SECTION "rst8", ROM0
	jp RstFarCall


SECTION "rst10", ROM0
	ldh [hROMBank], a
	ld [MBC5RomBank], a
	ret

SECTION "rst18", ROM0
	jp _AddNTimes

_de_::
	push de
	ret

FarCopyWRAM::
	call StackCallInWRAMBankA

SECTION "rst20", ROM0
	jp _CopyBytes

BattleRandom::
; Handles all RNG calls in the battle engine, allowing
; link battles to remain in sync using a shared PRNG.
	farjp _BattleRandom

_hl_::
	jp hl

SECTION "rst28", ROM0
	jp _Jumptable

DoItemEffect::
	farjp _DoItemEffect

SECTION "rst30", ROM0
	jp _Predef

PushWindow::
	farjp _PushWindow

SECTION "rst38", ROM0
	rst $38

ExitMenu::
	push af
	farcall _ExitMenu
	pop af
	ret
