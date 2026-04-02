import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/register_controller.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  DropdownItem? role;
  DropdownItem? region;
  DropdownItem? district;
  DropdownItem? ward;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(registerProvider.notifier).init(token: '');
    });
  }

  @override
  void dispose() {
    for (final c in [
      _firstName,
      _lastName,
      _username,
      _email,
      _phone,
      _password,
      _confirm
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (role == null || region == null || district == null || ward == null) {
      _show('Please complete all fields');
      return;
    }

    final success = await ref.read(registerProvider.notifier).register(
      firstName: _firstName.text,
      lastName: _lastName.text,
      username: _username.text,
      email: _email.text,
      phone: _phone.text,
      password: _password.text,
      groupId: role!.id,
      regionId: region!.id,
      districtId: district!.id,
      wardId: ward!.id,
    );

    if (!mounted) return;

    if (success) {
      _show('Account created');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      _show(ref.read(registerProvider).error ?? 'Failed');
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _input(_firstName, 'First Name'),
              _input(_lastName, 'Last Name'),
              _input(_username, 'Username'),
              _input(_email, 'Email'),
              _input(_phone, 'Phone'),
              _input(_password, 'Password', obscure: true),
              _input(_confirm, 'Confirm Password', obscure: true),

              const SizedBox(height: 16),

              _dropdown(
                hint: 'Role',
                value: role,
                items: state.roles,
                onChanged: (v) => setState(() => role = v),
              ),

              _dropdown(
                hint: 'Region',
                value: region,
                items: state.regions,
                onChanged: (v) {
                  setState(() {
                    region = v;
                    district = null;
                    ward = null;
                  });
                  if (v != null) {
                    ref.read(registerProvider.notifier)
                        .onRegionChanged(v.id, token: '');
                  }
                },
              ),

              _dropdown(
                hint: 'District',
                value: district,
                items: state.districts,
                onChanged: (v) {
                  setState(() {
                    district = v;
                    ward = null;
                  });
                  if (v != null) {
                    ref.read(registerProvider.notifier)
                        .onDistrictChanged(v.id, token: '');
                  }
                },
              ),

              _dropdown(
                hint: 'Ward',
                value: ward,
                items: state.wards,
                onChanged: (v) => setState(() => ward = v),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.loading ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary, // primary color
                    foregroundColor: Colors.white, // text color
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: state.loading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white, // loader color
                    ),
                  )
                      : const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Already have an account? Login'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String hint,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (v) =>
        v == null || v.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required DropdownItem? value,
    required List<DropdownItem> items,
    required ValueChanged<DropdownItem?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<DropdownItem>(
        value: value,
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e.name),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}