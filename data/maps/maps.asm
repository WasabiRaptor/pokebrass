map: MACRO
	; label, tileset, permission, location, music, phone service flag, time of day, fishing group
\1_MapHeader:
	db BANK(\1_SecondMapHeader), \2, \3
	dw \1_SecondMapHeader
	db \4, \5
	dn \6, \7
	db \8
ENDM


MapGroupPointers::
; pointers to the first map of each map group
	dw MapGroup_CableClub
	dw MapGroup_StartingTown
	dw MapGroup_Overworld
	dw MapGroup_MysteryDungeon

MapGroup_CableClub:
	map PokeCenter2F, TILESET_POKECENTER, INDOOR, SPECIAL_MAP, MUSIC_POKEMON_CENTER, 1, PALETTE_DAY, FISHGROUP_SHORE
	map TradeCenter, TILESET_GATE, INDOOR, SPECIAL_MAP, MUSIC_CHERRYGROVE_CITY, 1, PALETTE_DAY, FISHGROUP_SHORE
	map Colosseum, TILESET_GATE, INDOOR, SPECIAL_MAP, MUSIC_CHERRYGROVE_CITY, 1, PALETTE_DAY, FISHGROUP_SHORE
	map HiddenTreeGrotto, TILESET_FOREST, CAVE, SPECIAL_MAP, MUSIC_HIDDEN_GROTTO_B2W2, 1, PALETTE_NITE, FISHGROUP_SHORE
	map HiddenCaveGrotto, TILESET_CAVE, CAVE, SPECIAL_MAP, MUSIC_HIDDEN_GROTTO_B2W2, 1, PALETTE_NITE, FISHGROUP_SHORE

MapGroup_StartingTown:
	map KrissHouse1F, TILESET_INVAR_HOUSE, INDOOR, NEW_BARK_TOWN, MUSIC_NEW_BARK_TOWN, 0, PALETTE_DAY, FISHGROUP_SHORE
	map KrissHouse2F, TILESET_INVAR_HOUSE, INDOOR, NEW_BARK_TOWN, MUSIC_NEW_BARK_TOWN, 0, PALETTE_DAY, FISHGROUP_SHORE
	map DayCare, TILESET_INVAR_HOUSE, INDOOR, ROUTE_34, MUSIC_AZALEA_TOWN, 1, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Overworld:
	map DanielsTown, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Bridge, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map AsaokaCity, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

	map RouteNE1, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Crevasse, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map RouteNE2, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

	map KubotaTown, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

	map RouteW1, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map RouteW2, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

	map AshPlains1, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map AshPlains2, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

	map BreguetRuins, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

	map RouteS, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Swamp, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map RouteSW, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

	map Hetzeltron, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

	map RouteSE1, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map RouteSE2, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map RouteSE3, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

	map HattoriVillage, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

	map Lake1, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Lake2, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Lake3, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

	map RouteFakeExit, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map RouteFakeExitLoop, TILESET_INVAR, TOWN, SPECIAL_MAP, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

MapGroup_MysteryDungeon:
	map MysteryDungeonNorthSouthEastWest, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND

	map MysteryDungeonNorthSouthEast, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map MysteryDungeonNorthSouthWest, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map MysteryDungeonNorthEastWest, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map MysteryDungeonSouthEastWest, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND

	map MysteryDungeonNorthSouth, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map MysteryDungeonEastWest, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND

	map MysteryDungeonNorthEast, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map MysteryDungeonNorthWest, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map MysteryDungeonSouthEast, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map MysteryDungeonSouthWest, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND

	map MysteryDungeonNorth, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map MysteryDungeonSouth, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map MysteryDungeonEast, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map MysteryDungeonWest, TILESET_INVAR, ROUTE, SPECIAL_MAP, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
