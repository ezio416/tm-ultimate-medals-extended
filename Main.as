
void OnSettingsChanged() {
    windowWasShownLastFrame = false;
}

bool hasCalledMain = false;

void Main() {
    if (hasCalledMain) {return;}
    hasCalledMain = true;

    MedalsData::loadMedalsData();

    MedalsList::addMedal(PbMedal());

    MedalsList::addMedal(BronzeMedal());
    MedalsList::addMedal(SilverMedal());
    MedalsList::addMedal(GoldMedal());
    MedalsList::addMedal(AuthorMedal());
#if TURBO
    MedalsList::addMedal(SuperBronzeMedal());
    MedalsList::addMedal(SuperSilverMedal());
    MedalsList::addMedal(SuperGoldMedal());
    MedalsList::addMedal(SuperTrackmasterMedal());
#endif
    MedalsList::addMedal(AutoBronzeMedal());
    MedalsList::addMedal(AutoSilverMedal());
    MedalsList::addMedal(AutoGoldMedal());

    MedalsList::addMedal(Session());
    MedalsList::addMedal(Previous());

}

void Update(float dt) {
    MapData::Update();
}

CGameCtnChallenge@ getMap() {
    CGameCtnApp@ app = GetApp();
#if TMNEXT || MP4
    return app.RootMap;
#elif TURBO
    return app.Challenge;
#endif
}
