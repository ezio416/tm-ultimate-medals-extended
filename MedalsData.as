
namespace MedalsData {
    const string medalsDataFileName = IO::FromStorageFolder('medalsData.json');

    bool medalsDataChanged = false;

    /*
    * medals data (including medals from exports)
    * 'id' is default medal name (required if the medal has any data)
    * 'enabled' is if the medal is enabled
    * 'name' is the custom medal name
    */
    Json::Value@ medalsData;

    /* save/load functions */
    void loadMedalsData() {
        if (IO::FileExists(medalsDataFileName)) {
            @medalsData = Json::FromFile(medalsDataFileName);
        } else {
            @medalsData = Json::Parse('[{"id": "Auto Silver", "enabled": false}, {"id": "Auto Bronze", "enabled": false}]');
        }
    }
    void saveMedalsData() {
        if (medalsDataChanged) {
            Json::ToFile(medalsDataFileName, medalsData);   
        }
        medalsDataChanged = false;
    }

    /* utility functions */
    void _updateMedalsDataJson() {
        medalsDataChanged = true;
    }
    Json::Value@ _getOrAddMedalsData(const string &in medalId) {
        for (uint i = 0; i < medalsData.Length; i++) {
            if (medalsData[i]['id'] == medalId) {
                return medalsData[i];
            }
        }
        Json::Value@ md = Json::Object();
        md['id'] = medalId;
        medalsData.Add(md);
        return md;
    }

    /* update saved data functions (called when a medal changes its data) */

    // enables a medal if it has data saying its disabled (if no data, its enabled by default anyway)
    void enableMedal(const string &in medalId) {
        for (uint i = 0; i < medalsData.Length; i++) {
            if (medalsData[i]['id'] == medalId) {
                medalsData[i].Remove('enabled');
                _updateMedalsDataJson();
                return;
            }
        }
    }
    // disables a medal, creating medal data if needed
    void disableMedal(const string &in medalId) {
        Json::Value@ md = _getOrAddMedalsData(medalId);
        md['enabled'] = false;
        _updateMedalsDataJson();
    }

    // renames a medal, creating medal data if needed
    void renameMedal(const string &in medalId, const string &in name) {
        Json::Value@ md = _getOrAddMedalsData(medalId);
        if (name == medalId) {
            md.Remove('name');
        } else {
            md['name'] = name;
        }
        _updateMedalsDataJson();
    }


    /* get saved data functions (called when creating a new medal) */

    // gets the name for a medal
    string getMedalName(const string &in medalId) {
        for (uint i = 0; i < medalsData.Length; i++) {
            if (medalsData[i]['id'] == medalId) {
                if (medalsData[i].HasKey('name')) {
                    return medalsData[i]['name'];
                }
                break;
            }
        }
        return medalId;
    }
    // gets if a medal is enabled
    bool isMedalEnabled(const string &in medalId, bool startEnabled) {
        for (uint i = 0; i < medalsData.Length; i++) {
            if (medalsData[i]['id'] == medalId) {
                if (medalsData[i].HasKey('enabled')) {
                    return medalsData[i]['enabled'];
                }
                return startEnabled;
            }
        }
        return startEnabled;
    }
}

void OnSettingsSave(Settings::Section& section) {
    MedalsData::saveMedalsData();
}