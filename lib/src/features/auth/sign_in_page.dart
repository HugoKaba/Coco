import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:coco/src/core/providers.dart';
import 'package:easy_localization/easy_localization.dart';

import 'widget/dark_text_field.dart';
import 'widget/primary_button.dart';
import 'widget/input_label.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  static const Color _accentColor = Color(0xFFCD8232);
  static const Color _fieldColor = Color(0xFF1F1F1F);
  static final Color _inputInnerShadow = Colors.black.withValues(alpha: 0.55);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        title: Text(tr('sign_in.title')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _accentColor,
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      const SizedBox(height: 36),
                      InputLabel(label: tr('sign_in.email_label')),
                      DarkTextField(
                        controller: _emailController,
                        hintText: tr('sign_in.email_label'),
                        keyboardType: TextInputType.emailAddress,
                        fieldColor: _fieldColor,
                        innerShadow: _inputInnerShadow,
                      ),
                      const SizedBox(height: 20),
                      InputLabel(label: tr('sign_in.password_label')),
                      DarkTextField(
                        controller: _passwordController,
                        hintText: tr('sign_in.password_label'),
                        obscureText: true,
                        fieldColor: _fieldColor,
                        innerShadow: _inputInnerShadow,
                      ),
                      const SizedBox(height: 18),
                      PrimaryButton(
                        label: tr('sign_in.sign_in_email'),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final email = _emailController.text.trim();
                          final password = _passwordController.text;
                          try {
                            await auth.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${tr('common.error')}: $e'),
                              ),
                            );
                          }
                        },
                        accentColor: _accentColor,
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                PrimaryButton(
                  label: tr('sign_in.sign_in_button'),
                  icon: Icons.login,
                  onPressed: () async {
                    final errorLabel = tr('common.error');
                    try {
                      await auth.signInWithGoogle();
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$errorLabel: $e')),
                      );
                    }
                  },
                  accentColor: _accentColor,
                ),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: tr('sign_in.sign_in_apple'),
                  icon: Icons.apple,
                  onPressed: () {},
                  accentColor: _accentColor,
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white24),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Professional Sign Up',
                  icon: Icons.business,
                  onPressed: () {
                    context.push('/professional-signup');
                  },
                  accentColor: const Color(0xFFCD8232),
                ),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: tr('sign_in.register'),
                  onPressed: () {
                    context.push('/register');
                  },
                  accentColor: _accentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
