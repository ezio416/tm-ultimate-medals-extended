

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

}

void Update(float dt) {
    MapData::Update();
}