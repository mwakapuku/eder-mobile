import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// ── Model ─────────────────────────────────────────────────────────────────────
class DropdownItem {
  final int id;
  final String name;

  const DropdownItem({
    required this.id,
    required this.name,
  });

  factory DropdownItem.fromMap(Map<String, dynamic> e) {
    return DropdownItem(
      id: e['id'] as int,
      name: e['name'] as String,
    );
  }
}

// ── State ─────────────────────────────────────────────────────────────────────
class RegisterState {
  final bool loading;
  final String? error;
  final bool success;

  final List<DropdownItem> roles;
  final List<DropdownItem> regions;
  final List<DropdownItem> districts;
  final List<DropdownItem> wards;

  final bool rolesLoading;
  final bool regionsLoading;
  final bool districtsLoading;
  final bool wardsLoading;

  const RegisterState({
    this.loading = false,
    this.error,
    this.success = false,
    this.roles = const [],
    this.regions = const [],
    this.districts = const [],
    this.wards = const [],
    this.rolesLoading = false,
    this.regionsLoading = false,
    this.districtsLoading = false,
    this.wardsLoading = false,
  });

  RegisterState copyWith({
    bool? loading,
    String? error,
    bool? success,
    List<DropdownItem>? roles,
    List<DropdownItem>? regions,
    List<DropdownItem>? districts,
    List<DropdownItem>? wards,
    bool? rolesLoading,
    bool? regionsLoading,
    bool? districtsLoading,
    bool? wardsLoading,
    bool clearError = false,
  }) {
    return RegisterState(
      loading: loading ?? this.loading,
      error: clearError ? null : error ?? this.error,
      success: success ?? this.success,
      roles: roles ?? this.roles,
      regions: regions ?? this.regions,
      districts: districts ?? this.districts,
      wards: wards ?? this.wards,
      rolesLoading: rolesLoading ?? this.rolesLoading,
      regionsLoading: regionsLoading ?? this.regionsLoading,
      districtsLoading: districtsLoading ?? this.districtsLoading,
      wardsLoading: wardsLoading ?? this.wardsLoading,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────
class RegisterNotifier extends StateNotifier<RegisterState> {
  final AuthService _service;

  RegisterNotifier(this._service) : super(const RegisterState());

  // ── Init ────────────────────────────────────────────────────────────────────
  Future<void> init({String token = ''}) async {
    await Future.wait([
      loadRoles(token),
      loadRegions(token),
    ]);
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  List<DropdownItem> _mapList(List<dynamic> raw) {
    return raw.map((e) => DropdownItem.fromMap(e)).toList();
  }

  void _setError(String message) {
    state = state.copyWith(error: message, loading: false);
  }

  // ── Loaders ─────────────────────────────────────────────────────────────────
  Future<void> loadRoles(String token) async {
    state = state.copyWith(rolesLoading: true, clearError: true);
    try {
      final res = await _service.fetchRoles(token);
      state = state.copyWith(
        roles: _mapList(res),
        rolesLoading: false,
      );
    } catch (_) {
      state = state.copyWith(
        rolesLoading: false,
        error: 'Failed to load roles',
      );
    }
  }

  Future<void> loadRegions(String token) async {
    state = state.copyWith(regionsLoading: true);
    try {
      final res = await _service.fetchRegions(token);
      state = state.copyWith(
        regions: _mapList(res),
        regionsLoading: false,
      );
    } catch (_) {
      state = state.copyWith(
        regionsLoading: false,
        error: 'Failed to load regions',
      );
    }
  }

  Future<void> onRegionChanged(int regionId, {String token = ''}) async {
    state = state.copyWith(
      districtsLoading: true,
      districts: [],
      wards: [],
    );

    try {
      final res = await _service.fetchDistricts(token, regionId);
      state = state.copyWith(
        districts: _mapList(res),
        districtsLoading: false,
      );
    } catch (_) {
      state = state.copyWith(
        districtsLoading: false,
        error: 'Failed to load districts',
      );
    }
  }

  Future<void> onDistrictChanged(int districtId, {String token = ''}) async {
    state = state.copyWith(
      wardsLoading: true,
      wards: [],
    );

    try {
      final res = await _service.fetchWards(token, districtId);
      state = state.copyWith(
        wards: _mapList(res),
        wardsLoading: false,
      );
    } catch (_) {
      state = state.copyWith(
        wardsLoading: false,
        error: 'Failed to load wards',
      );
    }
  }

  // ── Register ────────────────────────────────────────────────────────────────
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phone,
    required String password,
    required int groupId,
    required int regionId,
    required int districtId,
    required int wardId,
  }) async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final res = await _service.register(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phone: phone,
        password: password,
        groupId: groupId,
        regionId: regionId,
        districtId: districtId,
        wardId: wardId,
      );

      if (res['success'] == true) {
        state = state.copyWith(loading: false, success: true);
        return true;
      }

      _setError(res['message'] ?? 'Registration failed');
      return false;
    } catch (e) {
      _setError('Something went wrong');
      return false;
    }
  }

  // ── Reset (useful after success) ─────────────────────────────────────────────
  void reset() {
    state = const RegisterState();
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────
final registerProvider =
StateNotifierProvider<RegisterNotifier, RegisterState>(
      (ref) => RegisterNotifier(AuthService()),
);