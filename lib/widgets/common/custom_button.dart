import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isSecondary;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  void _handleTap() {
    if (widget.isLoading) return;
    HapticFeedback.lightImpact();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: 200.ms,
        curve: Curves.easeOutCubic,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: widget.isSecondary ? null : AppTheme.primaryGradient,
          color: widget.isSecondary ? Theme.of(context).cardTheme.color : null,
          border: widget.isSecondary 
            ? Border.all(color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white.withValues(alpha: 0.1) 
                : const Color(0xFFE4E4E7)) 
            : null,
          boxShadow: widget.isLoading || _isPressed ? null : (widget.isSecondary ? AppTheme.softShadow : AppTheme.premiumShadow),
        ),
        child: Center(
          child: widget.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: widget.isSecondary ? AppTheme.primaryColor : Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: widget.isSecondary ? AppTheme.primaryColor : Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
        ),
      )
          .animate(target: _isPressed ? 1 : 0)
          .scale(begin: const Offset(1, 1), end: const Offset(0.97, 0.97), duration: 150.ms),
    );
  }
}
