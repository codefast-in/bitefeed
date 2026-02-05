import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  final _logger = Logger();

  // Check if permission is granted
  Future<bool> isGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  // Request single permission
  Future<bool> request(Permission permission) async {
    final status = await permission.request();
    _logger.d('Permission ${permission.toString()} status: $status');
    return status.isGranted;
  }

  // Request multiple permissions
  Future<Map<Permission, PermissionStatus>> requestMultiple(
    List<Permission> permissions,
  ) async {
    final statuses = await permissions.request();
    _logger.d('Permissions requested: $statuses');
    return statuses;
  }

  // Camera Permission
  Future<bool> requestCamera() async {
    return await request(Permission.camera);
  }

  Future<bool> isCameraGranted() async {
    return await isGranted(Permission.camera);
  }

  // Photos Permission
  Future<bool> requestPhotos() async {
    return await request(Permission.photos);
  }

  Future<bool> isPhotosGranted() async {
    return await isGranted(Permission.photos);
  }

  // Location Permission
  Future<bool> requestLocation() async {
    return await request(Permission.location);
  }

  Future<bool> isLocationGranted() async {
    return await isGranted(Permission.location);
  }

  Future<bool> requestLocationWhenInUse() async {
    return await request(Permission.locationWhenInUse);
  }

  Future<bool> isLocationWhenInUseGranted() async {
    return await isGranted(Permission.locationWhenInUse);
  }

  // Notification Permission
  Future<bool> requestNotification() async {
    return await request(Permission.notification);
  }

  Future<bool> isNotificationGranted() async {
    return await isGranted(Permission.notification);
  }

  // Storage Permission (for older Android versions)
  Future<bool> requestStorage() async {
    return await request(Permission.storage);
  }

  Future<bool> isStorageGranted() async {
    return await isGranted(Permission.storage);
  }

  // Check if permission is permanently denied
  Future<bool> isPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  // Open app settings
  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  // Request camera and photos together (for image picker)
  Future<bool> requestCameraAndPhotos() async {
    final statuses = await requestMultiple([
      Permission.camera,
      Permission.photos,
    ]);

    return statuses.values.every((status) => status.isGranted);
  }

  // Check camera and photos permissions
  Future<bool> hasCameraAndPhotosPermission() async {
    final cameraGranted = await isCameraGranted();
    final photosGranted = await isPhotosGranted();
    return cameraGranted && photosGranted;
  }
}
