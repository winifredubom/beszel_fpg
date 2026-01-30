import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class SwipeNavigation extends StatefulWidget {
  final Widget child;
  final bool canSwipeBack;
  
  const SwipeNavigation({
    super.key,
    required this.child,
    this.canSwipeBack = true,
  });

  @override
  State<SwipeNavigation> createState() => _SwipeNavigationState();
}

class _SwipeNavigationState extends State<SwipeNavigation> {
  double _startDragX = 0;
  bool _isDragging = false;
  double _dragDistance = 0;
  
  void _onHorizontalDragStart(DragStartDetails details) {
    if (!widget.canSwipeBack) return;
    
    setState(() {
      _isDragging = true;
      _startDragX = details.localPosition.dx;
      _dragDistance = 0;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!widget.canSwipeBack || !_isDragging) return;

    setState(() {
      _dragDistance = details.localPosition.dx - _startDragX;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (!widget.canSwipeBack || !_isDragging) return;

    final velocity = details.primaryVelocity ?? 0;
    final distance = _dragDistance.abs();
    
    // If dragged more than 1/3 of screen width or with sufficient velocity
    if (distance > MediaQuery.of(context).size.width / 3 || 
        velocity.abs() > 1000) {
      if (_dragDistance > 0) {
        // Swipe right - go back to dashboard
        context.go(AppRoutes.dashboard);
      }
    }

    setState(() {
      _isDragging = false;
      _dragDistance = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(
          _dragDistance.clamp(0, MediaQuery.of(context).size.width),
          0,
          0,
        ),
        child: widget.child,
      ),
    );
  }
}