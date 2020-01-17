"""Overpy 3.1.4"""

#!disableUnusedVars

#Global variables

#!declareGlobal heroList 0
#!declareGlobal timeCounter 1
#!declareGlobal gameIsAlmostDone 2
#!declareGlobal leaderboard 3
#!declareGlobal randomSectionOfMap 4
#!declareGlobal arenaMap1 5
#!declareGlobal arenaMap2 6
#!declareGlobal arenaMap3 7
#!declareGlobal arenaMap4 8


#Player variables

#!declarePlayer damageDone 0
#!declarePlayer damageDisplayPos 1
#!declarePlayer damageDisplayScale 2
#!declarePlayer damageDisplayText 3
#!declarePlayer nextObjective 4
#!declarePlayer killYourselfPunishment 5
#!declarePlayer heroIcon 6
#!declarePlayer heroSwapEffect 7


"""@Rule "10K Damage Gun Game v8.0.0"
@Event global
"""

@Rule "Disable bulit-in game mode & start timer variables {Game in progress GLOBAL}"
@Event global
if isGameInProgress():
    disableScoring()
    disableGamemodeCompletion()
    disableAnnouncer()
    disableMusic()
    pauseMatchTime()
    timeCounter = 0.001
    gameIsAlmostDone = false
    #hudSubheader([i for i in hostPlayer if "#Jokaes" == l"#{}".format(hostPlayer)], "svr load: {0} | svr avg: {1} | svr peak: {2}".format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), Position.TOP, -100, Color.LIME_GREEN, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader([player for player in getAllPlayers() if getPeakServerLoad() < 85], "svr load: {0} | svr avg: {1} | svr peak: {2}".format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), Position.TOP, -100, Color.LIME_GREEN, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader([player for player in getAllPlayers() if getPeakServerLoad() >= 85 and getPeakServerLoad() <= 170], "svr load: {0} | svr avg: {1} | svr peak: {2}".format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), Position.TOP, -100, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader([player for player in getAllPlayers() if getPeakServerLoad() > 170], "svr load: {0} | svr avg: {1} | svr peak: {2}".format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), Position.TOP, -100, Color.RED, HudReeval.VISIBILITY_AND_STRING)


