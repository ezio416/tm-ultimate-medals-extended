
abstract class Medal : IMedal {
    // string defaultName { get; };
    string defaultName { get { return ''; }};
    string icon { get { return ''; }};
    uint medalTime;
    
    // would be abstract if that existed in angelscript
    void OnNewMap(const string &in uid) override {}

    bool HasMedalTime(const string &in uid) override {
        return true;
    }
    uint GetMedalTime(const string&in uid) override {
        return this.medalTime;
    }
}

abstract class DefaultMedal : Medal {
    bool validMedal = false;

    bool HasMedalTime(const string&in uid) override {
        return validMedal;
    }
}
