bool updated = false;
const string EMPTYTIME = '--:--.---';

abstract class MedalTime {
    // the default display name used for the medal
    // (this is also used as a unique identifier to avoid duplicating medals if a dependancy adds a medal twice. In this case, the matching MedalTime will be overwritten)
    string defaultName;

    // the color and image used for the medal icon
    string icon;

    // the medal time for this medal on the current map
    uint medalTime;

    // whether this medal has a valid time on the current map yet
    // will be false if waiting for an api request
    // if this is false, the medal will be hidden
    bool validMedalTime = false;

    // if pb is equal to a medal, it should be sorted a specific way
    // by default, this is 
    bool isPb;

    // medal data (duplicate of medalsData)
    bool enabled;
    string name;


    MedalTime(const string &in defaultName, const string &in icon) {
        this.defaultName = defaultName;
        this.icon = icon;
        this.enabled = MedalsData::isMedalEnabled(defaultName);
        this.name = MedalsData::getMedalName(this.defaultName);
        this.isPb = defaultName == 'Personal Best';
    }

    /*
     * if the 'medal' relies on paid access features
     * this should return the result of Openplanet's relevant permissions function
     */
    bool HasPermission() {
        return true;
    }

    /*
     * tries to get the cached medal time for the current map
     * &out valid - if this time is valid
     * (may be false initially on a new map for medals that rely on api requests)
     */
    uint getMedalTime(bool &out valid) final {
        valid = this.validMedalTime;
        return this.medalTime;
    }

    /*
     * Called for every active MedalTime when the map changes
     * overrides should call MedalTime::onNewMap(uid)) to clear valid from the previous map
     * - may then call setMedalTime with the new value,
     * - or call startnew on a function that calls an api and passes the result to setMedalTime
     * - or nothing if updateMedalTime is called dynamically
     * - or nothing (when the medal is invalid)
     */
    void onNewMap(const string &in uid) {
        this.validMedalTime = false;
    }

    /*
     * sets the medal for the current map
     * should be called once the medal has been determined, either in onNewMap directly or in async threads
     * the medal will be hidden on the map until this is called
     */
    void setMedalTime(uint time, const string &in uid) final {
        if (uid != MapData::currentMap) {
            // this may happen if you switch map while an api call is still running
            warn('Setting the medal time for a previous map');
            return;
        }
        if (validMedalTime) {
            if (time == this.medalTime) {
                warn('Setting the medal time for a map twice');
                return;
            } else {
                throw('Attempting to set the medal time for a map twice');
            }
        }
        this.validMedalTime = true;
        this.medalTime = time;
        updated = true;
    }
    /*
     * updates the medal for the current map
     * may be called multiple times on the same map, for example world record medal
     */
    void updateMedalTime(uint time, const string &in uid) final {
        if (uid != MapData::currentMap) {
            // this may happen if you switch map while an api call is still running
            warn('Setting the medal time for a previous map');
            return;
        }
        this.validMedalTime = true;
        this.medalTime = time;
        updated = true;
    }

    /*
     * whether higher times are better in the current map's gamemode
     */
    bool isHighBetter() final {
        return MapData::highBetter;
    }

    /*
     * compare function to compare 2 medals.
     * if they are equal but one is pb, then pb will be 'better'
     * unset pb will always be 'worse'
     */
    int opCmp(MedalTime@ other) final {
        if (this.isPb && this.medalTime == uint(-1)) {
            // this is pb with no time so should be last
            return this.isHighBetter() ? -1 : 1;
        }
        if (other.isPb && other.medalTime == uint(-1)) {
            // other is pb with no time so should be last
            return this.isHighBetter() ? 1 : -1;
        }

        if (this.isHighBetter()) {
            if (this.medalTime < other.medalTime) {
                return 1;
            } else if (this.medalTime > other.medalTime) {
                return -1;
            }
        } else {
            if (this.medalTime > other.medalTime) {
                return 1;
            } else if (this.medalTime < other.medalTime) {
                return -1;
            }
        }
        if (this.isPb) {
            return 1;
        } else if (other.isPb) {
            return -1;
        } else {
            return this.defaultName.opCmp(other.defaultName);
        }
    }

    string formatTime(uint time) {
        string t = Time::Format(time);
        if (t.Length == 8) {
            t = '0'+t;
        }
        return t;
    }
    string formatDelta() {
        bool pbValid;
        uint pbTime = MedalsList::pb.getMedalTime(pbValid);
        if (!pbValid || pbTime == uint(-1)) {
            return '\\$777' + EMPTYTIME;
        }
        string color = '';
        if (pbTime == this.medalTime) {
            color = '\\$777';
        } else if ((pbTime > this.medalTime) ^^ this.isHighBetter()) {
            color = '\\$f77';
        } else {
            color = '\\$77f';
        }
        return color + this.formatTime(this.medalTime - pbTime);
    }

    void RenderRow() {
        if (!this.enabled) {return;}
        bool valid;
        uint time = this.getMedalTime(valid);
        if (!valid) {return;}
        UI::TableNextRow();
        UI::TableNextColumn();
        UI::Text(this.icon);
        UI::TableNextColumn();
        UI::Text(this.name);
        UI::TableNextColumn();
        UI::Text(this.formatTime(time));

        if (showDelta) {
            UI::TableNextColumn();
            UI::Text(this.formatDelta());
        }
    }

    void RenderSettings() final {
        UI::TableNextRow();
        UI::TableNextColumn();
        UI::Text(this.defaultName);

        UI::TableNextColumn();
        UI::SetNextItemWidth(200.f);
        string newname = UI::InputText('##na:'+this.defaultName, this.name);
        if (newname != this.name) {
            this.name = newname;
            MedalsData::renameMedal(this.defaultName, this.name);
        }

        UI::TableNextColumn();
        bool newenabled = UI::Checkbox('##en:'+this.defaultName, this.enabled);
        if (newenabled != this.enabled) {
            this.enabled = newenabled;
            if (this.enabled) {
                MedalsData::enableMedal(this.defaultName);
            } else {
                MedalsData::disableMedal(this.defaultName);
            }
        }
    }
}
