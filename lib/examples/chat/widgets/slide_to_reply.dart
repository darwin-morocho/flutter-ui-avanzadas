import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum SlideToReplyDirection { left, right }

class SlideToReply extends StatefulWidget {
  final Widget child;
  final SlideToReplyDirection from;
  final VoidCallback onReply;

  const SlideToReply(
      {Key key,
      @required this.child,
      this.from = SlideToReplyDirection.left,
      this.onReply})
      : assert(child != null),
        super(key: key);
  @override
  _SlideToReplyState createState() => _SlideToReplyState();
}

class _SlideToReplyState extends State<SlideToReply>
    with AutomaticKeepAliveClientMixin {
  final double _threshold = 40;
  ValueNotifier<double> _move = ValueNotifier<double>(0);
  ValueNotifier<bool> _show = ValueNotifier<bool>(false);

  double get _overallDragAxisExtent {
    final Size size = context.size;
    return size.width;
  }

  double get _actionsDragAxisExtent {
    return _overallDragAxisExtent * _threshold;
  }

  bool get _fromLeft {
    return widget.from == SlideToReplyDirection.left;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onHorizontalDragStart(DragStartDetails details) {
    _move.value = _actionsDragAxisExtent * _move.value.sign;
    //stop the animation
    _show.value = true;
  }

  _onHorizontalDragEnd(DragEndDetails details) {
    print("move ${_move.value}");
    if (_move.value.abs().round() >= _threshold - 1 && widget.onReply != null) {
      widget.onReply();
    }
    _move.value = 0;
    _show.value = false;
  }

  _onHorizontalDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta;
    final move = _move.value + delta;
    if (move >= 0 && move <= _threshold && _fromLeft) {
      _move.value = move;
    } else if (move >= -_threshold && move <= 0 && !_fromLeft) {
      _move.value = move;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      child: Stack(
        alignment: _fromLeft ? Alignment.centerLeft : Alignment.centerRight,
        children: <Widget>[
          ValueListenableBuilder(
            valueListenable: _show,
            builder: (BuildContext context, bool value, Widget child) {
              return Positioned(
                  left: _fromLeft ? 20 : null,
                  right: _fromLeft ? null : 20,
                  child: AnimatedOpacity(
                      opacity: value ? 1 : 0,
                      child: child,
                      duration: Duration(milliseconds: 400)));
            },
            child: SvgPicture.asset(
              'assets/chat/reply.svg',
              width: 20,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _move,
            builder: (BuildContext context, double value, Widget child) {
              return Transform.translate(
                offset: Offset(value, 0),
                child: child,
              );
            },
            child: widget.child,
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
