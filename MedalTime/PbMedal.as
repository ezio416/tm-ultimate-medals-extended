
class PbMedal : MedalTime {
    PbMedal() {
        super('Personal Best', '\\$444' + Icons::Circle);
    }

    void onNewMap(const string&in uid) override {
        MedalTime::onNewMap(uid);

        // when in editor (map or replay etc.), no pb
        CGameCtnApp@ app = GetApp();
        if (app.Editor !is null) { return; }

        // in a map; pb will be checked in update if it exists so set to default (no pb) for now
        setMedalTime(uint(-1), uid);
    }

    // special function for pb
    bool updateIfNeeded(uint newPb, const string &in uid) {
        if (newPb == this.medalTime) {return false;}
        if (newPb < this.medalTime ^^ this.isHighBetter()) {
            this.updateMedalTime(newPb, uid);
            return true;
        }
        return false;
    }

    string formatDelta() override {
        return '';
    }

    void RenderRow() override {
        if (!this.enabled) {return;}
        bool valid;
        uint time = this.getMedalTime(valid);
        UI::TableNextRow();
        UI::TableNextColumn();
        int i = MedalsList::Medals.Find(this);
        if (i < int(MedalsList::Medals.Length) - 1) {
            UI::Text(MedalsList::Medals[i+1].icon);
        } else {
            UI::Text(this.icon);
        }
        UI::TableNextColumn();
        UI::Text('\\$0ff' + this.name);
        UI::TableNextColumn();
        if (time != uint(-1)) {
            UI::Text('\\$0ff' + this.formatTime(time));
        } else {
            UI::Text('\\$0ff' + EMPTYTIME);
        }

        if (showDelta) {
            UI::TableNextColumn();
            UI::Text(this.formatDelta());
        }
    }
}
