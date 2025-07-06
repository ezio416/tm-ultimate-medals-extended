
void OnSettingsChanged() {
    windowWasShownLastFrame = false;
}

void Main() {
    MedalsData::loadMedalsData();

    MedalsList::addMedal(PbMedal());

    MedalsList::addMedal(BronzeMedal());
    MedalsList::addMedal(SilverMedal());
    MedalsList::addMedal(GoldMedal());
#if TMNEXT || MP4
    MedalsList::addMedal(AuthorMedal());
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