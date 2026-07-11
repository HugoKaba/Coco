import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';

/// Style visuel du bouton.
enum AppButtonVariant {
  /// Fond plein couleur de marque, texte blanc.
  primary,

  /// Fond surface neutre, texte sur-surface.
  secondary,

  /// Contour marque, fond transparent.
  outline,
}

/// Bouton standard de l'app (design system).
///
/// Centralise le style des boutons : couleur de marque, rayon, typo et
/// espacements viennent des tokens. Gère un état de chargement et l'état
/// désactivé (quand [onPressed] est `null` ou pendant le chargement).
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;

  /// Prend toute la largeur disponible.
  final bool expand;

  /// Affiche un spinner et désactive le bouton.
  final bool isLoading;

  /// Surcharge ponctuelle de la couleur d'accent (fond en `primary`, contour/
  /// texte en `outline`). En général on laisse `null` = couleur de marque.
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

    final (bg, fg, border) = switch (variant) {
      AppButtonVariant.primary => (accent, Colors.white, null),
      AppButtonVariant.secondary => (
          cs.surfaceContainerHighest,
          cs.onSurface,
          null,
        ),
      AppButtonVariant.outline => (Colors.transparent, accent, accent),
    };

    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        : _content(fg);

    return SizedBox(
      width: expand ? double.infinity : null,
      child: TextButton(
        onPressed: enabled ? onPressed : null,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(bg),
          foregroundColor: WidgetStateProperty.all(fg),
          overlayColor: WidgetStateProperty.all(fg.withValues(alpha: 0.08)),
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: AppRadius.mdAll,
              side: border == null
                  ? BorderSide.none
                  : BorderSide(color: border, width: 1.5),
            ),
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _content(Color fg) {
    final text = Text(label, style: AppTextStyles.md.copyWith(color: fg));
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
