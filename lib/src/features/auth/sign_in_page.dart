import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportlinker/src/core/providers.dart';
import 'package:easy_localization/easy_localization.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
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
      appBar: AppBar(title: Text(tr('sign_in.title'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: tr('sign_in.email_label'),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? tr('sign_in.enter_email')
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: tr('sign_in.password_label'),
                    ),
                    validator: (v) => (v == null || v.length < 6)
                        ? tr('sign_in.password_length')
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
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
                        child: Text(tr('sign_in.sign_in_email')),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final email = _emailController.text.trim();
                          final password = _passwordController.text;
                          try {
                            await auth.createUserWithEmailAndPassword(
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
                        child: Text(tr('sign_in.register')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: Text(tr('sign_in.sign_in_button')),
              onPressed: () async {
                final errorLabel = tr('common.error');
                try {
                  await auth.signInWithGoogle();
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('$errorLabel: $e')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
