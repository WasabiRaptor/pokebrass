PaintingPalettes:

if !DEF(MONOCHROME)
Ho_OhPaintingPalette:      INCLUDE "gfx/paintings/ho_oh_painting.pal"
LugiaPaintingPalette:     INCLUDE "gfx/paintings/lugia_painting.pal"
BellTowerPaintingPalette: INCLUDE "gfx/paintings/bell_tower_painting.pal"
KabutoPuzzlePalette:      INCLUDE "gfx/paintings/kabuto_puzzle.pal"
OmanytePuzzlePalette:     INCLUDE "gfx/paintings/omanyte_puzzle.pal"
AerodactylPuzzlePalette:  INCLUDE "gfx/paintings/aerodactyl_puzzle.pal"
Ho_OhPuzzlePalette:        INCLUDE "gfx/paintings/ho_oh_puzzle.pal"
else
rept NUM_PAINTINGS
	MONOCHROME_RGB_FOUR
endr
endc