@Rule "Damage track & display"
@Event playerDealtDamage
if victim != attacker and round(eventDamage) >= 1:
    eventPlayer.damageDone += eventDamage
    eventPlayer.setScore(eventPlayer.damageDone)
    eventPlayer.nextObjective = (floor(eventPlayer.damageDone / 1000) + 1) * 1000
    destroyInWorldText(eventPlayer.damageDisplayText)
    wait()
    eventPlayer.damageDisplayPos = victim.getEyePosition()
    eventPlayer.damageDisplayScale = eventDamage / 50
    if eventPlayer.damageDisplayScale >= 1:
        goto lbl_0
    eventPlayer.damageDisplayScale = 1
    lbl_0:
    if eventWasCriticalHit:
        goto lbl_1
    createInWorldText(eventPlayer, round(eventDamage), eventPlayer.damageDisplayPos, eventPlayer.damageDisplayScale, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    lbl_1:
    if not(eventWasCriticalHit):
        goto lbl_2
    createInWorldText(eventPlayer, round(eventDamage), eventPlayer.damageDisplayPos, eventPlayer.damageDisplayScale, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    lbl_2:
    eventPlayer.damageDisplayText = getLastCreatedText()


"""@Rule "Leaderboard {Reevaluation}"
@Event global
do:
    leaderboard = sorted(getAllPlayers(), key=lambda player: player.damageDone)
    wait(1)
while true
"""

"""@Rule "Leaderboard {HUD}"
@Event global
hudSubtext(getAllPlayers(), " ", Position.LEFT, -1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if leaderboard[0] != null], l"{} : {} : {}".format(heroIcon(leaderboard[0].getCurrentHero()), leaderboard[0], round(leaderboard[0].damageDone)), Position.LEFT, 11, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if leaderboard[1] != null], l"{} : {} : {}".format(heroIcon(leaderboard[1].getCurrentHero()), leaderboard[1], round(leaderboard[1].damageDone)), Position.LEFT, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if leaderboard[2] != null], l"{} : {} : {}".format(heroIcon(leaderboard[2].getCurrentHero()), leaderboard[2], round(leaderboard[2].damageDone)), Position.LEFT, 9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if leaderboard[3] != null], l"{} : {} : {}".format(heroIcon(leaderboard[3].getCurrentHero()), leaderboard[3], round(leaderboard[3].damageDone)), Position.LEFT, 8, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if leaderboard[4] != null], l"{} : {} : {}".format(heroIcon(leaderboard[4].getCurrentHero()), leaderboard[4], round(leaderboard[4].damageDone)), Position.LEFT, 7, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if leaderboard[5] != null], l"{} : {} : {}".format(heroIcon(leaderboard[5].getCurrentHero()), leaderboard[5], round(leaderboard[5].damageDone)), Position.LEFT, 6, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if leaderboard[6] != null], l"{} : {} : {}".format(heroIcon(leaderboard[6].getCurrentHero()), leaderboard[6], round(leaderboard[6].damageDone)), Position.LEFT, 5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if leaderboard[7] != null], l"{} : {} : {}".format(heroIcon(leaderboard[7].getCurrentHero()), leaderboard[7], round(leaderboard[7].damageDone)), Position.LEFT, 4, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if leaderboard[8] != null], l"{} : {} : {}".format(heroIcon(leaderboard[8].getCurrentHero()), leaderboard[8], round(leaderboard[8].damageDone)), Position.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if leaderboard[9] != null], l"{} : {} : {}".format(heroIcon(leaderboard[9].getCurrentHero()), leaderboard[9], round(leaderboard[9].damageDone)), Position.LEFT, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if leaderboard[10] != null], l"{} : {} : {}".format(heroIcon(leaderboard[10].getCurrentHero()), leaderboard[10], round(leaderboard[10].damageDone)), Position.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if leaderboard[11] != null], l"{} : {} : {}".format(heroIcon(leaderboard[11].getCurrentHero()), leaderboard[11], round(leaderboard[11].damageDone)), Position.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
"""

@Rule "Take away score if kill yourself {Punishment}"
@Event playerDied
if attacker == eventPlayer:
    eventPlayer.killYourselfPunishment = true
    smallMessage(eventPlayer, l"You Lose {} {}".format(round(eventDamage), "{0} (SUICIDE)".format(l"Points")))
    eventPlayer.damageDone -= eventDamage
    eventPlayer.setScore(eventPlayer.damageDone)
    eventPlayer.nextObjective = (floor(eventPlayer.damageDone / 1000) + 1) * 1000
    wait(0.032)
    eventPlayer.killYourselfPunishment = false


@Rule "Take away score if damage yourself {Punishment}"
@Event playerDealtDamage
if attacker == victim:
    wait()
    if eventPlayer.killYourselfPunishment:
        return
    if eventDamage <= 0.5:
        goto lbl_0
    smallMessage(eventPlayer, l"You Lose {} {}".format(round(eventDamage), "{0} (SELF-DAMAGE)".format(l"Points")))
    lbl_0:
    eventPlayer.damageDone -= eventDamage
    eventPlayer.setScore(eventPlayer.damageDone)
    eventPlayer.nextObjective = (floor(eventPlayer.damageDone / 1000) + 1) * 1000


@Rule "Victory"
@Event eachPlayer
if eventPlayer.damageDone >= 10000:
    bigMessage(getAllPlayers(), "GG. Thanks for playing {0}".format(iconString(Icon.HAPPY)))
    createEffect(getAllPlayers(), Effect.SPARKLES, Color.WHITE, eventPlayer, 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPARKLES, Color.YELLOW, eventPlayer, 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPARKLES, Color.GREEN, eventPlayer, 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPARKLES, Color.PURPLE, eventPlayer, 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPARKLES, Color.RED, eventPlayer, 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPARKLES, Color.BLUE, eventPlayer, 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(getAllPlayers(), "{0} {0}!".format(l"Winner"), eventPlayer, 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    for player in getAllPlayers():
        player.setGravity(0.1)
    declarePlayerVictory(eventPlayer)


@Rule "In assembling {Skip}"
@Event global
setMatchTime(0)


@Rule "In setup {Reset damageDone}"
@Event eachPlayer
if isInSetup():
    eventPlayer.damageDone = 0


@Rule "Hero List - 8 Random DPS + 1 Random Tank (5th) + 1 Random Support (10th) = 29 billons of lists"
@Event global
heroList = getDamageHeroes()
heroList = random.shuffle(heroList)
heroList = heroList.slice(0, 9)
heroList[4] = random.choice(getTankHeroes())
heroList.append(random.choice(getSupportHeroes()))


"""@Rule "Hero List - 10 Random DPS - Turrets abilities banned"
@Event global
heroList = getDamageHeroes()
heroList = random.shuffle(heroList)
heroList = heroList.slice(0, 10)
"""

"""@Rule "Hero List - 10 Random Heroes (ALL HEROES) - Turrets abilities banned"
@Event global
heroList = getAllHeroes()
heroList = random.shuffle(heroList)
heroList = heroList.slice(0, 10)
"""

@Rule "Preload Heroes"
@Event eachPlayer
eventPlayer.preloadHero(heroList)


@Rule "In Setup -> Starting Hero -> HeroList[0]"
@Event eachPlayer
if isInSetup():
    eventPlayer.startForcingHero(heroList[0])
    eventPlayer.nextObjective = 1000


@Rule "In Game in progress -> Starting Hero -> HeroList[0]"
@Event eachPlayer
if isGameInProgress():
    eventPlayer.startForcingHero(heroList[0])
    eventPlayer.nextObjective = 1000


@Rule "Start forcing next hero"
@Event eachPlayer
if eventPlayer.isAlive() and eventPlayer.getCurrentHero() != heroList[eventPlayer.nextObjective / 1000 - 1] and eventPlayer.damageDone > 0:
    eventPlayer.nextObjective = (floor(eventPlayer.damageDone / 1000) + 1) * 1000
    eventPlayer.startForcingHero(heroList[eventPlayer.nextObjective / 1000 - 1])
    smallMessage(eventPlayer, l"You Hero: {}".format(heroIcon(heroList[eventPlayer.nextObjective / 1000 - 1])))
    createInWorldText(getAllPlayers(), heroIcon(heroList[eventPlayer.nextObjective / 1000 - 1]), eventPlayer, 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.heroIcon = getLastCreatedText()
    wait(0.125)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.PURPLE, eventPlayer, 1)
    createEffect(getAllPlayers(), Effect.SPARKLES, Color.PURPLE, eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.heroSwapEffect = getLastCreatedEntity()
    wait(1.25)
    destroyInWorldText(eventPlayer.heroIcon)
    destroyEffect(eventPlayer.heroSwapEffect)


@Rule "in da hood TEXT"
@Event global
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() == heroList[0]], l"1 -> {} {}".format(heroIcon(heroList[0]), len(getPlayersOnHero(heroList[0], Team.ALL))), Position.RIGHT, 1, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() != heroList[0]], l"1 -> {} {}".format(heroIcon(heroList[0]), len(getPlayersOnHero(heroList[0], Team.ALL))), Position.RIGHT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() == heroList[1]], l"2 -> {} {}".format(heroIcon(heroList[1]), len(getPlayersOnHero(heroList[1], Team.ALL))), Position.RIGHT, 2, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() != heroList[1]], l"2 -> {} {}".format(heroIcon(heroList[1]), len(getPlayersOnHero(heroList[1], Team.ALL))), Position.RIGHT, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() == heroList[2]], l"3 -> {} {}".format(heroIcon(heroList[2]), len(getPlayersOnHero(heroList[2], Team.ALL))), Position.RIGHT, 3, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() != heroList[2]], l"3 -> {} {}".format(heroIcon(heroList[2]), len(getPlayersOnHero(heroList[2], Team.ALL))), Position.RIGHT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() == heroList[3]], l"4 -> {} {}".format(heroIcon(heroList[3]), len(getPlayersOnHero(heroList[3], Team.ALL))), Position.RIGHT, 4, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() != heroList[3]], l"4 -> {} {}".format(heroIcon(heroList[3]), len(getPlayersOnHero(heroList[3], Team.ALL))), Position.RIGHT, 4, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() == heroList[4]], l"5 -> {} {}".format(heroIcon(heroList[4]), len(getPlayersOnHero(heroList[4], Team.ALL))), Position.RIGHT, 5, Color.TURQUOISE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() != heroList[4]], l"5 -> {} {}".format(heroIcon(heroList[4]), len(getPlayersOnHero(heroList[4], Team.ALL))), Position.RIGHT, 5, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() == heroList[5]], l"6 -> {} {}".format(heroIcon(heroList[5]), len(getPlayersOnHero(heroList[5], Team.ALL))), Position.RIGHT, 6, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() != heroList[5]], l"6 -> {} {}".format(heroIcon(heroList[5]), len(getPlayersOnHero(heroList[5], Team.ALL))), Position.RIGHT, 6, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() == heroList[6]], l"7 -> {} {}".format(heroIcon(heroList[6]), len(getPlayersOnHero(heroList[6], Team.ALL))), Position.RIGHT, 7, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() != heroList[6]], l"7 -> {} {}".format(heroIcon(heroList[6]), len(getPlayersOnHero(heroList[6], Team.ALL))), Position.RIGHT, 7, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() == heroList[7]], l"8 -> {} {}".format(heroIcon(heroList[7]), len(getPlayersOnHero(heroList[7], Team.ALL))), Position.RIGHT, 8, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() != heroList[7]], l"8 -> {} {}".format(heroIcon(heroList[7]), len(getPlayersOnHero(heroList[7], Team.ALL))), Position.RIGHT, 8, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() == heroList[8]], l"9 -> {} {}".format(heroIcon(heroList[8]), len(getPlayersOnHero(heroList[8], Team.ALL))), Position.RIGHT, 9, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() != heroList[8]], l"9 -> {} {}".format(heroIcon(heroList[8]), len(getPlayersOnHero(heroList[8], Team.ALL))), Position.RIGHT, 9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() == heroList[9]], l"10 -> {} {}".format(heroIcon(heroList[9]), len(getPlayersOnHero(heroList[9], Team.ALL))), Position.RIGHT, 10, Color.TURQUOISE, HudReeval.VISIBILITY_AND_STRING)
hudSubtext([player for player in getAllPlayers() if player.getCurrentHero() != heroList[9]], l"10 -> {} {}".format(heroIcon(heroList[9]), len(getPlayersOnHero(heroList[9], Team.ALL))), Position.RIGHT, 10, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)


