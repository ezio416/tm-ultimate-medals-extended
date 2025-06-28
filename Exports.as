
namespace UltimateMedalsExtended {

    // Adds a medal. If a medal with that name already exists, it is overwritten
    import void AddMedal(IMedal@ medal) from "UltimateMedalsExtended";

    import bool RemoveMedal(const string &in defaultName) from "UltimateMedalsExtended";

    // if a medal name already exists
    import bool HasMedal(const string &in defaultName) from "UltimateMedalsExtended";
}