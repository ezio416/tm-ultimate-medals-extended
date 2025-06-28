#if TMNEXT || MP4
class AuthorMedal : Medal {
    string GetIcon() override { return '\\$071' + Icons::Circle; }
    UltimateMedalsExtended::Config GetConfig() override {
        UltimateMedalsExtended::Config c;
        c.defaultName = 'Author';
        return c;
    }

    void OnNewMap(const string&in uid) override {
        this.medalTime = GetApp().RootMap.TMObjective_AuthorTime;
    }
}
#endif

class GoldMedal : Medal {
    string GetIcon() override { return '\\$db4' + Icons::Circle; }
    UltimateMedalsExtended::Config GetConfig() override {
        UltimateMedalsExtended::Config c;
        c.defaultName = 'Gold';
        return c;
    }

    void OnNewMap(const string&in uid) override {
        this.medalTime = GetApp().RootMap.TMObjective_GoldTime;
    }
}

class SilverMedal : Medal {
    string GetIcon() override { return '\\$899' + Icons::Circle; }
    UltimateMedalsExtended::Config GetConfig() override {
        UltimateMedalsExtended::Config c;
        c.defaultName = 'Silver';
        return c;
    }

    void OnNewMap(const string&in uid) override {
        this.medalTime = GetApp().RootMap.TMObjective_SilverTime;
    }
}

class BronzeMedal : Medal {
    string GetIcon() override { return '\\$964' + Icons::Circle; }
    UltimateMedalsExtended::Config GetConfig() override {
        UltimateMedalsExtended::Config c;
        c.defaultName = 'Bronze';
        return c;
    }

    void OnNewMap(const string&in uid) override {
        this.medalTime = GetApp().RootMap.TMObjective_BronzeTime;
    }
}