"""@Rule "in da hood HEADER"
@Event global
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() == heroList[0]], l"1 -> {} {}".format(heroIcon(heroList[0]), len(getPlayersOnHero(heroList[0], Team.ALL))), Position.RIGHT, 1, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() != heroList[0]], l"1 -> {} {}".format(heroIcon(heroList[0]), len(getPlayersOnHero(heroList[0], Team.ALL))), Position.RIGHT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() == heroList[1]], l"2 -> {} {}".format(heroIcon(heroList[1]), len(getPlayersOnHero(heroList[1], Team.ALL))), Position.RIGHT, 2, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() != heroList[1]], l"2 -> {} {}".format(heroIcon(heroList[1]), len(getPlayersOnHero(heroList[1], Team.ALL))), Position.RIGHT, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() == heroList[2]], l"3 -> {} {}".format(heroIcon(heroList[2]), len(getPlayersOnHero(heroList[2], Team.ALL))), Position.RIGHT, 3, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() != heroList[2]], l"3 -> {} {}".format(heroIcon(heroList[2]), len(getPlayersOnHero(heroList[2], Team.ALL))), Position.RIGHT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() == heroList[3]], l"4 -> {} {}".format(heroIcon(heroList[3]), len(getPlayersOnHero(heroList[3], Team.ALL))), Position.RIGHT, 4, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() != heroList[3]], l"4 -> {} {}".format(heroIcon(heroList[3]), len(getPlayersOnHero(heroList[3], Team.ALL))), Position.RIGHT, 4, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() == heroList[4]], l"5 -> {} {}".format(heroIcon(heroList[4]), len(getPlayersOnHero(heroList[4], Team.ALL))), Position.RIGHT, 5, Color.TURQUOISE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() != heroList[4]], l"5 -> {} {}".format(heroIcon(heroList[4]), len(getPlayersOnHero(heroList[4], Team.ALL))), Position.RIGHT, 5, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() == heroList[5]], l"6 -> {} {}".format(heroIcon(heroList[5]), len(getPlayersOnHero(heroList[5], Team.ALL))), Position.RIGHT, 6, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() != heroList[5]], l"6 -> {} {}".format(heroIcon(heroList[5]), len(getPlayersOnHero(heroList[5], Team.ALL))), Position.RIGHT, 6, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() == heroList[6]], l"7 -> {} {}".format(heroIcon(heroList[6]), len(getPlayersOnHero(heroList[6], Team.ALL))), Position.RIGHT, 7, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() != heroList[6]], l"7 -> {} {}".format(heroIcon(heroList[6]), len(getPlayersOnHero(heroList[6], Team.ALL))), Position.RIGHT, 7, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() == heroList[7]], l"8 -> {} {}".format(heroIcon(heroList[7]), len(getPlayersOnHero(heroList[7], Team.ALL))), Position.RIGHT, 8, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() != heroList[7]], l"8 -> {} {}".format(heroIcon(heroList[7]), len(getPlayersOnHero(heroList[7], Team.ALL))), Position.RIGHT, 8, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() == heroList[8]], l"9 -> {} {}".format(heroIcon(heroList[8]), len(getPlayersOnHero(heroList[8], Team.ALL))), Position.RIGHT, 9, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() != heroList[8]], l"9 -> {} {}".format(heroIcon(heroList[8]), len(getPlayersOnHero(heroList[8], Team.ALL))), Position.RIGHT, 9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() == heroList[9]], l"10 -> {} {}".format(heroIcon(heroList[9]), len(getPlayersOnHero(heroList[9], Team.ALL))), Position.RIGHT, 10, Color.TURQUOISE, HudReeval.VISIBILITY_AND_STRING)
hudHeader([player for player in getAllPlayers() if player.getCurrentHero() != heroList[9]], l"10 -> {} {}".format(heroIcon(heroList[9]), len(getPlayersOnHero(heroList[9], Team.ALL))), Position.RIGHT, 10, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
"""

