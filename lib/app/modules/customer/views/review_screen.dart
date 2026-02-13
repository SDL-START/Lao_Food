import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late OrderModel order;
  final _shopRating = 0.0.obs;
  final _riderRating = 0.0.obs;
  final _shopComment = TextEditingController();
  final _riderComment = TextEditingController();
  final _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    order = Get.arguments as OrderModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ໃຫ້ຄະແນນ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ໃຫ້ຄະແນນປະສົບການຂອງທ່ານ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),

            // ── Shop rating ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.storefront,
                      size: 36, color: AppColors.primary),
                  const SizedBox(height: 8),
                  Text(
                    order.shopName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => RatingStars(
                        rating: _shopRating.value,
                        size: 36,
                        interactive: true,
                        onRatingChanged: (v) => _shopRating.value = v,
                      )),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _shopComment,
                    decoration: const InputDecoration(
                      hintText: 'ໃຫ້ຄຳເຫັນກ່ຽວກັບຮ້ານ (ທາງເລືອກ)',
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Rider rating ──
            if (order.riderId != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.two_wheeler,
                        size: 36, color: AppColors.primary),
                    const SizedBox(height: 8),
                    Text(
                      order.riderName ?? 'Rider',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => RatingStars(
                          rating: _riderRating.value,
                          size: 36,
                          interactive: true,
                          onRatingChanged: (v) => _riderRating.value = v,
                        )),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _riderComment,
                      decoration: const InputDecoration(
                        hintText: 'ໃຫ້ຄຳເຫັນກ່ຽວກັບ Rider (ທາງເລືອກ)',
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 32),

            Obx(() => AppButton(
                  text: 'ສົ່ງຄະແນນ',
                  isLoading: _isLoading.value,
                  onPressed: _submitReview,
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    if (_shopRating.value == 0) {
      Helpers.showWarning('ກະລຸນາໃຫ້ຄະແນນຮ້ານ');
      return;
    }

    _isLoading.value = true;
    try {
      final authService = Get.find<AuthService>();
      final firestoreService = Get.find<FirestoreService>();

      final review = ReviewModel(
        id: '',
        orderId: order.id,
        customerId: authService.uid,
        customerName: authService.userModel?.name ?? '',
        customerImage: authService.userModel?.profileImage,
        shopId: order.shopId,
        shopRating: _shopRating.value,
        shopComment: _shopComment.text.trim().isEmpty
            ? null
            : _shopComment.text.trim(),
        riderId: order.riderId,
        riderRating: _riderRating.value,
        riderComment: _riderComment.text.trim().isEmpty
            ? null
            : _riderComment.text.trim(),
        createdAt: DateTime.now(),
      );

      await firestoreService.createReview(review);
      Helpers.showSuccess('ຂອບໃຈສຳລັບຄະແນນ!');
      Get.back();
    } catch (e) {
      Helpers.showError('ສົ່ງຄະແນນບໍ່ສຳເລັດ');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _shopComment.dispose();
    _riderComment.dispose();
    super.dispose();
  }
}
