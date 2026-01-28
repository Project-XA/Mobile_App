import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class NetworkInfoService {
  final NetworkInfo _networkInfo = NetworkInfo();

  Future<String?> getWifiSSID() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.locationWhenInUse.request();
        if (!status.isGranted) {
          throw LocationPermissionException('Location permission is required to get WiFi information');
        }
      }
      
      final ssid = await _networkInfo.getWifiName();
      if (ssid != null && ssid.startsWith('"') && ssid.endsWith('"')) {
        return ssid.substring(1, ssid.length - 1);
      }
      return ssid;
    } catch (e) {
      throw Exception('Failed to get WiFi SSID: $e');
    }
  }

  Future<String?> getWifiBSSID() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.locationWhenInUse.request();
        if (!status.isGranted) {
          throw LocationPermissionException('Location permission is required to get WiFi information');
        }
      }
      
      final bssid = await _networkInfo.getWifiBSSID();
      return bssid;
    } catch (e) {
      throw Exception('Failed to get WiFi BSSID: $e');
    }
  }

  Future<Position> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationServiceDisabledException(
          'Location services are disabled. Please enable location in your device settings.'
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationPermissionException('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationPermissionException(
          'Location permission permanently denied. Please enable it in app settings.'
        );
      }

      // Get position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<NetworkLocationInfo> getNetworkAndLocationInfo() async {
    try {
      final ssid = await getWifiSSID();
      final bssid = await getWifiBSSID();
      final position = await getCurrentLocation();


      return NetworkLocationInfo(
        ssid: ssid ?? 'Unknown',
        bssid: bssid ?? 'Unknown',
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class NetworkLocationInfo {
  final String ssid;
  final String bssid;
  final double latitude;
  final double longitude;

  NetworkLocationInfo({
    required this.ssid,
    required this.bssid,
    required this.latitude,
    required this.longitude,
  });
}

class LocationServiceDisabledException implements Exception {
  final String message;
  LocationServiceDisabledException(this.message);
  
  @override
  String toString() => message;
}

class LocationPermissionException implements Exception {
  final String message;
  LocationPermissionException(this.message);
  
  @override
  String toString() => message;
}