@Rule "Time Counter - Add second"
@Event global
if isGameInProgress():
    do:
        setMatchTime(timeCounter)
        wait(1)
        timeCounter++
    while true


@Rule "Game is almost done"
@Event eachPlayer
if isGameInProgress() and eventPlayer.damageDone >= 9000 and not gameIsAlmostDone:
    gameIsAlmostDone = true
    enableAnnouncer()
    enableMusic()
    smallMessage(getAllPlayers(), "10K Damage Gun Game v8.0.0")
    wait(3.5)
    smallMessage(getAllPlayers(), "Created by Jokaes#2263")


@Rule "Next Objective {Next hero}"
@Event eachPlayer
if isGameInProgress() and eventPlayer.nextObjective <= 9000 and eventPlayer.nextObjective >= 0:
    setObjectiveDescription(eventPlayer, l"Deal {} Damage -> {}".format(floor(eventPlayer.nextObjective - eventPlayer.damageDone), heroIcon(heroList[eventPlayer.nextObjective / 1000])), HudReeval.VISIBILITY_AND_STRING)


@Rule "Next Objective {Win}"
@Event eachPlayer
if isGameInProgress() and eventPlayer.nextObjective == 10000:
    setObjectiveDescription(eventPlayer, l"Deal {} Damage -> You Win {}".format(floor(eventPlayer.nextObjective - eventPlayer.damageDone), iconString(Icon.HAPPY)), HudReeval.VISIBILITY_AND_STRING)


