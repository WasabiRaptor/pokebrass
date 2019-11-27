add_special: MACRO
\1Special::
	dba \1
ENDM

SpecialsPointers::
	add_special WarpToSpawnPoint

; Communications
	add_special Special_SetBitsForLinkTradeRequest
	add_special Special_WaitForLinkedFriend
	add_special Special_CheckLinkTimeout
	add_special Special_TryQuickSave
	add_special Special_CheckBothSelectedSameRoom
	add_special Special_FailedLinkToPast
	add_special Special_CloseLink
	add_special WaitForOtherPlayerToExit
	add_special Special_SetBitsForBattleRequest
	add_special Special_TradeCenter
	add_special Special_Colosseum
	add_special Special_CableClubCheckWhichChris

; Map Events
	add_special BugContestJudging
	add_special CheckPartyFullAfterContest
	add_special ContestDropOffMons
	add_special ContestReturnMons
	add_special Special_GiveParkBalls
	add_special Special_CheckMagikarpLength
	add_special Special_MagikarpHouseSign
	add_special HealParty
	add_special PokemonCenterPC
	add_special Special_KrissHousePC
	add_special Special_DayCareMan
	add_special Special_DayCareLady
	add_special Special_DayCareManOutside
	add_special MoveDeletion
	add_special Special_BankOfMom
	add_special Special_MagnetTrain
	add_special SpecialNameRival
	add_special SpecialTrendyPhrase
	add_special Special_TownMap
	add_special MapRadio
	add_special Special_UnownPuzzle
	add_special Special_SlotMachine
	add_special Special_CardFlip
;	add_special Special_DummyNonfunctionalGameCornerGame
	add_special FadeOutPalettes
	add_special Special_FadeBlackQuickly
	add_special FadeInPalettes
	add_special Special_FadeInQuickly
	add_special Special_ReloadSpritesNoPalettes
	add_special ClearBGPalettes
	add_special UpdateTimePals
	add_special ClearTileMap
	add_special UpdateSprites
	add_special ReplaceKrisSprite
	add_special Special_GameCornerPrizeMonCheckDex
	add_special SpecialSeenMon
	add_special WaitSFX
	add_special PlayMapMusic
	add_special RestartMapMusic
	add_special HealMachineAnim
	add_special Special_SurfStartStep
	add_special Special_FindGreaterThanThatLevel ; unused
	add_special Special_FindAtLeastThatHappy ; unused
	add_special Special_FindThatSpecies
	add_special Special_FindThatSpeciesYourTrainerID
	add_special Special_DayCareMon1
	add_special Special_DayCareMon2
	add_special Special_SelectRandomBugContestContestants
	add_special Special_ActivateFishingSwarm
	add_special ToggleMaptileDecorations
	add_special ToggleDecorationsVisibility
	add_special SpecialGiveWobbuffet
	add_special SpecialReturnWobbuffet
	add_special Special_BillsGrandfather
	add_special SpecialCheckPokerus
	add_special Special_DisplayCoinCaseBalance
	add_special Special_DisplayMoneyAndCoinBalance
	add_special PlaceMoneyTopRight
	add_special Special_CheckForLuckyNumberWinners
	add_special Special_CheckLuckyNumberShowFlag
	add_special Special_ResetLuckyNumberShowFlag
	add_special Special_PrintTodaysLuckyNumber
	add_special Special_SelectApricornForKurt
	add_special SpecialNameRater
	add_special Special_DisplayLinkRecord
	add_special GetFirstPokemonHappiness
	add_special CheckFirstMonIsEgg
	add_special RandomPhoneRareWildMon
	add_special RandomPhoneWildMon
	add_special RandomPhoneMon
	add_special MapCallbackSprites_LoadUsedSpritesGFX
	;add_special PlaySlowCry
	add_special SpecialSnorlaxAwake
	add_special Special_YoungerHaircutBrother
	add_special Special_OlderHaircutBrother
	add_special Special_DaisyMassage
	add_special PlayCurMonCry
	add_special ProfOaksPCBoot
	add_special Special_CianwoodPhotograph
	add_special InitRoamMons
	add_special Special_FadeOutMusic
	add_special Diploma

; Crystal
	add_special GiveOddEgg
	add_special SoftReset
	add_special Special_MoveTutor
	add_special SpecialOmanyteChamber
	add_special Special_DisplayUnownWords
	add_special SpecialHo_OhChamber
	add_special Special_CelebiShrineEvent
	add_special CheckCaughtCelebi
	add_special SpecialStatsJudge
	add_special SpecialBuenasPassword
	add_special TeachDratiniExtremeSpeed
	add_special Special_SampleKenjiBreakCountdown
	add_special SpecialBeastsCheck
	add_special SpecialBirdsCheck
	add_special SpecialDuoCheck
	add_special SpecialMonCheck
	add_special Special_SetPlayerPalette
	add_special AskRememberPassword
	add_special LoadMapPalettes

; Battle Tower
	add_special Special_BattleTower_FindChallengeLevel
	add_special Special_BattleTower_Battle
	add_special Special_BattleTower_ResetTrainersSRAM
	add_special Special_BattleTower_CheckNewSaveFile
	add_special Special_BattleTower_GetChallengeState
	add_special Special_BattleTower_SetChallengeState
	add_special Special_BattleTower_MarkNewSaveFile
	add_special Special_BattleTower_SaveLevelGroup
	add_special Special_BattleTower_LoadLevelGroup
	add_special Special_BattleTower_CheckSaveFileExistsAndIsYours
	add_special Special_BattleTower_MaxVolume
	add_special Special_BattleTower_BeginChallenge
	add_special Special_BattleTower_LoadOpponentTrainerAndPokemonsWithOTSprite
	add_special Special_BattleTower_CheckForRules
	add_special Special_BattleTower_MainMenu
	add_special Special_BattleTower_Fade

; Polished Crystal
	add_special SaveOptions
	add_special WonderTrade
	add_special RespawnOneOffs
	add_special SpecialGiveShinyDitto
	add_special GiveMystriEgg
	add_special Special_ReiBlessing
	add_special BillBoxSwitchCheck
	add_special BillBoxSwitch
	add_special HealPartyEvenForNuzlocke
	add_special SaveMusic
	add_special RestoreMusic
	add_special DeleteSavedMusic
	add_special CheckIfTrendyPhraseIsLucky
	add_special TeachMagikarpDragonRage
	add_special Special_ChooseItem
	add_special GetGourmetManiacPrice
	add_special GetOreManiacPrice
	add_special GetFossilManiacPrice
	add_special Give_hMoneyTemp
	add_special SetLastPartyMonBall
	add_special CheckForSurfingPikachu
	add_special InitializeHiddenGrotto
	add_special GetHiddenGrottoContents
	add_special EmptiedHiddenGrotto
	add_special Special_HiddenPowerGuru
	add_special Special_GetOvercastIndex
	add_special Special_SetCopycatPalette

	add_special SpecialNone
