import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snack.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/rydora_button.dart';
import '../../../core/widgets/rydora_text_field.dart';
import '../../../data/providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider).value;
    _name = TextEditingController(text: user?.name ?? '');
    _phone = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final authUser = ref.read(authStateProvider).value;
    if (authUser == null) return;
    setState(() => _loading = true);
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.ensureProfile(
        uid: authUser.uid,
        email: authUser.email ?? '',
        name: _name.text,
        phone: _phone.text,
      );
      await repo.updateProfile(
        uid: authUser.uid,
        name: _name.text,
        phone: _phone.text,
      );
      if (!mounted) return;
      showSnack(context, 'Profile updated');
      context.pop();
    } on AppException catch (e) {
      if (mounted) showSnack(context, e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                RydoraTextField(
                  label: 'Full name',
                  controller: _name,
                  validator: (v) => Validators.required(v, 'Name'),
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: AppSpacing.md),
                RydoraTextField(
                  label: 'Phone number (optional)',
                  controller: _phone,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? null
                      : Validators.phone(v),
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSpacing.lg),
                RydoraButton(
                  label: 'Save changes',
                  isLoading: _loading,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
