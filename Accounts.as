#if DEPENDENCY_NADEOSERVICES

namespace Accounts {
    bool requesting = false;

    dictionary@ accounts = {
        { "d2372a08-a8a1-46cb-97fb-23a161d85ad0", "Nadeo" },
        { "aa02b90e-0652-4a1c-b705-4677e2983003", "Nadeo" }
    };

    string GetAccountName(const string&in login) {
        string accountId;
        try {
            accountId = NadeoServices::LoginToAccountId(login);
        } catch { }

        if (accountId.Length > 0) {
            if (accounts.Exists(accountId)) {
                return string(accounts[accountId]);
            }

            startnew(GetAccountNameAsync, accountId);
        }

        return "";
    }

    void GetAccountNameAsync(const string&in accountId) {
        if (requesting) {
            return;
        }
        requesting = true;

        const string accountName = NadeoServices::GetDisplayNameAsync(accountId);
        if (accountName.Length > 0) {
            trace("got account name: " + accountName);
            accounts[accountId] = accountName;
        }

        requesting = false;
    }
}

#endif
