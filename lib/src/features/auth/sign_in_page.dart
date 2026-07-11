import 'package:coco/src/core/providers.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:coco/src/features/auth/widget/dark_text_field.dart';
import 'package:coco/src/features/auth/widget/input_label.dart';
import 'package:coco/src/features/auth/widget/primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});
  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  static const _accent = AppColors.brand;
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider);
    return Scaffold(
      appBar: AppBar(title: Text(tr('sign_in.title'))),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _accent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      const SizedBox(height: 36),
                      InputLabel(label: tr('sign_in.email_label')),
                      DarkTextField(
                        controller: _email,
                        hintText: tr('sign_in.email_label'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      InputLabel(label: tr('sign_in.password_label')),
                      DarkTextField(
                        controller: _password,
                        hintText: tr('sign_in.password_label'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 18),
                      PrimaryButton(
                        label: tr('sign_in.sign_in_email'),
                        accentColor: _accent,
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          try {
                            await auth.signInWithEmailAndPassword(
                              email: _email.text.trim(),
                              password: _password.text,
                            );
                          } catch (e) {
                            if (context.mounted) {
                              _snack('${tr('common.error')}: $e');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                PrimaryButton(
                  label: tr('sign_in.sign_in_button'),
                  icon: Icons.login,
                  accentColor: _accent,
                  onPressed: () async {
                    try {
                      await auth.signInWithGoogle();
                    } catch (e) {
                      if (context.mounted) _snack('${tr('common.error')}: $e');
                    }
                  },
                ),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: tr('sign_in.sign_in_apple'),
                  icon: Icons.apple,
                  onPressed: () {},
                  accentColor: _accent,
                ),
                const SizedBox(height: AppSpacing.xxl),
                Divider(color: Theme.of(context).dividerColor),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Professional Sign Up',
                  icon: Icons.business,
                  accentColor: _accent,
                  onPressed: () => context.push('/professional-signup'),
                ),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: tr('sign_in.register'),
                  accentColor: _accent,
                  onPressed: () => context.push('/register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
