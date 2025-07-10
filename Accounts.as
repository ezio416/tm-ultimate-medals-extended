#if DEPENDENCY_NADEOSERVICES

namespace Accounts {
    const string audience = "NadeoServices";
    dictionary@ authors = dictionary();
    uint64 lastRequest = 0;
    bool requesting = false;

    dictionary@ accounts = {
        { "d2372a08-a8a1-46cb-97fb-23a161d85ad0", "Nadeo" },
        { "aa02b90e-0652-4a1c-b705-4677e2983003", "Nadeo" }
    };

    string GetAuthorName(const string&in uid) {
        if (authors.Exists(uid)) {
            return string(authors[uid]);
        }

        if (!requesting) {
            startnew(GetAuthorNameAsync, uid);
        }

        return "";
    }

    void GetAuthorNameAsync(const string&in uid) {
        if (requesting) {
            return;
        }
        requesting = true;

        NadeoServices::AddAudience(audience);
        while (!NadeoServices::IsAuthenticated(audience)) {
            yield();
        }

        WaitAsync();
        Net::HttpRequest@ mapInfo = NadeoServices::Get(
            "NadeoServices",
            NadeoServices::BaseURLCore() + "/maps/?mapUidList=" + uid
        );
        mapInfo.Start();
        while (!mapInfo.Finished()) {
            yield();
        }

        string authorId;
        try {
            authorId = mapInfo.Json()[0]["author"];
            trace("got author ID: " + authorId);
        } catch {
            warn("error getting author name: " + getExceptionInfo());
            requesting = false;
            return;
        }

        if (authorId.Length > 0) {
            string authorName;

            if (accounts.Exists(authorId)) {
                authorName = string(accounts[authorId]);
                trace("had author name: " + authorName);
                authors[uid] = authorName;
                requesting = false;
                return;
            }

            authorName = NadeoServices::GetDisplayNameAsync(authorId);
            if (authorName.Length > 0) {
                trace("got author name: " + authorName);
                accounts[authorId] = authorName;
                authors[uid] = authorName;
            }
        }

        requesting = false;
    }

    void WaitAsync() {
        uint64 now;
        while ((now = Time::Now) - lastRequest < 1000) {
            yield();
        }
        lastRequest = now;
    }
}

#endif