@Rule "Next Hero HUD"
@Event eachPlayer
hudSubheader(eventPlayer, l"Next Hero: {}".format(eventPlayer.nextObjective), Position.TOP, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


@Rule "Random section of the map"
@Event global
randomSectionOfMap = random.randint(1, 2)


"""@Rule "Always secundary map if exists"
@Event global
randomSectionOfMap = 2
"""

@Rule "Global init -Created by Beemoo"
@Event global
if getCurrentMap() == Map.Havana and randomSectionOfMap == 2:
    arenaMap1 = false
    arenaMap2 = vect(215, 35, -40)
    arenaMap3 = []
    arenaMap3.append(vect(227.5, 27.5, -57))
    arenaMap3.append(vect(227.5, 27.5, -40.5))
    arenaMap3.append(vect(227.5, 27.5, -25.5))
    arenaMap3.append(vect(218, 27.5, -16.5))
    arenaMap3.append(vect(204.83, 27.5, -16.5))
    arenaMap3.append(vect(191.17, 27.5, -20.78))
    arenaMap3.append(vect(181.6, 27.5, -30.1))
    arenaMap3.append(vect(171.19, 28.21, -42))
    arenaMap3.append(vect(171.19, 28.21, -55))
    arenaMap3.append(vect(185, 27.5, -64.6))
    arenaMap3.append(vect(197.6, 27.5, -64.59))
    arenaMap3.append(vect(210.2, 27.5, -64.59))
    arenaMap3.append(vect(222.6, 27.5, -64.59))
    arenaMap4 = len(arenaMap3) - 1
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, vect(184, -71.8, -46), 100, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    if not(arenaMap1):
        goto lbl_0
    createEffect(getAllPlayers(), Effect.ORB, Color.PURPLE, arenaMap2, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    lbl_0:


@Rule "Effect create loop -Created by Beemoo"
@Event global
if getCurrentMap() == Map.Havana and arenaMap1 and arenaMap4 > 0 and randomSectionOfMap == 2:
    do:
        wait(0.25)
        createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, arenaMap3[arenaMap4], 1.2, IconReeval.VISIBILITY)
        arenaMap4--
    while RULE_CONDITION


@Rule "No entry pillars (knock, tele) -Created by Beemoo"
@Event eachPlayer
if getCurrentMap() == Map.Havana and any([distance(i, eventPlayer) < 1.25 for i in arenaMap3]) and randomSectionOfMap == 2:
    wait(0.5)
    if not RULE_CONDITION:
        return
    eventPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), arenaMap2[0] + vect(0, 10, 0)), 12, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setStatusEffect(null, Status.STUNNED, 1)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, l"No Hiding!")
    wait(0.75)
    if not RULE_CONDITION:
        return
    eventPlayer.teleport(arenaMap2[0] + vect(random.randint(-8, 8), 0, random.randint(-19, 19)))


