
namespace MedalsList {
    array<MedalTime@> Medals = {};
    PbMedal@ pb = null;
    void addMedal(MedalTime@ medal) {
        Medals.InsertLast(medal);
        updated = false;
    }

    void onNewMap(const string &in uid) {
        for (uint i = 0; i < Medals.Length; i++) {
            Medals[i].onNewMap(uid);
        }
    }

    void checkOrder() {
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
                if (showDelta) {
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
