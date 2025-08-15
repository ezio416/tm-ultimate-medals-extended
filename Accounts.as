#if DEPENDENCY_NADEOSERVICES

namespace Accounts {
    bool requesting = false;

    dictionary@ logins = {
        { "0jcqCKihRsuX-yOhYdha0A", "Nadeo" }, //d2372a08-a8a1-46cb-97fb-23a161d85ad0
        { "qgK5DgZSShy3BUZ34pgwAw", "Nadeo" } //aa02b90e-0652-4a1c-b705-4677e2983003
    };

    string GetAccountName(const string&in login) {

        string name;
        if (logins.Get(login, name)) {
            return name;
        }

        startnew(GetAccountNameAsync, login);

        return "";
    }

    void GetAccountNameAsync(const string &in login) {
        if (requesting) {
            return;
        }

        string accountId;
        try {
            accountId = NadeoServices::LoginToAccountId(login);
        } catch { return; }
        if (accountId.Length == 0) {
            trace("invalid account id for: " + login);
            logins[login] = "";
        }

        requesting = true;

        const string accountName = NadeoServices::GetDisplayNameAsync(accountId);
        if (accountName.Length > 0) {
            trace("got account name: " + accountName);
            logins[login] = accountName;
        }

        requesting = false;
    }
}

#endif
