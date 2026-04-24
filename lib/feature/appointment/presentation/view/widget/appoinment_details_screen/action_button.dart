import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isDisabled;
  final bool fullWidth;

  bool get _isTapEnabled => !isLoading && !isDisabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isTapEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            else
              Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
