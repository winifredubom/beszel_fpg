import 'package:beszel_fpg/core/theme/theme_manager.dart';
import 'package:beszel_fpg/core/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/network/pocketbase_provider.dart';

class ProfilePopup extends ConsumerWidget {
  const ProfilePopup({super.key});

  /// Check if the current user is an admin
  static bool _isAdmin() {
    final role = StorageService.getString('user_role');
    return role == 'admin';
  }

  /// Opens PocketBase admin login page in external browser
  static Future<void> _openPocketBaseAdmin() async {
    const pocketBaseAdminUrl = 'https://beszel.flexipgroup.com/_/#/login';
    final uri = Uri.parse(pocketBaseAdminUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: ThemeManager.instance,
      builder: (context, _) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            _showProfilePopup(context, ref);
          },
          child: Icon(
            CupertinoIcons.person_solid,
            color: context.textColor,
            size: 20,
          ),
        );
      },
    );
  }

  void _showProfilePopup(BuildContext context, WidgetRef ref) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset topRight = button.localToGlobal(button.size.topRight(Offset.zero));
    
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Stack(
        children: [
          Positioned(
            top: topRight.dy + button.size.height + 8,
            right: 16, // Align with app bar padding
            child: Container(
              width: 240,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: context.borderColor,
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Email
                  Text(
                    () {
                      final stored = StorageService.getString('user_email');
                      if (stored != null && stored.isNotEmpty) return stored;
                      try {
                        final model = ref.read(pocketBaseProvider).authStore.model;
                        final data = model?.data ?? const {};
                        final email = (data['email'] as String?) ?? (data['username'] as String?);
                        return email ?? '—';
                      } catch (_) {
                        return '—';
                      }
                    }(),
                    style: TextStyle(
                      color: context.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Divider under email
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: context.borderColor,
                  ),
                  const SizedBox(height: 6),
                  // Menu items - Admin only items
                  if (_isAdmin()) ...[
                    _PopupItem(
                      icon: CupertinoIcons.person_2,
                      label: 'Users'.tr(),
                      onTap: () {
                        Navigator.of(context).pop();
                        _openPocketBaseAdmin();
                      },
                      textColor: context.textColor,
                      hoverColor: context.backgroundColor,
                    ),
                    _PopupItem(
                      icon: CupertinoIcons.squares_below_rectangle,
                      label: 'Systems'.tr(),
                      onTap: () {
                        Navigator.of(context).pop();
                        _openPocketBaseAdmin();
                      },
                      textColor: context.textColor,
                      hoverColor: context.backgroundColor,
                    ),
                    _PopupItem(
                      icon: CupertinoIcons.list_bullet,
                      label: 'Logs'.tr(),
                      onTap: () {
                        Navigator.of(context).pop();
                        _openPocketBaseAdmin();
                      },
                      textColor: context.textColor,
                      hoverColor: context.backgroundColor,
                    ),
                    _PopupItem(
                      icon: CupertinoIcons.archivebox,
                      label: 'Backups'.tr(),
                      onTap: () {
                        Navigator.of(context).pop();
                        _openPocketBaseAdmin();
                      },
                      textColor: context.textColor,
                      hoverColor: context.backgroundColor,
                    ),
                     const SizedBox(height: 6),
                  // Divider before logout
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: context.borderColor,
                  ),
                  ],
                 
                  const SizedBox(height: 6),
                  _PopupItem(
                    icon: CupertinoIcons.square_arrow_left,
                    label: 'Log Out'.tr(),
                    onTap: () {
                      Navigator.of(context).pop();
                      // Clear auth state
                      try {
                        ref.read(pocketBaseProvider).authStore.clear();
                      } catch (_) {}
                      // Remove only auth-related keys
                      StorageService.remove('access_token');
                      StorageService.remove('user_email');
                      StorageService.remove('user_role');
                      context.pushNamed('login_page');
                    },
                    textColor: context.textColor,
                    hoverColor: context.backgroundColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopupItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color textColor;
  final Color hoverColor;

  const _PopupItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.textColor,
    required this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      onPressed: onTap,
      color: Colors.transparent,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}