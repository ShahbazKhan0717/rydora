import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/rydora_button.dart';
import '../../../core/widgets/rydora_text_field.dart';
import '../application/profile_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _name = TextEditingController(text: profile.name);
    _phone = TextEditingController(text: profile.phone);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(userProfileProvider.notifier)
        .update(name: _name.text, phone: _phone.text);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile updated')));
    context.pop();
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
                RydoraButton(label: 'Save changes', onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
