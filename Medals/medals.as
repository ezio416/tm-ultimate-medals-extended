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
}