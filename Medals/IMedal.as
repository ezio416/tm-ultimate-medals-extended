namespace UltimateMedalsExtended {
    shared class Config {
        // the medal identifier, required. Custom name settings are done through UME settings.
        string defaultName = '';

        // if the medal is enabled in UME by default
        bool startEnabled = true;

        // custom color applied to the medal (used for pb)
        string nameColor = '';

        /*
         * if this medal wins ties for equal times
         * most medals are 63
         * pb medal is 127 (since if pb is equal to a medal then it obtains it)
         * records should be 191 (since tied records don't beat them)
         */
        uint8 sortPriorty = 63;

        // use the icon shape from the previous medal if any (otherwise its own icon) (used for pb)
        bool usePreviousIcon = false;
        // use the color from the previous medal if any (otherwise its own)
        bool usePreviousColor = false;

        // if this medal should be included when a usePrevious medal is looking for the previous medal
        bool shareIcon = true;

        // if this medal can have an 'unset' but still vislble value, using uint(-1), such as pb before first finish
        bool allowUnset = false;

    }


    shared interface IMedal {
        // get the color and icon used for the medal icon
        string GetIcon();
        
        /*
        * the config used for the medal
        * called once when adding the medal
        */
        Config GetConfig();

        /*
        *  called when loading a new map in case you aren't automatically starting your own api requests
        * also called when a medal is changed to enabled, if it had not been called for this map
        */
        void OnNewMap(const string &in uid);

        /*
        * whether the medal has a time for the current map
        * this is called every frame so for time-intensive medals it is recommended to save it
        */
        bool HasMedalTime(const string &in uid);

        // gets the medal's time for the current map
        uint GetMedalTime();

    }
}