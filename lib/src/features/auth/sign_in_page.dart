import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/core/providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'register_page.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  static const Color _accentColor = Color(0xFFCD8232);
  static const Color _fieldColor = Color(0xFF1F1F1F);
  static final Color _inputInnerShadow = Colors.black.withOpacity(0.55);

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
                      _buildInputLabel(tr('sign_in.email_label')),
                      _buildDarkTextField(
                        controller: _emailController,
                        hintText: tr('sign_in.email_label'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      _buildInputLabel(tr('sign_in.password_label')),
                      _buildDarkTextField(
                        controller: _passwordController,
                        hintText: tr('sign_in.password_label'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 18),
                      _buildPrimaryButton(
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
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _buildPrimaryButton(
                  label: tr('sign_in.sign_in_button'),
                  icon: Icons.login,
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
                const SizedBox(height: 14),
                _buildPrimaryButton(
                  label: "Connexion avec Apple",
                  icon: Icons.apple,
                  onPressed: () {
                    // TODO: brancher Apple Sign-In
                  },
                ),
                const SizedBox(height: 14),
                _buildPrimaryButton(
                  label: tr('sign_in.register'),
                  onPressed: () {
                    context.push('/register');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDarkTextField({
    required TextEditingController controller,
    String hintText = "",
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return _buildInputWrapper(
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ).copyWith(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white54),
        ),
        validator: (v) {
          if (controller == _emailController) {
            return (v == null || v.isEmpty) ? tr('sign_in.enter_email') : null;
          }
          if (controller == _passwordController) {
            return (v == null || v.length < 6) ? tr('sign_in.password_length') : null;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildInputWrapper({required Widget child}) {
    final borderRadius = BorderRadius.circular(20);
    final borderColor = Colors.white.withOpacity(0.08);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _fieldColor,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: _inputInnerShadow,
            blurRadius: 15,
            offset: const Offset(0, 0),
            spreadRadius: 0,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(_accentColor),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
        child: icon == null
            ? Text(label)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              ),
      ),
    );
  }
}
