namespace MapData {

    bool highBetter = false;
    string currentMap = '';

    void updateHighBetter() {
        CGameCtnApp@ app = GetApp();
        // technically not accurate on maps edited with external tools, could check current gamemode instead
        highBetter = app.RootMap.MapStyle.EndsWith('stunt');
    }

    uint _nextUpdate = 0;

    void Update() {
        CGameCtnApp@ app = GetApp();
        CSmArenaClient@ playground = cast<CSmArenaClient>(GetApp().CurrentPlayground);
        
        if (app.RootMap is null) {
            currentMap = '';
        } else if (!showValidation && app.Editor !is null || (app.Editor !is null && (playground is null || playground.Arena is null))) {
            currentMap = '';
        } else if (app.RootMap.IdName != currentMap) {
            currentMap = app.RootMap.IdName;
            updateHighBetter();
            MedalsList::onNewMap(currentMap);
        }
        
        if (currentMap == '') {return;}

        // check if pb needs updating
        // to save performance, only check for pb every half a second
        if (_nextUpdate > app.TimeSinceInitMs) {return;}
        _nextUpdate = app.TimeSinceInitMs + 500;

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
            MedalsList::pb.updateMedalTime(scoreMgr.Map_GetRecord_v2(userId, currentMap, "PersonalBest", "", "TimeAttack", ""), currentMap);
        }
#elif MP4
        if (network.TmRaceRules !is null && network.TmRaceRules.ScoreMgr !is null) {
            // this method only works in solo
            CGameScoreAndLeaderBoardManagerScript@ scoreMgr = network.ClientManiaAppPlayground.ScoreMgr;
            MedalsList::pb.updateMedalTime(scoreMgr.Map_GetRecord(network.PlayerInfo.Id, currentMap, ""), currentMap);
        } else {
            // on servers
            
            // todo: maybe do whatever Ultimate Medals does with local replays

            // check session pb
            CGamePlayground@ playground = app.CurrentPlayground;
            if (playground !is null &&
                playground.GameTerminals.Length > 0 &&
                cast<CTrackManiaPlayer>(playground.GameTerminals[0].GUIPlayer) !is null &&
                cast<CTrackManiaPlayer>(playground.GameTerminals[0].GUIPlayer).Score !is null) {
                    uint sessionPb = uint(cast<CTrackManiaPlayer>(playground.GameTerminals[0].GUIPlayer).Score.BestTime);
                    if (sessionPb >= 0) {
                        MedalsList::pb.updateIfNeeded(sessionPb, currentMap);
                    }
            }
        }
#elif TURBO
        // todo (I don't have turbo to test this)
#endif

    }
}

