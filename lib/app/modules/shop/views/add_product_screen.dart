import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/auth_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _prepTimeCtrl = TextEditingController(text: '15');
  final _isLoading = false.obs;
  final _isPopular = false.obs;
  File? _image;
  ProductModel? _editing;

  @override
  void initState() {
    super.initState();
    if (Get.arguments is ProductModel) {
      _editing = Get.arguments as ProductModel;
      _nameCtrl.text = _editing!.name;
      _descCtrl.text = _editing!.description;
      _priceCtrl.text = _editing!.price.toStringAsFixed(0);
      _categoryCtrl.text = _editing!.category;
      _prepTimeCtrl.text = _editing!.preparationTime.toString();
      _isPopular.value = _editing!.isPopular;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editing != null ? 'ແກ້ໄຂເມນູ' : 'ເພີ່ມເມນູ'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Image picker ──
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                        : _editing?.image != null
                            ? DecorationImage(
                                image: NetworkImage(_editing!.image!),
                                fit: BoxFit.cover,
                              )
                            : null,
                  ),
                  child: (_image == null && _editing?.image == null)
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt,
                                size: 40, color: AppColors.textHint),
                            SizedBox(height: 8),
                            Text('ເພີ່ມຮູບ',
                                style: TextStyle(color: AppColors.textHint)),
                          ],
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              AppInput(
                controller: _nameCtrl,
                label: 'ຊື່ເມນູ',
                hint: 'ເຊັ່ນ: ເຝີ, ຂ້າວຈີ່',
                validator: (v) => Helpers.validateRequired(v, 'ຊື່ເມນູ'),
              ),

              const SizedBox(height: 16),

              AppInput(
                controller: _descCtrl,
                label: 'ລາຍລະອຽດ',
                hint: 'ອະທິບາຍເມນູ...',
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              AppInput(
                controller: _priceCtrl,
                label: 'ລາຄາ (${AppConstants.currency})',
                hint: '25000',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'ກະລຸນາໃສ່ລາຄາ';
                  if (double.tryParse(v) == null) return 'ລາຄາບໍ່ຖືກ';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              AppInput(
                controller: _categoryCtrl,
                label: 'ໝວດໝູ່',
                hint: 'ເຊັ່ນ: ອາຫານຫຼັກ, ເຄື່ອງດື່ມ',
                validator: (v) => Helpers.validateRequired(v, 'ໝວດໝູ່'),
              ),

              const SizedBox(height: 16),

              AppInput(
                controller: _prepTimeCtrl,
                label: 'ເວລາກະກຽມ (ນາທີ)',
                hint: '15',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              Obx(() => SwitchListTile(
                    title: const Text('ຍອດນິຍົມ'),
                    subtitle: const Text('ສະແດງປ້າຍ "ຍອດນິຍົມ"'),
                    value: _isPopular.value,
                    onChanged: (v) => _isPopular.value = v,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  )),

              const SizedBox(height: 24),

              Obx(() => AppButton(
                    text: _editing != null ? 'ບັນທຶກ' : 'ເພີ່ມເມນູ',
                    isLoading: _isLoading.value,
                    onPressed: _save,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final storageService = Get.find<StorageService>();
    final file = await storageService.pickImage();
    if (file != null) {
      setState(() => _image = file);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading.value = true;
    try {
      final authService = Get.find<AuthService>();
      final firestoreService = Get.find<FirestoreService>();
      final storageService = Get.find<StorageService>();
      final shopId = authService.userModel?.shopId ?? '';

      String? imageUrl = _editing?.image;
      if (_image != null) {
        imageUrl = await storageService.uploadImage(
          _image!,
          AppConstants.productImagesPath,
        );
      }

      if (_editing != null) {
        // Update
        await firestoreService.updateProduct(shopId, _editing!.id, {
          'name': _nameCtrl.text.trim(),
          'description': _descCtrl.text.trim(),
          'price': double.parse(_priceCtrl.text),
          'category': _categoryCtrl.text.trim(),
          'preparationTime': int.tryParse(_prepTimeCtrl.text) ?? 15,
          'isPopular': _isPopular.value,
          if (imageUrl != null) 'image': imageUrl,
        });
        Helpers.showSuccess('ແກ້ໄຂສຳເລັດ');
      } else {
        // Create
        final product = ProductModel(
          id: '',
          shopId: shopId,
          name: _nameCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          image: imageUrl,
          price: double.parse(_priceCtrl.text),
          category: _categoryCtrl.text.trim(),
          isPopular: _isPopular.value,
          preparationTime: int.tryParse(_prepTimeCtrl.text) ?? 15,
          createdAt: DateTime.now(),
        );
        await firestoreService.createProduct(product);
        Helpers.showSuccess('ເພີ່ມເມນູສຳເລັດ');
      }

      Get.back();
    } catch (e) {
      Helpers.showError('ບັນທຶກບໍ່ສຳເລັດ');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _categoryCtrl.dispose();
    _prepTimeCtrl.dispose();
    super.dispose();
  }
}
