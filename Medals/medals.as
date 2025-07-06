#if TMNEXT || MP4
class AuthorMedal : Medal {
    UltimateMedalsExtended::Config GetConfig() override {
        UltimateMedalsExtended::Config c;
        c.defaultName = 'Author';
        c.icon = '\\$071' + Icons::Circle;
        return c;
    }

    void UpdateMedal(const string&in uid) override {
        this.medalTime = GetApp().RootMap.TMObjective_AuthorTime;
    }
    uint GetMedalTime() override {
        if (MapData::validationMode) {
            if (MapData::validated) {
                if (PreviousRun::session == uint(-1) || (MapData::highBetter ^^ this.medalTime < PreviousRun::session)) {
                    return this.medalTime;
                }
            }
            return PreviousRun::session;
        }
        return this.medalTime;
    }
}
#endif

class GoldMedal : Medal {
    UltimateMedalsExtended::Config GetConfig() override {
        UltimateMedalsExtended::Config c;
        c.defaultName = 'Gold';
        c.icon = '\\$db4' + Icons::Circle;
        return c;
    }

    void UpdateMedal(const string&in uid) override {
        this.medalTime = GetApp().RootMap.TMObjective_GoldTime;
    }
    uint GetMedalTime() override {
        if (MapData::validationMode) {
            if (MapData::validated) {
                if (PreviousRun::session == uint(-1) || (MapData::highBetter ^^ this.medalTime < PreviousRun::gold)) {
                    return this.medalTime;
                }
            }
            return PreviousRun::gold;
        }
        return this.medalTime;
    }
}

class SilverMedal : Medal {
    UltimateMedalsExtended::Config GetConfig() override {
        UltimateMedalsExtended::Config c;
        c.defaultName = 'Silver';
        c.icon = '\\$899' + Icons::Circle;
        return c;
    }

    void UpdateMedal(const string&in uid) override {
        this.medalTime = GetApp().RootMap.TMObjective_SilverTime;
    }
    uint GetMedalTime() override {
        if (MapData::validationMode) {
            if (MapData::validated) {
                if (PreviousRun::session == uint(-1) || (MapData::highBetter ^^ this.medalTime < PreviousRun::silver)) {
                    return this.medalTime;
                }
            }
            return PreviousRun::silver;
        }
        return this.medalTime;
    }
}

class BronzeMedal : Medal {
    UltimateMedalsExtended::Config GetConfig() override {
        UltimateMedalsExtended::Config c;
        c.defaultName = 'Bronze';
        c.icon = '\\$964' + Icons::Circle;
        return c;
    }

    void UpdateMedal(const string&in uid) override {
        this.medalTime = GetApp().RootMap.TMObjective_BronzeTime;
    }
    uint GetMedalTime() override {
        if (MapData::validationMode) {
            if (MapData::validated) {
                if (PreviousRun::session == uint(-1) || (MapData::highBetter ^^ this.medalTime < PreviousRun::bronze)) {
                    return this.medalTime;
                }
            }
            return PreviousRun::bronze;
        }
        return this.medalTime;
    }
}