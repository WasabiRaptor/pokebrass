variant_dexentry: macro
    dbw \1, \2PokedexEntryPointers
endm


VariantPokedexEntryPointerTable:
    variant_dexentry GROUP_GENERATION_ONE, Kanto 
    variant_dexentry GROUP_GENERATION_TWO, Johto 
    variant_dexentry GROUP_GENERATION_THREE, Hoenn

	dbw -1,         PokedexDataPointerTable