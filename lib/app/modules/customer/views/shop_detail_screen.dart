import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/product_tile.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/shop_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/firestore_service.dart';
import '../controllers/cart_controller.dart';
import '../../../routes/app_routes.dart';

class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({super.key});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  late ShopModel shop;
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final CartController _cartController = Get.find<CartController>();
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedCategory = ''.obs;

  @override
  void initState() {
    super.initState();
    shop = Get.arguments as ShopModel;
    _loadProducts();
  }

  void _loadProducts() {
    _firestoreService.getProducts(shop.id).listen((list) {
      products.value = list;
      isLoading.value = false;
    });
  }

  List<String> get productCategories {
    return products.map((p) => p.category).toSet().toList();
  }

  List<ProductModel> get filteredProducts {
    if (selectedCategory.value.isEmpty) return products;
    return products.where((p) => p.category == selectedCategory.value).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── App Bar with image ──
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black26,
                child: Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 18),
              ),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: shop.coverImage != null
                  ? CachedNetworkImage(
                      imageUrl: shop.coverImage!,
                      fit: BoxFit.cover,
                      color: Colors.black26,
                      colorBlendMode: BlendMode.darken,
                    )
                  : Container(color: AppColors.primary),
            ),
          ),

          // ── Shop info ──
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (shop.isVerified)
                        const Icon(Icons.verified,
                            color: AppColors.info, size: 22),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    shop.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      RatingStars(rating: shop.rating, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${shop.rating.toStringAsFixed(1)} (${shop.totalReviews})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${shop.prepTimeMinutes} ນາທີ',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.delivery_dining,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        Helpers.formatCurrency(shop.deliveryFee),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          shop.address,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Category filter ──
          SliverToBoxAdapter(
            child: Obx(() {
              final cats = productCategories;
              if (cats.isEmpty) return const SizedBox();
              return SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: cats.length,
                  itemBuilder: (_, i) {
                    final selected = selectedCategory.value == cats[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(cats[i]),
                        selected: selected,
                        onSelected: (_) {
                          selectedCategory.value =
                              selected ? '' : cats[i];
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),

          // ── Menu header ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Text(
                'ເມນູ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // ── Product list ──
          Obx(() {
            if (isLoading.value) {
              return const SliverFillRemaining(child: LoadingWidget());
            }
            final filtered = filteredProducts;
            if (filtered.isEmpty) {
              return const SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.restaurant_menu,
                  title: 'ບໍ່ມີເມນູ',
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final product = filtered[i];
                  return Column(
                    children: [
                      ProductTile(
                        product: product,
                        onTap: () => _showProductDetail(product),
                        onAddToCart: () {
                          _cartController.addToCart(
                            product: product,
                            shopId: shop.id,
                            shopName: shop.name,
                          );
                        },
                      ),
                      if (i < filtered.length - 1)
                        const Divider(indent: 16, endIndent: 16),
                    ],
                  );
                },
                childCount: filtered.length,
              ),
            );
          }),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // ── Cart button ──
      bottomNavigationBar: Obx(() {
        if (!_cartController.hasItems ||
            _cartController.cart.value?.shopId != shop.id) {
          return const SizedBox();
        }
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, -2)),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.cart),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_cartController.itemCount}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('ເບິ່ງກະຕ່າ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text(
                    Helpers.formatCurrency(_cartController.subtotal),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showProductDetail(ProductModel product) {
    Get.toNamed(AppRoutes.productDetail, arguments: {
      'product': product,
      'shop': shop,
    });
  }
}
