#if TMNEXT || MP4
class AuthorMedal : MedalTime {
    AuthorMedal() {
        super('Author', '\\$071' + Icons::Circle);
    }

    void onNewMap(const string&in uid) override {
        MedalTime::onNewMap(uid);

        setMedalTime(GetApp().RootMap.TMObjective_AuthorTime, uid);
    }
}
#endif

class GoldMedal : MedalTime {
    GoldMedal() {
        super('Gold', '\\$db4' + Icons::Circle);
    }

    void onNewMap(const string&in uid) override {
        MedalTime::onNewMap(uid);

        setMedalTime(GetApp().RootMap.TMObjective_GoldTime, uid);
    }
}

class SilverMedal : MedalTime {
    SilverMedal() {
        super('Silver', '\\$899' + Icons::Circle);
    }

    void onNewMap(const string&in uid) override {
        MedalTime::onNewMap(uid);

        setMedalTime(GetApp().RootMap.TMObjective_SilverTime, uid);
    }
}

class BronzeMedal : MedalTime {
    BronzeMedal() {
        super('Bronze', '\\$964' + Icons::Circle);
    }

    void onNewMap(const string&in uid) override {
        MedalTime::onNewMap(uid);

        setMedalTime(GetApp().RootMap.TMObjective_BronzeTime, uid);
    }
}