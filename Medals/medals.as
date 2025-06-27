#if TMNEXT || MP4
class AuthorMedal : Medal {
    string defaultName { get override { return 'Author'; }};
    string icon { get override { return '\\$071' + Icons::Circle; }};

    void OnNewMap(const string&in uid) override {
        this.medalTime = GetApp().RootMap.TMObjective_AuthorTime;
    }
}
#endif

class GoldMedal : Medal {
    string defaultName { get override { return 'Gold'; }};
    string icon { get override { return '\\$db4' + Icons::Circle; }};

    void OnNewMap(const string&in uid) override {
        this.medalTime = GetApp().RootMap.TMObjective_GoldTime;
    }
}

class SilverMedal : Medal {
    string defaultName { get override { return 'Silver'; }};
    string icon { get override { return '\\$899' + Icons::Circle; }};

    void OnNewMap(const string&in uid) override {
        this.medalTime = GetApp().RootMap.TMObjective_SilverTime;
    }
}

class BronzeMedal : Medal {
    string defaultName { get override { return 'Bronze'; }};
    string icon { get override { return '\\$964' + Icons::Circle; }};

    void OnNewMap(const string&in uid) override {
        this.medalTime = GetApp().RootMap.TMObjective_BronzeTime;
    }
}