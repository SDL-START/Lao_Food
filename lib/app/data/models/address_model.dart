import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final String label; // ບ້ານ, ທີ່ທຳງານ, etc.
  final String address;
  final String? note;
  final double latitude;
  final double longitude;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.address,
    this.note,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
      address: map['address'] ?? '',
      note: map['note'],
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'address': address,
      'note': note,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromGeoPoint(GeoPoint point, {String? address}) {
    return AddressModel(
      id: '',
      label: 'ປັກໝຸດ',
      address: address ?? '',
      latitude: point.latitude,
      longitude: point.longitude,
    );
  }

  GeoPoint toGeoPoint() => GeoPoint(latitude, longitude);

  AddressModel copyWith({
    String? id,
    String? label,
    String? address,
    String? note,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      address: address ?? this.address,
      note: note ?? this.note,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
