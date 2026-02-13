import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger_utils.dart';

class LocationService extends GetxService {
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  StreamSubscription<Position>? _positionStream;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  double get currentLat =>
      currentPosition.value?.latitude ?? AppConstants.defaultLat;
  double get currentLng =>
      currentPosition.value?.longitude ?? AppConstants.defaultLng;

  /// ── Check & Request permissions ──
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Log.w('Location services disabled');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Log.w('Location permission denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Log.w('Location permission permanently denied');
      return false;
    }
    return true;
  }

  /// ── Get current position ──
  Future<Position?> getCurrentPosition() async {
    final hasPermission = await checkPermission();
    if (!hasPermission) return null;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      currentPosition.value = position;
      Log.i('Current position: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      Log.e('Get position error', e);
      return null;
    }
  }

  /// ── Start tracking (for Rider) ──
  void startTracking(String riderId) {
    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20, // meters
      ),
    ).listen((position) {
      currentPosition.value = position;
      _updateRiderLocation(riderId, position);
    });
    Log.i('Started tracking rider: $riderId');
  }

  /// ── Stop tracking ──
  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    Log.i('Stopped tracking');
  }

  /// ── Update rider location in Firestore ──
  Future<void> _updateRiderLocation(String riderId, Position position) async {
    try {
      await _db
          .collection(AppConstants.usersCollection)
          .doc(riderId)
          .update({
        'currentLat': position.latitude,
        'currentLng': position.longitude,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      Log.e('Update rider location error', e);
    }
  }

  /// ── Calculate distance between two points ──
  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng) /
        1000; // km
  }

  /// ── Stream rider location (for customer live tracking) ──
  Stream<DocumentSnapshot> streamRiderLocation(String riderId) {
    return _db
        .collection(AppConstants.usersCollection)
        .doc(riderId)
        .snapshots();
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    super.onClose();
  }
}
