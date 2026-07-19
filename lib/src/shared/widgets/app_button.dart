import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';

/// Style visuel du bouton.
enum AppButtonVariant {
  /// Fond dégradé couleur de marque, texte blanc.
  primary,

  /// Fond surface neutre, texte sur-surface.
  secondary,

  /// Contour marque, fond transparent.
  outline,

  /// Texte seul, sans fond ni contour (action secondaire/dismiss).
  text,
}

/// Bouton standard de l'app (design system).
///
/// Le variant `primary` est un CTA "bold" : dégradé de marque + glow. Gère un
/// état de chargement et l'état désactivé.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;

  /// Prend toute la largeur disponible.
  final bool expand;

  /// Affiche un spinner et désactive le bouton.
  final bool isLoading;

  /// Surcharge ponctuelle de la couleur d'accent. En général `null` = marque.
  final Color? color;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expand = true,
    this.isLoading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final enabled = onPressed != null && !isLoading;
    final accent = color ?? AppColors.brand;
    final isPrimary = variant == AppButtonVariant.primary;

    // Couleurs texte / fond selon le variant.
    final fg = switch (variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.secondary => cs.onSurface,
      AppButtonVariant.outline => accent,
      AppButtonVariant.text => cs.onSurfaceVariant,
    };

    // Fond : dégradé pour primary, couleur pleine sinon.
    final gradient = isPrimary && enabled
        ? (color == null
              ? AppColors.brandGradient
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color.lerp(accent, Colors.white, 0.18)!, accent],
                ))
        : null;
    final bg = switch (variant) {
      AppButtonVariant.primary => enabled ? null : accent.withValues(alpha: 0.4),
      AppButtonVariant.secondary => cs.surfaceContainerHighest,
      AppButtonVariant.outline => Colors.transparent,
      AppButtonVariant.text => Colors.transparent,
    };

    final decoration = BoxDecoration(
      borderRadius: AppRadius.mdAll,
      gradient: gradient,
      color: bg,
      border: variant == AppButtonVariant.outline
          ? Border.all(color: accent, width: 1.5)
          : null,
      // Glow orange sous le CTA primary.
      boxShadow: isPrimary && enabled
          ? [
              BoxShadow(
                color: accent.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ]
          : null,
    );

    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        : _content(fg);

    return SizedBox(
      width: expand ? double.infinity : null,
      child: DecoratedBox(
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.mdAll,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Center(
                widthFactor: expand ? null : 1,
                heightFactor: 1,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(Color fg) {
    final text = Text(
      label,
      style: AppTextStyles.md.copyWith(color: fg, fontWeight: FontWeight.w700),
    );
    if (icon == null) return text;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: fg, size: 20),
        const SizedBox(width: AppSpacing.sm),
        text,
      ],
    );
  }
}
