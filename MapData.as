namespace MapData {

    bool highBetter = false;
    string gamemode = '';

    string currentMap = '';
    bool validationMode = false;

    void updateGamemode() {
        CGameCtnApp@ app = GetApp();
        gamemode = cast<CTrackManiaNetworkServerInfo@>(app.Network.ServerInfo).CurGameModeStr;
        if (gamemode == "") {
            gamemode = app.RootMap.MapType;
        }

        highBetter = gamemode.Contains('Stunt');
    }

#if TMNEXT
    uint _nextUpdate = 0;
#else
    uint64 _nextUpdate = 0;
#endif

    void Update() {
        CGameCtnApp@ app = GetApp();
        
        if (app.RootMap is null) {
            currentMap = '';
            return;
        }
#if TMNEXT
        CSmArenaClient@ playground = cast<CSmArenaClient>(app.CurrentPlayground);
#elif MP4
        CGamePlayground@ playground = app.CurrentPlayground;
#elif TURBO

#endif
        CGameCtnEditorFree@ editor = cast<CGameCtnEditorFree>(app.Editor);
        if (!showValidation && editor !is null || (editor !is null && (playground is null || playground.GameTerminals.Length == 0))) {
            currentMap = '';
            return;
        }
        if (showValidation && editor !is null) {
            CSmEditorPluginMapType@ pluginMapType = cast<CSmEditorPluginMapType>(editor.PluginMapType);
#if MP4
            CTmEditorPluginMapType@ pluginMapType2 = cast<CTmEditorPluginMapType>(editor.PluginMapType);
#endif
            if ((pluginMapType is null
                 || (pluginMapType.ValidationStatus != CGameEditorPluginMapMapType::EValidationStatus::Validated ||
                pluginMapType.Mode.ClientManiaAppUrl.Contains('RaceTest')))
#if MP4
                && (pluginMapType2 is null
                 || (pluginMapType2.ValidationStatus != CGameEditorPluginMapMapType::EValidationStatus::Validated ||
                pluginMapType2.Mode.ClientManiaAppUrl.Contains('RaceTest')))
#endif
                ) {
                    currentMap = '';
                    return;
            }
        }
#if TMNEXT
        CGameEditorMediaTracker@ replay = cast<CGameEditorMediaTracker>(app.Editor);
#elif MP4
        CGameCtnMediaTracker@ replay = cast<CGameCtnMediaTracker>(app.Editor);
#elif TURBO

#endif
        if (!showReplayEditor && replay !is null) {
            currentMap = '';
            return;
        }
        if (showReplayEditor && replay !is null && 
            app.RootMap.MapInfo.Kind == 6) { // unnamed enum - in progress
                currentMap = '';
                return;
        }

        if (app.Editor !is null && editor is null && replay is null) {
            // unknown editor e.g. skin editor, not enabled
            currentMap = '';
            return;
        }

        if (app.RootMap.IdName != currentMap) {
            currentMap = app.RootMap.IdName;
            updateGamemode();
            MedalsList::onNewMap(currentMap);
        }

        // check if pb needs updating
        // to save performance, only check for pb every half a second
#if TMNEXT
        if (_nextUpdate > app.TimeSinceInitMs) {return;}
        _nextUpdate = app.TimeSinceInitMs + 500;
#else
        if (_nextUpdate > Time::Now) {return;}
        _nextUpdate = Time::Now + 500;
#endif

        if (MedalsList::pb is null || !MedalsList::pb.enabled) {return;}
        
        if (showReplayEditor && replay !is null) {
            // replay editor doesn't load until after first entering map, so pb needs to re-detect that it is now invalid
            MedalsList::pb.medal.UpdateMedal(currentMap);
        }

        if (app.Editor !is null) {
            // in editor, no pb
            return;
        }
        CTrackManiaNetwork@ network = cast<CTrackManiaNetwork>(app.Network);
#if TMNEXT
        if (network.ClientManiaAppPlayground !is null) {
            CGameUserManagerScript@ userMgr = network.ClientManiaAppPlayground.UserMgr;
            MwId userId;
            if (userMgr.Users.Length > 0) {
                userId = userMgr.Users[0].Id;
            } else {
                userId.Value = uint(-1);
            }

            CGameScoreAndLeaderBoardManagerScript@ scoreMgr = network.ClientManiaAppPlayground.ScoreMgr;
            string gamemodeid = 'TimeAttack';
            if (gamemode.Contains('Stunt')) {
                gamemodeid = 'Stunt';
            } else if (gamemode.Contains('Platform')) {
                gamemodeid = 'Platform';
            } else if (gamemode.Contains('Royal')) {
                return;
            }
            cast<PbMedal>(MedalsList::pb.medal).updateIfNeeded(scoreMgr.Map_GetRecord_v2(userId, currentMap, "PersonalBest", "", gamemodeid, ""), currentMap);
        }
#elif MP4
        if (network.TmRaceRules !is null && network.TmRaceRules.ScoreMgr !is null) {
            // this method only works in solo
            CGameScoreAndLeaderBoardManagerScript@ scoreMgr = network.TmRaceRules.ScoreMgr;
            cast<PbMedal>(MedalsList::pb.medal).updateIfNeeded(scoreMgr.Map_GetRecord(network.PlayerInfo.Id, currentMap, ""), currentMap);
        } else {
            // on servers
            
            // todo: maybe do whatever Ultimate Medals does with local replays

            // check session pb
            if (// already checked playground is not null and nonempty gameterminal
                cast<CTrackManiaPlayer>(playground.GameTerminals[0].GUIPlayer) !is null &&
                cast<CTrackManiaPlayer>(playground.GameTerminals[0].GUIPlayer).Score !is null) {
                    uint sessionPb = uint(cast<CTrackManiaPlayer>(playground.GameTerminals[0].GUIPlayer).Score.BestTime);
                    if (sessionPb >= 0) {
                        cast<PbMedal>(MedalsList::pb.medal).updateIfNeeded(sessionPb, currentMap);
                    }
            }
        }
#elif TURBO
        // todo (I don't have turbo to test this)
#endif

    }
}

