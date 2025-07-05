[Setting category="Window" name="Enable plugin window"]
bool showInterface = true;

[Setting category="Window" name="Show map name"]
bool showMapName = true;

[Setting category="Window" name="Show map author"]
bool showMapAuthor = true;

[Setting category="Window" name="Show map comment" description="An 'i' icon will appear if the map has a comment"]
bool showComment = true;

[Setting category="Window" name="Remove name colors"]
bool removeColors = false;

[Setting category="Window" name="Show column titles"]
bool showColumns = true;

[Setting category="Window" name="Show delta time"]
bool showDelta = true;

[Setting category="Window" name="Toggle with interface"]
bool requireInterface = false;

[Setting category="Window" name="Toggle with Openplanet overlay"]
bool requireOverlay = false;

[Setting category="Window" name="Show in validation" description="\\$ff0\\$z Currently doesn't update until you exit validation"]
bool showValidation = false;

[Setting category="Window" name="Show in replay editor"]
bool showReplayEditor = false;

[Setting category="Window" name="Location"]
vec2 windowPos = vec2(0, 170);

[Setting category="Window" name="Allow dragging"]
bool windowDrag = false;


// maybe custom font? Not sure if anyone uses that in ultimate medals

void RenderMenu() {
    if (UI::MenuItem("\\$db4" + Icons::Circle + "\\$z Ultimate Medals Extended", "", showInterface)) {
        showInterface = !showInterface;
    }
}

// window shown without table for one frame in order to clear table width bug
bool windowWasShownLastFrame = false;

void Render() {
    if (!showInterface) {
        windowWasShownLastFrame = false;
        return;
    }
    if (requireInterface && !UI::IsGameUIVisible()) {
        windowWasShownLastFrame = false;
        return;
    }
    if (requireOverlay && !UI::IsOverlayShown()) {
        windowWasShownLastFrame = false;
        return;
    }
    
    if (MapData::currentMap == '') {
        windowWasShownLastFrame = false;
        return;
    }
    CGameCtnApp@ app = GetApp();
    if (app.RootMap is null) {
        windowWasShownLastFrame = false;
        return;
    }

    if (!MedalsList::CheckRender()) {
        windowWasShownLastFrame = false;
        return;
    }

    if (windowDrag) {
        UI::SetNextWindowPos(int(windowPos.x), int(windowPos.y), UI::Cond::Once);
    } else {
        UI::SetNextWindowPos(int(windowPos.x), int(windowPos.y), UI::Cond::Always);
    }
    UI::SetNextWindowSize(0, 0, UI::Cond::Always);
    
    int windowFlags = UI::WindowFlags::NoTitleBar | UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize | UI::WindowFlags::NoDocking;
    if (!UI::IsOverlayShown()) {
            windowFlags |= UI::WindowFlags::NoInputs;
    }

    UI::Begin("Ultimate Medals Extended", windowFlags);
    windowPos = vec2(UI::GetWindowPos().x/UI::GetScale(), UI::GetWindowPos().y/UI::GetScale());

    if (!windowWasShownLastFrame) {
        windowWasShownLastFrame = true;
        UI::End();
        return;
    }

    if (showMapName || showMapAuthor) {
        UI::BeginGroup();
        if (UI::BeginTable("header", 1, UI::TableFlags::SizingFixedFit)) {
            if (showMapName) {
                UI::TableNextRow();
                UI::TableNextColumn();
                string name = app.RootMap.MapName;
                if (name == "") {
                    name = app.RootMap.MapInfo.NameForUi;
                }
                if (removeColors) {
                    UI::Text(Text::StripFormatCodes(name));
                } else {
                    UI::Text(Text::OpenplanetFormatCodes(name));
                }
                if (showComment && !showMapAuthor && app.RootMap.Comments.Length > 0) {
                    UI::SameLine();
                    UI::Text('\\$68f' + Icons::InfoCircle);
                }
            }
            if (showMapAuthor) {
                UI::TableNextRow();
                UI::TableNextColumn();
                if (removeColors) {
                    UI::TextDisabled('By ' + Text::StripFormatCodes(app.RootMap.AuthorNickName));
                } else {
                    UI::TextDisabled('By ' + Text::OpenplanetFormatCodes(app.RootMap.AuthorNickName));
                }
                if (showComment && app.RootMap.Comments.Length > 0) {
                    UI::SameLine();
                    UI::Text('\\$68f' + Icons::InfoCircle);
                }
            }
            UI::EndTable();
        }

        UI::EndGroup();

        if (showComment && app.RootMap.Comments.Length > 0 && UI::IsItemHovered()) {
            UI::BeginTooltip();
            UI::PushTextWrapPos(200);
            UI::TextWrapped(app.RootMap.Comments);
            UI::PopTextWrapPos();
            UI::EndTooltip();
        }
    }

    MedalsList::Render();

    UI::End();
    
}

[SettingsTab name="Medals"]
void RenderSettings() {
    MedalsList::RenderSettings();
}