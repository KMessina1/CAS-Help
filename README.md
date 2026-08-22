# CAS-Help

Reusable SwiftUI help viewer support for apps that store help content in a GRDB-backed SQLite database.

## Integration

1. Add `CAS-Help` as a package dependency and link the `CASHelp` product to the app target.

2. Copy the sample database from this package:

   `Sample Data/HelpStarterFile.db`

   into the app project’s data/resource folder.

3. Rename the copied database file to:

   `Help.db`

4. In Xcode, select the copied `Help.db` file and confirm it is included in the app target membership so it is bundled with the app.

5. Present `HelpView` from the app and pass the app-owned database queue and app display values:

   ```swift
   HelpView(
       dbQueue: dbQueue_Help,
       appVersion: AppInfo.version,
       companyURL: UserDefaults.standard.string(forKey: "appInfo.Company.URL") ?? ""
   )
   ```

The package owns the reusable Help UI and record model. The app remains responsible for bundling its `Help.db` resource and opening the database queue used by `HelpView`.

`HelpView` stores its text size preference internally with `@AppStorage("app.settings.helpTextSize")` and defaults to `18.0`.