@Rule "No entry floor (OOB) -Created by Beemoo"
@Event eachPlayer
if getCurrentMap() == Map.Havana and eventPlayer.getPosition().y < 26.5 and eventPlayer.getPosition().y > 25 and randomSectionOfMap == 2:
    do:
        eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
        damage(eventPlayer, eventPlayer, 25)
        eventPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), arenaMap2[0] + vect(0, 10, 0)), 12, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.5)
    while RULE_CONDITION


@Rule "No entry OOB (spawn tele) -Created by Beemoo"
@Event eachPlayer
if getCurrentMap() == Map.Havana and eventPlayer.hasSpawned() and (eventPlayer.getPosition().x < 171 or eventPlayer.getPosition().x > 229 or eventPlayer.getPosition().z < -66 or eventPlayer.getPosition().z > -15) and randomSectionOfMap == 2:
    eventPlayer.teleport(arenaMap2 + vect(random.randint(-8, 8), 0, random.randint(-19, 19)))


"""@Rule "Score Debug (TEST)"
@Event eachPlayer
if eventPlayer.isHoldingButton(Button.INTERACT):
    eventPlayer.damageDone += 100
    eventPlayer.setScore(eventPlayer.damageDone)
    eventPlayer.nextObjective = (floor(eventPlayer.damageDone / 1000) + 1) * 1000
    eventPlayer.startForcingHero(heroList[eventPlayer.nextObjective / 1000 - 1])
    wait(0.25)
"""

