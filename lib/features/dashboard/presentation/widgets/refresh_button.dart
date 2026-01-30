import 'package:flutter/material.dart';

class RefreshButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isRefreshing;

  const RefreshButton({
    super.key,
    required this.onPressed,
    this.isRefreshing = false,
  });

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(RefreshButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRefreshing && !oldWidget.isRefreshing) {
      _animationController.repeat();
    } else if (!widget.isRefreshing && oldWidget.isRefreshing) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.isRefreshing ? null : widget.onPressed,
      icon: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animationController.value * 2 * 3.14159,
            child: const Icon(Icons.refresh),
          );
        },
      ),
    );
  }
}
