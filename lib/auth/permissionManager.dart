import 'package:flutter_background/flutter_background.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {

  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Background app example",
    notificationText: "Background app is running",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Change to your own icon
  );

  // Initialize FlutterBackground
  bool success = await FlutterBackground.initialize(androidConfig: androidConfig);

  // Request storage and location permissions
  var statusStorage = await Permission.storage.request();
  var statusLocation = await Permission.location.request();

  if (statusStorage.isGranted && statusLocation.isGranted) {
    // Permission is granted
    print('Storage and location permissions granted');
  } else if (statusStorage.isPermanentlyDenied || statusLocation.isPermanentlyDenied) {
    // Permission is permanently denied
    print('Storage or location permissions permanently denied');
    //openAppSettings();
  } else {
    // Permission is denied
    print('Storage or location permissions denied');

    bool isBackgroundExecutionEnabled = await FlutterBackground.isBackgroundExecutionEnabled;
    if (isBackgroundExecutionEnabled) {
      // Background execution is enabled
    } else {
      // Background execution is not enabled
    }

  }
}