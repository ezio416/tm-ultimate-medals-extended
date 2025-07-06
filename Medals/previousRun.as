
class Previous : UltimateMedalsExtended::IMedal {
    UltimateMedalsExtended::Config GetConfig() override {
        UltimateMedalsExtended::Config c;
        c.defaultName = 'Previous';
        c.icon = '\\$444' + Icons::ClockO;
        c.nameColor = '\\$aff';
        c.sortPriorty = 125;
        c.usePreviousColor = true;
        c.shareIcon = false;
        c.allowUnset = true;
        c.startEnabled = false;
        return c;
    }

    // if previous run is displayed for this map (so not in replay editor)
    bool validMedalTime = false;

    void UpdateMedal(const string&in uid) override {
        CGameCtnApp@ app = GetApp();
        if ((app.Editor is null || MapData::validationMode)
#if TMNEXT
            && app.Network.ClientManiaAppPlayground !is null
#endif
            ) { 
                this.validMedalTime = true;
        } else {
            this.validMedalTime = false;
        }
    }

    bool HasMedalTime(const string&in uid) override {
        if (MapData::validationMode && PreviousRun::session == uint(-1)) {return false;}
        return this.validMedalTime && (!MedalsList::pb.enabled || this.GetMedalTime() != MedalsList::pb.cacheTime) && (!MedalsList::session.enabled || this.GetMedalTime() != MedalsList::session.cacheTime);
    }
    uint GetMedalTime() override {
        return PreviousRun::previous;
    }
}

class Session : UltimateMedalsExtended::IMedal {
    UltimateMedalsExtended::Config GetConfig() override {
        UltimateMedalsExtended::Config c;
        c.defaultName = 'Session';
        c.icon = '\\$444' + Icons::ClockO;
        c.nameColor = '\\$8ff';
        c.sortPriorty = 127;
        c.usePreviousColor = true;
        c.shareIcon = false;
        c.allowUnset = true;
        c.startEnabled = false;
        return c;
    }

    // if session pb is displayed for this map (so not in editor)
    bool validMedalTime = false;

    void UpdateMedal(const string&in uid) override {
        CGameCtnApp@ app = GetApp();
        if (app.Editor is null || MapData::validationMode
#if TMNEXT
            && app.Network.ClientManiaAppPlayground !is null
#endif
            ) { 
                this.validMedalTime = true;
        } else {
            this.validMedalTime = false;
        }
    }

    bool HasMedalTime(const string&in uid) override {
        if (MapData::validationMode) {
            return this.validMedalTime && MapData::validated && (this.GetMedalTime() == uint(-1) || (MapData::highBetter ^^ this.GetMedalTime() > GetApp().RootMap.TMObjective_AuthorTime));
        }
        return this.validMedalTime && (!MedalsList::pb.enabled || this.GetMedalTime() != MedalsList::pb.cacheTime);
    }
    uint GetMedalTime() override {
        return PreviousRun::session;
    }
}