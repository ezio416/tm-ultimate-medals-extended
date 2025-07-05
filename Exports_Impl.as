
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


    bool IsEditorValidation() {
        return MapData::validationMode;
    }

    bool HasIngameMedals() {
        return _hasIngameMedals();
    }

    uint GetAuthorMedal() {
        MedalWrapper@ m = MedalsList::getMedal('Author');
        if (m is null) {
            warn('Author medal not found, was it removed by another plugin?');
            return uint(-1);
        }
        return m.getMedalTime();
    }
    uint GetGoldMedal() {
        MedalWrapper@ m = MedalsList::getMedal('Gold');
        if (m is null) {
            warn('Gold medal not found, was it removed by another plugin?');
            return uint(-1);
        }
        return m.getMedalTime();
    }
    uint GetSilverMedal() {
        MedalWrapper@ m = MedalsList::getMedal('Silver');
        if (m is null) {
            warn('Silver medal not found, was it removed by another plugin?');
            return uint(-1);
        }
        return m.getMedalTime();
    }
    uint GetBronzeMedal() {
        MedalWrapper@ m = MedalsList::getMedal('Bronze');
        if (m is null) {
            warn('Bronze medal not found, was it removed by another plugin?');
            return uint(-1);
        }
        return m.getMedalTime();
    }


}