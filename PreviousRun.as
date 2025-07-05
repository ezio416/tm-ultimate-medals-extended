namespace PreviousRun {
    uint session = uint(-1);
    uint previous = uint(-1);

    void onNewMap() {
        session = uint(-1);
        previous = uint(-1);
    }

#if TMNEXT
    uint checkFinished() {
        if (MapData::gamemode.Contains('Royal')) {
            return checkFinishedRoyal();
        }
        CGameCtnApp@ app = GetApp();
        CGamePlayground@ playground = cast<CGamePlayground>(app.CurrentPlayground);
        if (playground.GameTerminals.Length > 0 && (playground.GameTerminals[0].UISequence_Current == CGamePlaygroundUIConfig::EUISequence::Finish || playground.GameTerminals[0].UISequence_Current == CGamePlaygroundUIConfig::EUISequence::UIInteraction)) {
            CSmArenaRulesMode@ playgroundScript = cast<CSmArenaRulesMode>(app.PlaygroundScript);
            if (playgroundScript !is null) {
                CSmPlayer@ player = cast<CSmPlayer>(playground.GameTerminals[0].GUIPlayer);
                if (player !is null) {
                    CGameGhostScript@ ghost = playgroundScript.Ghost_RetrieveFromPlayer(cast<CSmScriptPlayer>(player.ScriptAPI));
                    if (ghost !is null) {
                        uint score = uint(-1);
                        if (MapData::gamemode.Contains('Race')) {
                            if (ghost.Result.Time > 0 && ghost.Result.Time < uint(-1)) {
                                score = ghost.Result.Time;
                            }
                        } else if (MapData::gamemode.Contains('Stunt')) {
                            // note this gets session PB (Nando). And seems equivalent to .StuntsScore
                            score = ghost.Result.Score;
                        } else if (MapData::gamemode.Contains('Platform')) {
                            score = ghost.Result.NbRespawns;
                        }
                        playgroundScript.DataFileMgr.Ghost_Release(ghost.Id);
                        return score;
                    }
                }
            }
        }
        return uint(-1);
    }

    array<uint> royalTimes = {0, 0, 0, 0};
    uint checkFinishedRoyal() {
        // finish data type is already royal
        CGameCtnApp@ app = GetApp();
        CSmArenaClient@ playground = cast<CSmArenaClient>(app.CurrentPlayground);
        if (playground.GameTerminals.Length > 0 && (playground.GameTerminals[0].UISequence_Current == CGamePlaygroundUIConfig::EUISequence::Finish || playground.GameTerminals[0].UISequence_Current == CGamePlaygroundUIConfig::EUISequence::UIInteraction)) {
            CSmArenaRulesMode@ playgroundScript = cast<CSmArenaRulesMode>(app.PlaygroundScript);
            if (playgroundScript !is null) {
                CSmPlayer@ player = cast<CSmPlayer>(playground.GameTerminals[0].GUIPlayer);
                if (player !is null && player.CurrentStoppedRespawnLandmarkIndex >= 0 && player.CurrentStoppedRespawnLandmarkIndex < playground.Arena.MapLandmarks.Length) {
                    CGameGhostScript@ ghost = playgroundScript.Ghost_RetrieveFromPlayer(cast<CSmScriptPlayer>(player.ScriptAPI));
                    if (ghost !is null) {
                        uint score = uint(-1);
                        if (ghost.Result.Time > 0 && ghost.Result.Time < uint(-1)) {
                            score = ghost.Result.Time;
                        }
                        playgroundScript.DataFileMgr.Ghost_Release(ghost.Id);
                        uint section = playground.Arena.MapLandmarks[player.CurrentStoppedRespawnLandmarkIndex].Order;
                        if (0 < section && 5 > section) {
                            royalTimes[section - 1] = score;
                            for (uint i = section; i < 4; i++) {
                                royalTimes[i] = uint(-1);
                            }
                        } else if (section == 5) {
                            return royalTimes[0] + royalTimes[1] + royalTimes[2] + royalTimes[3] + score;
                        } else {
                            print('invalid royal section: ' + section);
                        }
                    }
                }
            }
        }
        return uint(-1);
    }
#elif MP4
    uint checkFinished() {
        CGameCtnApp@ app = GetApp();
        CGameCtnPlayground@ playground = cast<CGameCtnPlayground@>(app.CurrentPlayground);
        if (playground.PlayerRecordedGhost !is null) {
            if (MapData::gamemode.Contains('Race') || MapData::gamemode.Contains('Obstacle')) {
                return playground.PlayerRecordedGhost.RaceTime;
            } else if (MapData::gamemode.Contains('Stunt')) {
                return playground.PlayerRecordedGhost.StuntsScore;
            } else if (MapData::gamemode.Contains('Platform')) {
                return playground.PlayerRecordedGhost.NbRespawns;
            }
        }
        return uint(-1);
    }
#endif

    void Update() {
        uint finish = checkFinished();
        if (finish == uint(-1)) {return;}
        previous = finish;
        if (MapData::highBetter ^^ previous < session) {
            session = previous;
        }
    }

}