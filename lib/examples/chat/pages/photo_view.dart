import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Hero(
        tag: widget.heroTag,
        child: PhotoView(
          imageProvider: widget.fromNetwork
              ? CachedNetworkImageProvider(widget.imageData)
              : FileImage(File(widget.imageData)),
        ),
      ),
    ));
  }
}
