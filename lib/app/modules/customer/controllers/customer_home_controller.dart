import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/logger_utils.dart';
import '../../../data/models/shop_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/location_service.dart';

class CustomerHomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final LocationService _locationService = Get.find<LocationService>();

  final RxList<ShopModel> shops = <ShopModel>[].obs;
  final RxList<ShopModel> filteredShops = <ShopModel>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = true.obs;
  final RxInt currentNavIndex = 0.obs;

  final searchController = TextEditingController();

  String get userName => _authService.userModel?.name ?? 'ລູກຄ້າ';
  String get userAddress =>
      _authService.userModel?.defaultAddress?.address ?? 'ເລືອກທີ່ຢູ່';

  @override
  void onInit() {
    super.onInit();
    _loadShops();
    _loadCategories();
    _initLocation();
  }

  void _loadShops() {
    _firestoreService.getShops().listen((list) {
      shops.value = list;
      _applyFilter();
      isLoading.value = false;
      Log.i('Loaded ${list.length} shops');
    });
  }

  void _loadCategories() {
    _firestoreService.getCategories().listen((cats) {
      categories.value = cats;
    });
  }

  void _initLocation() async {
    await _locationService.getCurrentPosition();
  }

  void selectCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = '';
    } else {
      selectedCategory.value = category;
    }
    _applyFilter();
  }

  void searchShops(String query) {
    _applyFilter(query: query);
  }

  void _applyFilter({String? query}) {
    final q = (query ?? searchController.text).toLowerCase();
    filteredShops.value = shops.where((shop) {
      final matchQuery = q.isEmpty ||
          shop.name.toLowerCase().contains(q) ||
          shop.category.toLowerCase().contains(q) ||
          shop.tags.any((t) => t.toLowerCase().contains(q));

      final matchCategory = selectedCategory.value.isEmpty ||
          shop.category == selectedCategory.value;

      return matchQuery && matchCategory && shop.isOpen;
    }).toList();

    // Sort by distance if location available
    if (_locationService.currentPosition.value != null) {
      filteredShops.sort((a, b) {
        final distA = _locationService.calculateDistance(
          _locationService.currentLat,
          _locationService.currentLng,
          a.latitude,
          a.longitude,
        );
        final distB = _locationService.calculateDistance(
          _locationService.currentLat,
          _locationService.currentLng,
          b.latitude,
          b.longitude,
        );
        return distA.compareTo(distB);
      });
    }
  }

  void onNavTap(int index) {
    currentNavIndex.value = index;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
