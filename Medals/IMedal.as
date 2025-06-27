
shared interface IMedal {
    // the default display name used for the medal
    // (this is also used as a unique identifier to avoid duplicating medals if a dependancy adds a medal twice. In this case, the matching MedalWrapper will be overwritten)
    // custom name settings are handled for you
    string defaultName { get; };

    // the color used for the medal icon
    string icon { get; };

    // called when loading a new map in case you aren't automatically starting your own api requests
    // also called when a medal is changed to enabled, if it had not been called for this map
    void OnNewMap(const string &in uid);

    // whether the medal has a time for the current map
    // this is called every frame so for time-intensive medals it is recommended to save it
    bool HasMedalTime(const string &in uid);
    // gets the medal's time for the current map
    uint GetMedalTime();

}