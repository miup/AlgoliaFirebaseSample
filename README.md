# AlgoliaFirebaseSample

Sample iOS application for Algolia with Firebase Cloud function.

## Setup

### cocoapods

```
$ bundle install
$ bundle exec pod install
```

### Application

1. open `AlgoliaFirebaseSample.xcworkspace`
2. put your `GoogleServices-Info.plist`
3. set your Algolia appID, API key in `AppDelegate.swift`

```Swift
// AppDelegate.swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure(options: FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!)!)
    Algent.initialize(appID: "APP_ID", apiKey: "API_KEY")
    ...
    ...
    ...
}
```

### CloudFunctions

1. set your Firebase App ID in `.firebaserc`

```
{
  "projects": {
    "default": "APP_ID"
  }
}
```

2. npm install

```
$ cd CloudFunctions/functions
$ npm install
```

3. set Algolia API Key

```
// algoliaProvider.ts
const algolia = algoliasearch('APP_ID', 'API_KEY')
```

4. compile TypeScript

```
$ npm run build
```

5. deploy

```
$ firebase deploy --only functions
```

## Caution!
This project work only Flame or Blaze plans of Firebase.

Will not work Spark plan.
