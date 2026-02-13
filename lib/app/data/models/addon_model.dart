/// ── Single addon item ──
class AddonItem {
  final String id;
  final String name;
  final double price;
  final bool isAvailable;

  AddonItem({
    required this.id,
    required this.name,
    required this.price,
    this.isAvailable = true,
  });

  factory AddonItem.fromMap(Map<String, dynamic> map) {
    return AddonItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'isAvailable': isAvailable,
    };
  }
}

/// ── Addon group (e.g., "ເລືອກລະດັບເຜັດ", "ເລືອກເຄື່ອງດື່ມ") ──
class AddonGroup {
  final String id;
  final String name;
  final bool isRequired;
  final int maxSelection;
  final List<AddonItem> items;

  AddonGroup({
    required this.id,
    required this.name,
    this.isRequired = false,
    this.maxSelection = 1,
    this.items = const [],
  });

  factory AddonGroup.fromMap(Map<String, dynamic> map) {
    return AddonGroup(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isRequired: map['isRequired'] ?? false,
      maxSelection: map['maxSelection'] ?? 1,
      items: (map['items'] as List<dynamic>?)
              ?.map((i) => AddonItem.fromMap(i as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isRequired': isRequired,
      'maxSelection': maxSelection,
      'items': items.map((i) => i.toMap()).toList(),
    };
  }
}

/// ── Selected addon (stored in cart / order) ──
class SelectedAddon {
  final String groupId;
  final String groupName;
  final String itemId;
  final String itemName;
  final double price;

  SelectedAddon({
    required this.groupId,
    required this.groupName,
    required this.itemId,
    required this.itemName,
    required this.price,
  });

  factory SelectedAddon.fromMap(Map<String, dynamic> map) {
    return SelectedAddon(
      groupId: map['groupId'] ?? '',
      groupName: map['groupName'] ?? '',
      itemId: map['itemId'] ?? '',
      itemName: map['itemName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'itemId': itemId,
      'itemName': itemName,
      'price': price,
    };
  }
}
