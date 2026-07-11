import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Écran de démarrage : logo centré (fond adaptatif dark/light), petite
/// animation d'entrée, puis redirection automatique vers l'app. La logique
/// d'authentification du router se charge d'envoyer l'utilisateur au bon
/// endroit (`/swipe` si connecté, sinon `/` via le redirect global).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    // Laisse le logo respirer, puis on entre dans l'app.
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (mounted) context.go('/swipe');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: SvgPicture.asset(
              'assets/images/combinationmark.svg',
              width: 260,
            ),
          ),
        ),
      ),
    );
  }
}
