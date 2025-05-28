# App Icon Setup Instructions

To replace all the default Flutter icons with the water drop image, follow these steps:

## 1. Install the flutter_launcher_icons package

Run the following command to add the package to your project:

```bash
flutter pub add flutter_launcher_icons --dev
```

## 2. Create a configuration file

Create a file named `flutter_launcher_icons.yaml` in the root of your project with the following content:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/water_drop.png"
  adaptive_icon_background: "#0088cc" # Blue background color
  adaptive_icon_foreground: "assets/images/water_drop.png"
  web:
    generate: true
    image_path: "assets/images/water_drop.png"
    background_color: "#0088cc"
    theme_color: "#0088cc"
  windows:
    generate: true
    image_path: "assets/images/water_drop.png"
    icon_size: 48 # min:48, max:256, default: 48
  macos:
    generate: true
    image_path: "assets/images/water_drop.png"
```

## 3. Run the icon generator

After saving the configuration file, run the following command:

```bash
flutter pub run flutter_launcher_icons
```

This will generate app icons for all platforms (Android, iOS, Web, Windows, macOS) using the water drop image.

## 4. Verify the icons

The icons will be generated in the following locations:

- Android: `android/app/src/main/res/mipmap-*`
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset`
- Web: `web/icons`
- Windows: `windows/runner/resources`
- macOS: `macos/Runner/Assets.xcassets/AppIcon.appiconset`

## 5. Update the app name (optional)

If you want to update the app name that appears under the icon, you can modify:

- Android: `android/app/src/main/AndroidManifest.xml` - Update the `android:label` attribute
- iOS: `ios/Runner/Info.plist` - Update the `CFBundleName` key
- Web: `web/manifest.json` - Update the `name` and `short_name` fields
- Windows: `windows/runner/main.cpp` - Update the window title
- macOS: `macos/Runner/Info.plist` - Update the `CFBundleName` key

## Note

Make sure the water_drop.png image:
- Has a transparent background
- Is at least 1024x1024 pixels for best quality
- Is in PNG format
