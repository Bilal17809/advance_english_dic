import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const RoundedButton({
    super.key,
    required this.child,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: child,
    );
    return onTap != null
        ? GestureDetector(onTap: onTap, child: button)
        : button;
  }
}





class AnimatedRoundedButton extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AnimatedRoundedButton({
    super.key,
    required this.child,
    this.backgroundColor,
    this.onTap,
  });

  @override
  State<AnimatedRoundedButton> createState() => _AnimatedRoundedButtonState();
}

class _AnimatedRoundedButtonState extends State<AnimatedRoundedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _borderOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _borderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _borderOpacity,
        builder: (context, child) {
          return Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blueAccent.withOpacity(_borderOpacity.value),
                width:4,
              ),
            ),
            alignment: Alignment.center,
            child: widget.child,
          );
        },
      ),
    );
  }
}



class AnimatedRoundedButton2 extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AnimatedRoundedButton2({
    super.key,
    required this.child,
    this.backgroundColor,
    this.onTap,
  });

  @override
  State<AnimatedRoundedButton2> createState() => _AnimatedRoundedButtonState2();
}

class _AnimatedRoundedButtonState2 extends State<AnimatedRoundedButton2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _borderOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _borderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _borderOpacity,
        builder: (context, child) {
          return Container(
            width: 42,
            height:42,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blueAccent.withOpacity(_borderOpacity.value),
                width:2,
              ),
            ),
            alignment: Alignment.center,
            child: widget.child,
          );
        },
      ),
    );
  }
}