# CAS-Help

## 1.1.4 — Passed Code Review

All 10 findings from the November 1, 2026 standalone package review are resolved across CAS-Help and CAS-WhatsNew. Version-read APIs now require `try`; see the API notes below.

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

## Version API error handling

`HelpVersion.getFromID`, `getLatestVersion`, and `getAll` now throw database errors.
The first two return `nil` when a valid ID is absent or the Version table is empty;
zero is still a valid ID/version. Callers must use `try` and handle failures.

```swift
do {
    if let version = try HelpVersion().getLatestVersion(dbQueue: queue, logLFFL: "Version check") {
        print(version)
    } else {
        // No version record exists yet.
    }
} catch {
    // Surface error.localizedDescription through the host app's error presentation.
}
```

`delete` returns `false` when no record is deleted or the required ID is negative.
`saveUpdate` rejects an unset/negative record ID. The viewer initializer still permits
an omitted queue for source compatibility, but displays a configuration error and Retry
instead of silently rendering blank content. Database read errors and empty content
have distinct view states. Hosts must supply an opened queue for normal display.
