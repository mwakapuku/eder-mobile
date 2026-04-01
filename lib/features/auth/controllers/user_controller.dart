import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

// --- State ---
class UserProfileState {
  final UserModel? user;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  const UserProfileState({
    this.user,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  UserProfileState copyWith({
    UserModel? user,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) =>
      UserProfileState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        error: error,
      );
}

// --- Notifier ---
class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final UserService _service = UserService();

  UserProfileNotifier() : super(const UserProfileState()) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _service.getProfile();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> updateProfile(UserModel updated) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      final user = await _service.updateProfile(updated);
      state = state.copyWith(user: user, isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      await _service.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }
}

// --- Provider ---
final userProfileProvider =
StateNotifierProvider<UserProfileNotifier, UserProfileState>(
      (ref) => UserProfileNotifier(),
);