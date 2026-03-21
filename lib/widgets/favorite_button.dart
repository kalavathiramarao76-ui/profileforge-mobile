import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FavoriteButton extends StatefulWidget {
  final bool isFavorited;
  final VoidCallback onToggle;

  const FavoriteButton({
    super.key,
    required this.isFavorited,
    required this.onToggle,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onToggle();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          widget.isFavorited ? Icons.star_rounded : Icons.star_outline_rounded,
          color: widget.isFavorited ? AppColors.favoriteGold : Colors.white54,
          size: 28,
        ),
      ),
    );
  }
}
