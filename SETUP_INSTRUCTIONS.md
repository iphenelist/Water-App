# Water App Image Setup Instructions

## Adding the Water Drop Image

1. Save the blue water drop image to the following location:
   ```
   assets/images/water_drop.png
   ```

2. Make sure the image is in PNG format with a transparent background.

3. After adding the image, run the following command to generate the native splash screens:
   ```
   flutter pub run flutter_native_splash:create
   ```

## Image Usage in the App

The water drop image is used in the following places:

1. Splash screen - The initial loading screen when the app starts
2. Login screen - As the app logo at the top
3. Signup screen - As the app logo at the top

## Troubleshooting

If you encounter any issues with the image display:

1. Make sure the image is placed in the correct location
2. Check that the image is in PNG format
3. Verify that the pubspec.yaml file includes the assets/images/ directory
4. Run `flutter clean` and then `flutter pub get` to refresh the asset cache
5. Restart the app

## Customizing the Splash Screen

If you want to customize the splash screen further, you can edit the `flutter_native_splash.yaml` file and then run:
```
flutter pub run flutter_native_splash:create
```

This will regenerate the splash screen with your custom settings.
