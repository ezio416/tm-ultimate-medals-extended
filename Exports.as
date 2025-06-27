
namespace UltimateMedalsExtended {

    // Adds a medal. If a medal with that name already exists, it is overwritten
    import void addMedal(IMedal@ medal) from "MedalsList";

    // if a medal name already exists
    import bool hasMedal(const string &in defaultName) from "MedalsList";
}