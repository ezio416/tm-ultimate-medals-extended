
namespace MedalsList {
    array<MedalWrapper@> Medals = {};
    MedalWrapper@ pb = null;
    
    void addMedal(IMedal@ medal) {
        MedalWrapper@ mt = MedalWrapper(medal);
        if (mt.isPb) {
            @pb = mt;
        }
        for (uint i = 0; i < Medals.Length; i++) {
            if (Medals[i].medal.defaultName == medal.defaultName) {
                Medals[i] = mt;
                return;
            }
        }
        Medals.InsertLast(mt);
    }
    bool hasMedal(const string &in defaultName) {
        for (uint i = 0; i < Medals.Length; i++) {
            if (Medals[i].medal.defaultName == defaultName) {
                return true;
            }
        }
        return false;
    }
    bool removeMedal(const string &in defaultName) {
        for (uint i = 0; i < Medals.Length; i++) {
            if (Medals[i].medal.defaultName == defaultName) {
                Medals.RemoveAt(i);
                return true;
            }
        }
        return false;
    }


    void onNewMap(const string &in uid) {
        for (uint i = 0; i < Medals.Length; i++) {
            Medals[i].onNewMap(uid);
        }
    }

    void checkOrder() {
        for (uint i = 0; i < Medals.Length; i++) {
            Medals[i].refreshMedal(MapData::currentMap);
        }
        if (updated) {
            updated = false;
            Medals.SortAsc();
        }
    }

    void Render() {
        checkOrder();

        int numcols = 3;
        if (showDelta) {
            numcols++;
        }
        if (UI::BeginTable("medals", numcols, UI::TableFlags::SizingFixedFit)) {
            if (showColumns) {
                UI::TableNextRow();
                UI::TableNextColumn();
                // icon
                UI::TableNextColumn();
                UI::Text("Medal");
                UI::TableNextColumn();
                UI::Text("Time");
                if (showDelta && pb.hasMedalTime()) {
                    UI::TableNextColumn();
                    UI::Text("Delta");
                }
            }
            for (uint i = 0; i < Medals.Length; i++) {
                Medals[i].RenderRow();
            }

            UI::EndTable();
        }
    }
    
    void RenderSettings() {
        UI::BeginTable("settings", 3, UI::TableFlags::SizingFixedFit);
        UI::TableNextRow();
        UI::TableNextColumn();
        UI::Text('Medal');
        UI::TableNextColumn();
        UI::Text('Display Name');
        UI::TableNextColumn();
        UI::Text('Enabled');

        for (uint i = 0; i < Medals.Length; i++) {
            Medals[i].RenderSettings();
        }
        UI::EndTable();
    }
}
