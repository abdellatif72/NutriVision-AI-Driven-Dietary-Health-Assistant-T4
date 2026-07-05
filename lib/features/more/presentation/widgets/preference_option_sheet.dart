import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class PreferenceOptionSheet {
  static Future<String?> show({
    required BuildContext context,
    required String title,
    required String currentValue,
    required List<String> options,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AfiaColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(title, style: AfiaTypography.screenTitle),
                const SizedBox(height: 12),
                ...options.map(
                  (option) => ListTile(
                    title: Text(option, style: AfiaTypography.cardTitle),
                    trailing: option == currentValue
                        ? const Icon(
                            Icons.check_circle,
                            color: AfiaColors.primary,
                          )
                        : null,
                    onTap: () => Navigator.pop(ctx, option),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
