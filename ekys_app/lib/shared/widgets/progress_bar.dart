import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  final double percent; // 0.0 to 1.0
  final Color progressColor;
  final Color backgroundColor;
  final double lineHeight;
  final bool showLabel;
  final String? label;
  final EdgeInsetsGeometry padding;

  const ProgressBar({
    super.key,
    required this.percent,
    this.progressColor = AppColors.primary,
    this.backgroundColor = AppColors.surface,
    this.lineHeight = 8.0,
    this.showLabel = false,
    this.label,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final validPercent = percent.clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLabel || label != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: TextStyle(
                      fontSize: AppSizes.fontSm,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                if (showLabel)
                  Text(
                    '${(validPercent * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: AppSizes.fontSm,
                      fontWeight: FontWeight.bold,
                      color: progressColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
          ],
          LinearPercentIndicator(
            lineHeight: lineHeight,
            percent: validPercent,
            backgroundColor: isDark ? Colors.grey.shade800 : backgroundColor,
            progressColor: progressColor,
            barRadius: const Radius.circular(AppSizes.radiusFull),
            padding: EdgeInsets.zero,
            animation: true,
            animationDuration: 1000,
          ),
        ],
      ),
    );
  }
}
