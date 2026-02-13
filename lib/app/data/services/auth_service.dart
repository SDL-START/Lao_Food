import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger_utils.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  User? get user => firebaseUser.value;
  UserModel? get userModel => currentUser.value;
  bool get isLoggedIn => user != null;
  String get uid => user?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) async {
    if (user != null) {
      await _loadUserData(user.uid);
    } else {
      currentUser.value = null;
    }
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      if (doc.exists) {
        currentUser.value = UserModel.fromMap(doc.data()!);
        Log.i('User loaded: ${currentUser.value?.name} (${currentUser.value?.role})');
      }
    } catch (e) {
      Log.e('Error loading user data', e);
    }
  }

  /// ── Login (ໃຊ້ຮ່ວມທຸກ role) ──
  Future<UserModel?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (result.user != null) {
        await _loadUserData(result.user!.uid);

        // Check if user is active
        if (currentUser.value != null && !currentUser.value!.isActive) {
          await logout();
          throw 'ບັນຊີຖືກລະງັບ. ກະລຸນາຕິດຕໍ່ Admin.';
        }

        Log.i('Login success: ${result.user!.email}');
        return currentUser.value;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      Log.e('Login error: ${e.code}');
      throw _mapAuthError(e.code);
    }
  }

  /// ── Register (ສະເພາະລູກຄ້າ) ──
  Future<UserModel?> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (result.user != null) {
        final user = UserModel(
          uid: result.user!.uid,
          name: name.trim(),
          email: email.trim(),
          phone: phone.trim(),
          role: AppConstants.roleCustomer,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(user.uid)
            .set(user.toMap());

        currentUser.value = user;
        Log.i('Customer registered: ${user.name}');
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      Log.e('Register error: ${e.code}');
      throw _mapAuthError(e.code);
    }
  }

  /// ── Register Admin (ສ້າງບັນຊີ Admin ໃໝ່) ──
  Future<UserModel?> registerAdmin({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (result.user != null) {
        final user = UserModel(
          uid: result.user!.uid,
          name: name.trim(),
          email: email.trim(),
          phone: phone.trim(),
          role: AppConstants.roleAdmin,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(user.uid)
            .set(user.toMap());

        currentUser.value = user;
        Log.i('Admin registered: ${user.name}');
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      Log.e('Register admin error: ${e.code}');
      throw _mapAuthError(e.code);
    }
  }

  /// ── Admin creates Shop/Rider ──
  Future<UserModel?> createUserByAdmin({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? shopId,
  }) async {
    try {
      // Create auth user
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (result.user != null) {
        final user = UserModel(
          uid: result.user!.uid,
          name: name.trim(),
          email: email.trim(),
          phone: phone.trim(),
          role: role,
          shopId: shopId,
          isActive: true,
          isVerified: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(user.uid)
            .set(user.toMap());

        Log.i('Admin created user: ${user.name} ($role)');
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      Log.e('Create user error: ${e.code}');
      throw _mapAuthError(e.code);
    }
  }

  /// ── Logout ──
  Future<void> logout() async {
    try {
      // Update online status for riders
      if (currentUser.value?.isRider == true) {
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(uid)
            .update({'isOnline': false});
      }
      await _auth.signOut();
      currentUser.value = null;
      Log.i('User logged out');
    } catch (e) {
      Log.e('Logout error', e);
    }
  }

  /// ── Reset Password ──
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      Log.i('Password reset sent to: $email');
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e.code);
    }
  }

  /// ── Update FCM Token ──
  Future<void> updateFcmToken(String token) async {
    if (uid.isEmpty) return;
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update({'fcmToken': token});
    } catch (e) {
      Log.e('Update FCM token error', e);
    }
  }

  /// ── Update Profile ──
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now();
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update(data);
      await _loadUserData(uid);
      Log.i('Profile updated');
    } catch (e) {
      Log.e('Update profile error', e);
      rethrow;
    }
  }

  /// ── Refresh user data ──
  Future<void> refreshUser() async {
    if (uid.isNotEmpty) {
      await _loadUserData(uid);
    }
  }

  // ── Google Login ──
  Future<UserModel?> loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');
      
      // Once signed in, return the UserCredential
      final UserCredential result = await _auth.signInWithProvider(googleProvider);
      
      if (result.user != null) {
        // Check if user exists in Firestore
        final userDoc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(result.user!.uid)
            .get();
        
        if (!userDoc.exists) {
          // Create new user if doesn't exist
          final newUser = UserModel(
            uid: result.user!.uid,
            name: result.user!.displayName ?? 'Google User',
            email: result.user!.email ?? '',
            phone: result.user!.phoneNumber ?? '',
            role: AppConstants.roleCustomer,
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          
          await _firestore
              .collection(AppConstants.usersCollection)
              .doc(result.user!.uid)
              .set(newUser.toMap());
          
          currentUser.value = newUser;
        } else {
          await _loadUserData(result.user!.uid);
        }
        
        Log.i('Google login success: ${result.user!.email}');
        return currentUser.value;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      Log.e('Google login error: ${e.code}');
      throw _mapAuthError(e.code);
    } catch (e) {
      Log.e('Google login error', e);
      throw 'ເຂົ້າສູ່ລະບົບດ້ວຍ Google ບໍ່ສຳເລັດ';
    }
  }

  // ── Facebook Login ──
  Future<UserModel?> loginWithFacebook() async {
    try {
      // Create a new provider
      final FacebookAuthProvider facebookProvider = FacebookAuthProvider();
      facebookProvider.addScope('email');
      facebookProvider.addScope('public_profile');
      
      // Once signed in, return the UserCredential
      final UserCredential result = await _auth.signInWithProvider(facebookProvider);
      
      if (result.user != null) {
        // Check if user exists in Firestore
        final userDoc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(result.user!.uid)
            .get();
        
        if (!userDoc.exists) {
          // Create new user if doesn't exist
          final newUser = UserModel(
            uid: result.user!.uid,
            name: result.user!.displayName ?? 'Facebook User',
            email: result.user!.email ?? '',
            phone: result.user!.phoneNumber ?? '',
            role: AppConstants.roleCustomer,
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          
          await _firestore
              .collection(AppConstants.usersCollection)
              .doc(result.user!.uid)
              .set(newUser.toMap());
          
          currentUser.value = newUser;
        } else {
          await _loadUserData(result.user!.uid);
        }
        
        Log.i('Facebook login success: ${result.user!.email}');
        return currentUser.value;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      Log.e('Facebook login error: ${e.code}');
      throw _mapAuthError(e.code);
    } catch (e) {
      Log.e('Facebook login error', e);
      throw 'ເຂົ້າສູ່ລະບົບດ້ວຍ Facebook ບໍ່ສຳເລັດ';
    }
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'ບໍ່ພົບບັນຊີນີ້';
      case 'wrong-password':
        return 'ລະຫັດຜ່ານບໍ່ຖືກ';
      case 'email-already-in-use':
        return 'ອີເມລນີ້ຖືກໃຊ້ແລ້ວ';
      case 'weak-password':
        return 'ລະຫັດຜ່ານອ່ອນເກີນໄປ';
      case 'invalid-email':
        return 'ອີເມລບໍ່ຖືກຕ້ອງ';
      case 'too-many-requests':
        return 'ລອງຫຼາຍເກີນໄປ. ກະລຸນາລໍຖ້າ.';
      case 'network-request-failed':
        return 'ບໍ່ມີອິນເຕີເນັດ';
      case 'account-exists-with-different-credential':
        return 'ບັນຊີນີ້ມີຢູ່ແລ້ວດ້ວຍວິທີອື່ນ';
      case 'invalid-credential':
        return 'ຂໍ້ມູນການເຂົ້າສູ່ລະບົບບໍ່ຖືກຕ້ອງ';
      case 'operation-not-allowed':
        return 'ການເຂົ້າສູ່ລະບົບນີ້ຍັງບໍ່ໄດ້ເປີດໃຊ້ງານ';
      case 'user-disabled':
        return 'ບັນຊີນີ້ຖືກປິດໃຊ້ງານ';
      default:
        return 'ເກີດຂໍ້ຜິດພາດ ($code)';
    }
  }
}
