
namespace UltimateMedalsExtended {
    
    void AddMedal(IMedal@ medal) {
        MedalsList::addMedal(medal);
    }

    bool RemoveMedal(const string &in defaultName) {
        return MedalsList::removeMedal(defaultName);
    }

    bool HasMedal(const string &in defaultName) {
        return MedalsList::hasMedal(defaultName);
    }
}