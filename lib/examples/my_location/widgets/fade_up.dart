import 'dart:async';

import 'package:flutter/material.dart';

class FadeUp extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final double from;
  final int delayed;

  const FadeUp(
      {Key key,
      this.duration = const Duration(milliseconds: 500),
      @required this.child,
      this.from = 200,
      this.delayed = 0})
      : assert(child != null),
        super(key: key);
  @override
  _FadeUpState createState() => _FadeUpState();
}

class _FadeUpState extends State<FadeUp> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: widget.from, end: 0).animate(_controller);
    _animation.addListener(() {});
    Timer(Duration(milliseconds: widget.delayed), () => _controller.forward());
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, w) {
        final opacity = 1 - (_animation.value / widget.from);
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Opacity(opacity: opacity, child: w),
        );
      },
      child: widget.child,
    );
  }
}
