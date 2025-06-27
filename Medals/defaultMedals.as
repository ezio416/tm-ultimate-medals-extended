
class AutoGoldMedal : DefaultMedal {
    string defaultName { get override { return 'Auto Gold'; }};
    string icon { get override { return '\\$db4' + Icons::Circle; }};

    void OnNewMap(const string&in uid) override {
        this.validMedal = false;
        CGameCtnChallenge@ rootmap = GetApp().RootMap;
        if (MapData::getGamemode().Contains('Stunt')) {
            this.medalTime = uint(Math::Floor(float(rootmap.TMObjective_AuthorTime) * 0.085f) * 10.f);
        } else if (MapData::getGamemode().Contains('Platform')) {
            this.medalTime = rootmap.TMObjective_AuthorTime + 3;
        } else {
            this.medalTime = uint((Math::Floor(float(rootmap.TMObjective_AuthorTime) * 0.00106f) + 1.f) * 1000.f);
        }
        if (this.medalTime != rootmap.TMObjective_GoldTime) {
            this.validMedal = true;
        }
    }
}

class AutoSilverMedal : DefaultMedal {
    string defaultName { get override { return 'Auto Silver'; }};
    string icon { get override { return '\\$899' + Icons::Circle; }};

    void OnNewMap(const string&in uid) override {
        this.validMedal = false;
        CGameCtnChallenge@ rootmap = GetApp().RootMap;
        if (MapData::getGamemode().Contains('Stunt')) {
            this.medalTime = uint(Math::Floor(float(rootmap.TMObjective_AuthorTime) * 0.06f) * 10.f);
        } else if (MapData::getGamemode().Contains('Platform')) {
            this.medalTime = rootmap.TMObjective_AuthorTime + 10;
        } else {
            this.medalTime = uint((Math::Floor(float(rootmap.TMObjective_AuthorTime) * 0.0012f) + 1.f) * 1000.f);
        }
        if (this.medalTime != rootmap.TMObjective_SilverTime) {
            this.validMedal = true;
        }
    }
}

class AutoBronzeMedal : DefaultMedal {
    string defaultName { get override { return 'Auto Bronze'; }};
    string icon { get override { return '\\$964' + Icons::Circle; }};

    void OnNewMap(const string&in uid) override {
        this.validMedal = false;
        CGameCtnChallenge@ rootmap = GetApp().RootMap;
        if (MapData::getGamemode().Contains('Stunt')) {
            this.medalTime = uint(Math::Floor(float(rootmap.TMObjective_AuthorTime) * 0.037f) * 10.f);
        } else if (MapData::getGamemode().Contains('Platform')) {
            this.medalTime = rootmap.TMObjective_AuthorTime + 30;
        } else {
            this.medalTime = uint((Math::Floor(float(rootmap.TMObjective_AuthorTime) * 0.0015f) + 1.f) * 1000.f);
        }
        if (this.medalTime != rootmap.TMObjective_BronzeTime) {
            this.validMedal = true;
        }
    }
}