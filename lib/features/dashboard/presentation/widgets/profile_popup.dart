import 'package:beszel_fpg/core/theme/theme_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_extensions.dart';

class ProfilePopup extends StatelessWidget {
  const ProfilePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager.instance,
      builder: (context, _) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            _showProfilePopup(context);
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

  void _showProfilePopup(BuildContext context) {
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
              padding: const EdgeInsets.all(16),
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
                    'idarau@flexipgroup.com',
                    style: TextStyle(
                      color: context.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Log Out Button
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: context.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      onPressed: () {
                        context.pushNamed('login_page');
                      },
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                          color: context.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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