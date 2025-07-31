
namespace UltimateMedalsExtended {

    // Adds a medal. If a medal with that name already exists, it is overwritten
    import void AddMedal(IMedal@ medal) from "UltimateMedalsExtended";

    import bool RemoveMedal(const string &in defaultName) from "UltimateMedalsExtended";

    // if a medal name already exists
    import bool HasMedal(const string &in defaultName) from "UltimateMedalsExtended";

    // if a medal name is enabled
    import bool IsMedalEnabled(const string &in defaultName) from "UltimateMedalsExtended";
    
    /* 
     * exports for plugins which want to display in editor
     * and need to know the medal times from the current validation session (or before)
     */

    /* 
     * whether the current map is in editor validate mode
     * (and the setting to show in validation is enabled)
     */
    import bool IsEditorValidation() from "UltimateMedalsExtended";

    /* 
     * gets whether the ingame medals are currently valid/displayed
     * in normal play this should be always true
     * in editor validation, this is true if either the map was already validated or if there is a session pb
     */
    import bool HasIngameMedals() from "UltimateMedalsExtended";

    /*
     * gets the time currently displayed for author medal
     * only valid if HasIngameMedals returns true
     */
    import uint GetAuthorMedal() from "UltimateMedalsExtended";
    /*
     * gets the time currently displayed for gold medal
     * only valid if HasIngameMedals returns true
     */
    import uint GetGoldMedal() from "UltimateMedalsExtended";
    /*
     * gets the time currently displayed for silver medal
     * only valid if HasIngameMedals returns true
     */
    import uint GetSilverMedal() from "UltimateMedalsExtended";
    /*
     * gets the time currently displayed for bronze medal
     * only valid if HasIngameMedals returns true
     */
    import uint GetBronzeMedal() from "UltimateMedalsExtended";

}