"""@Rule "Dummys Summon (TEST)"
@Event eachPlayer
if eventPlayer.isCommunicating(Comms.HELLO):
    createDummy(heroList[0], Team.ALL, -1, eventPlayer.getPosition(), vect(0, 0, 0))
    #createDummy(heroList[0], Team.ALL, -1, eventPlayer.getPosition(), vect(0, 0, 0))
    #createDummy(heroList[0], Team.ALL, -1, eventPlayer.getPosition(), vect(0, 0, 0))
    #createDummy(heroList[0], Team.ALL, -1, eventPlayer.getPosition(), vect(0, 0, 0))
    #createDummy(heroList[0], Team.ALL, -1, eventPlayer.getPosition(), vect(0, 0, 0))
    #createDummy(heroList[0], Team.ALL, -1, eventPlayer.getPosition(), vect(0, 0, 0))
"""

"""@Rule "Dummy Aim Bot (TEST)"
@Event eachPlayer
if eventPlayer.isDummy():
    eventPlayer.startFacing(directionTowards(eventPlayer, getClosestPlayer(eventPlayer, getOppositeTeam(eventPlayer.getTeam()))), 10000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
"""

"""@Rule "Dummy Ult (TEST)"
@Event eachPlayer
if eventPlayer.isDummy() and eventPlayer.getUltCharge() == 100:
    eventPlayer.forceButtonPress(Button.ULTIMATE)
"""

@Rule "Game Mode Description v8.0.0"
@Event global
if isGameInProgress():
    hudSubtext(getAllPlayers(), "10K Damage Gun Game v8.0.0", Position.LEFT, -100, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), "{0} to {1} to swap to the {2}".format(l"Deal 10000 Damage", l"Win and 1000", l"Next Hero"), Position.LEFT, -99, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), "8 random DPS + 1 Tank (5th) + 1 Support (10th)", Position.LEFT, -98, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), "Created by Jokaes#2263", Position.LEFT, -97, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    smallMessage(getAllPlayers(), "10K Damage Gun Game v8.0.0")
    wait(3.5)
    smallMessage(getAllPlayers(), "{0} to {1} to swap to the {2}".format(l"Deal 10000 Damage", l"Win and 1000", l"Next Hero"))
    wait(3.5)
    smallMessage(getAllPlayers(), "8 random DPS + 1 Tank (5th) + 1 Support (10th)")
    wait(3.5)
    smallMessage(getAllPlayers(), "Created by Jokaes#2263")


@Rule "Game Mode Description for players who join"
@Event playerJoined
if isGameInProgress() and timeCounter >= 15:
    smallMessage(eventPlayer, "10K Damage Gun Game v8.0.0")
    wait(3.5)
    smallMessage(eventPlayer, "{0} to {1} to swap to the {2}".format(l"Deal 10000 Damage", l"Win and 1000", l"Next Hero"))
    wait(3.5)
    smallMessage(eventPlayer, "8 random DPS + 1 Tank (5th) + 1 Support (10th)")
    wait(3.5)
    smallMessage(eventPlayer, "Created by Jokaes#2263")


"""@Rule "10K Damage Gun Game v8.0.0"
@Event global
"""

"""@Rule "Created by Jokaes#2263"
@Event global
"""

