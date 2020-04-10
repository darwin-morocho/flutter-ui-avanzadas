import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatefulWidget {
  final String imageData, heroTag;
  final bool fromNetwork;

  const PhotoViewPage(
      {Key key,
      @required this.imageData,
      this.fromNetwork = false,
      @required this.heroTag})
      : super(key: key);
  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  ValueNotifier<bool> _visible = ValueNotifier<bool>(false);
  Timer _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _timer?.cancel();
                  _visible.value = !_visible.value;
                  if (_visible.value) {
                    _timer = Timer(Duration(seconds: 4), () {
                      _visible.value = false;
                    });
                  }
                },
                child: Hero(
                  tag: widget.heroTag,
                  child: PhotoView(
                    imageProvider: widget.fromNetwork
                        ? CachedNetworkImageProvider(widget.imageData)
                        : FileImage(
                            File(widget.imageData),
                          ),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _visible,
                builder: (_, bool visible, child) {
                  return AnimatedPositioned(
                    child: child,
                    top: visible ? 10 : -80,
                    left: 15,
                    duration: Duration(milliseconds: 300),
                  );
                },
                child: CupertinoButton(
                  color: Color(0xffdddddd).withOpacity(0.2),
                  padding: EdgeInsets.all(15),
                  minSize: 30,
                  borderRadius: BorderRadius.circular(30),
                  child: SvgPicture.asset(
                    'assets/cancel.svg',
                    width: 25,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ),
        ));
  }
}
