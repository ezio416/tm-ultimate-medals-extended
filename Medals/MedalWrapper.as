bool updated = false;
const string EMPTYTIME = '--:--.---';

class MedalWrapper {
    IMedal@ medal;

    // if this medal is the pb (it will show a color based off others)
    bool isPb;

    // medal data (duplicate of medalsData)
    bool enabled;
    string name;

    uint cacheTime = 0;
    bool validCacheTime = false;

    string enabledMapCache = '';

    MedalWrapper(IMedal@ medal) {
        @this.medal = medal;
        this.enabled = MedalsData::isMedalEnabled(this.medal.defaultName);
        this.name = MedalsData::getMedalName(this.medal.defaultName);
        this.isPb = cast<PbMedal>(this.medal) !is null;
    }


    // called when loading a new map in case you aren't automatically starting your own api requests
    void onNewMap(const string &in uid) {
        if (!this.enabled) {return;}
        this.enabledMapCache = uid;
        this.medal.OnNewMap(uid);
    }
    // called when a medal is enabled, to check if it needs to call onNewMap
    void onEnable() {
        if (this.enabledMapCache != MapData::currentMap) {
            this.onNewMap(MapData::currentMap);
        }
    }


    // refresh function called to refresh medals, to check if sorting is needed, before each medal is then accessed in render
    void refreshMedal(const string &in uid) {
        if (!this.enabled) {return;}
        this.validCacheTime = this.medal.HasMedalTime(uid);
        if (this.validCacheTime) {
            uint newmedal = this.medal.GetMedalTime();
            if (newmedal != cacheTime) {
                updated = true;
                this.cacheTime = newmedal;
            }
        } else {
            this.cacheTime = 0;
        }
    }
    bool hasMedalTime() {
        return this.validCacheTime;
    }
    uint getMedalTime() {
        return this.cacheTime;
    }

    /*
     * compare function to compare 2 medals.
     * if they are equal but one is pb, then pb will be 'better'
     * unset pb will always be 'worse'
     */
    int opCmp(MedalWrapper@ other) final {
        if (!this.validCacheTime) {
            if (!other.validCacheTime) {
                return 0;
            }
            return -1;
        } else if (!other.validCacheTime) {
            return 1;
        }

        if (this.isPb && this.cacheTime == uint(-1)) {
            // this is pb with no time so should be last
            return 1;
        }
        if (other.isPb && other.cacheTime == uint(-1)) {
            // other is pb with no time so should be last
            return -1;
        }

        if (MapData::highBetter) {
            if (this.cacheTime < other.cacheTime) {
                return 1;
            } else if (this.cacheTime > other.cacheTime) {
                return -1;
            }
        } else {
            if (this.cacheTime > other.cacheTime) {
                return 1;
            } else if (this.cacheTime < other.cacheTime) {
                return -1;
            }
        }
        if (this.isPb) {
            return 1;
        } else if (other.isPb) {
            return -1;
        } else {
            return this.medal.defaultName.opCmp(other.medal.defaultName);
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
        if (this.isPb) {return '';}
        bool pbValid = MedalsList::pb.hasMedalTime();
        if (!pbValid) {
            // this should be checked before delta column is created
            return '';
        }
        uint pbTime = MedalsList::pb.getMedalTime();
        if (pbTime == uint(-1)) {
            return '\\$777' + EMPTYTIME;
        }

        string color = '';
        if (pbTime == this.cacheTime) {
            color = '\\$777';
        } else if ((pbTime > this.cacheTime) ^^ MapData::highBetter) {
            color = '\\$f77';
        } else {
            color = '\\$77f';
        }
        return color + this.formatTime(this.cacheTime - pbTime);
    }

    void RenderRow() {
        if (!this.enabled) {return;}
        if (!this.hasMedalTime()) {return;}
        UI::TableNextRow();
        UI::TableNextColumn();
        if (this.isPb) {
            int i = MedalsList::Medals.Find(this);
            if (i < int(MedalsList::Medals.Length) - 1) {
                UI::Text(MedalsList::Medals[i+1].medal.icon);
            } else {
                UI::Text(this.medal.icon);
            }
        } else {
            UI::Text(this.medal.icon);
        }
        UI::TableNextColumn();
        if (this.isPb) {
            UI::Text('\\$0ff' + this.name);
        } else {
            UI::Text(this.name);
        }
        UI::TableNextColumn();
        if (this.isPb) {
            if (this.cacheTime != uint(-1)) {
                UI::Text('\\$0ff' + this.formatTime(this.cacheTime));
            } else {
                UI::Text('\\$0ff' + EMPTYTIME);
            }
        } else {
            UI::Text(this.formatTime(this.cacheTime));
        }

        if (showDelta && MedalsList::pb.hasMedalTime()) {
            UI::TableNextColumn();
            UI::Text(this.formatDelta());
        }
    }

    void RenderSettings() final {
        UI::TableNextRow();
        UI::TableNextColumn();
        UI::Text(this.medal.defaultName);

        UI::TableNextColumn();
        UI::SetNextItemWidth(200.f);
        string newname = UI::InputText('##na:'+this.medal.defaultName, this.name);
        if (newname != this.name) {
            this.name = newname;
            MedalsData::renameMedal(this.medal.defaultName, this.name);
        }

        UI::TableNextColumn();
        bool newenabled = UI::Checkbox('##en:'+this.medal.defaultName, this.enabled);
        if (newenabled != this.enabled) {
            this.enabled = newenabled;
            if (this.enabled) {
                MedalsData::enableMedal(this.medal.defaultName);
                this.onEnable();
            } else {
                MedalsData::disableMedal(this.medal.defaultName);
            }
        }
    }
}
