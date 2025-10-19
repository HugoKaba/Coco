import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportlinker/src/core/providers.dart';
import 'package:sportlinker/src/l10n/localization.dart';

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
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('sign_in_title'))),
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
                      labelText: loc.t('email_label'),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? loc.t('enter_email') : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: loc.t('password_label'),
                    ),
                    validator: (v) => (v == null || v.length < 6)
                        ? loc.t('password_length')
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
                              SnackBar(content: Text('${loc.t('error')}: $e')),
                            );
                          }
                        },
                        child: Text(loc.t('sign_in_email')),
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
                              SnackBar(content: Text('${loc.t('error')}: $e')),
                            );
                          }
                        },
                        child: Text(loc.t('register')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: Text(loc.t('sign_in_button')),
              onPressed: () async {
                final errorLabel = loc.t('error');
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
