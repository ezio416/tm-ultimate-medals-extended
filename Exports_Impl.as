
namespace UltimateMedalsExtended {
    
    void addMedal(IMedal@ medal) {
        MedalsList::addMedal(medal);
    }

    bool removeMedal(const string &in defaultName) {
        return MedalsList::removeMedal(defaultName);
    }

    bool hasMedal(const string &in defaultName) {
        return MedalsList::hasMedal(defaultName);
    }
}