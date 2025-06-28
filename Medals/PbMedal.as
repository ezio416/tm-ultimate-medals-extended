
class PbMedal : UltimateMedalsExtended::IMedal {
    string GetIcon() override { return '\\$444' + Icons::Circle; }
    UltimateMedalsExtended::Config GetConfig() override {
        UltimateMedalsExtended::Config c;
        c.defaultName = 'Personal Best';
        c.nameColor = '\\$0ff';
        c.sortPriorty = 127;
        c.usePreviousIcon = true;
        c.usePreviousColor = true;
        c.shareIcon = false;
        c.allowUnset = true;
        return c;
    }

    // time of pb, uint(-1) for no pb yet
    uint medalTime = uint(-1);
    // if concept of pb is valid for this map (so not in editor)
    bool validMedalTime = false;

    void OnNewMap(const string&in uid) override {
        this.medalTime = uint(-1);

        CGameCtnApp@ app = GetApp();
        if (app.Editor is null) { 
            this.validMedalTime = true;
        } else {
            this.validMedalTime = false;
        }
    }

    // special function for pb
    bool updateIfNeeded(uint newPb, const string &in uid) {
        if (newPb == this.medalTime) {return false;}
        if ((newPb < this.medalTime) ^^ MapData::highBetter) {
            this.medalTime = newPb;
            return true;
        }
        return false;
    }

    bool HasMedalTime(const string&in uid) override {
        return this.validMedalTime;
    }
    uint GetMedalTime() override {
        return this.medalTime;
    }
}
