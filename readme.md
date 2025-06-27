
# Ultimate Medals Extended
## wow another medals plugin
Unlike Ultimate Medals, (which only shows ingame medals) and Ultimate Medals++ (which has to code in any extra medals it shows), Ultimate Medals Extended is designed so that each medal plugin can add a medal to it. This way, it can automatically support any new medal plugin that is created.

### Builtin medals:
- Personal Best
- Author
- Gold
- Silver
- Bronze
- Default Gold
- Default Silver (disabled)
- Default Bronze (disabled)
### Supporting plugins:


## Exports
The exports from Ultimate Medals Extended are defined in Shared.as  
and the IMedal interface is defined and documented in Medals/IMedal.as

### Example usage as a dependency
In this example, the value of `exampleMedal` is set inside example medal plugin and is 0 when not avaliable.  
And it uses an internal variable `currentUID` for the map it has current example medal data for

```
#if DEPENDENCY_ULTIMATEMEDALSEXTENDED

class ExampleMedal : UltimateMedalsExtended::IMedal {
    string defaultName { get override { return 'Example Medal'; }};
    string icon { get override { return "\\$f0f" + Icons::Circle; }};

    void OnNewMap(const string &in uid) override {}

    bool HasMedalTime(const string &in uid) override {
        return currentUID == uid && exampleMedal != 0;
    }
    uint GetMedalTime() override {
        return exampleMedal;
    }
}

#endif
```

and in Main():

```
#if DEPENDENCY_ULTIMATEMEDALSEXTENDED
    UltimateMedalsExtended::addMedal(ExampleMedal());
#endif
```

