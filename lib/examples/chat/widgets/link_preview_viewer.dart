import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modernui/examples/chat/models/link_preview.dart';

class LinkPreviewViewer extends StatelessWidget {
  final LinkPreview linkPreview;

  const LinkPreviewViewer({Key key, @required this.linkPreview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (linkPreview == null) return Container(width: 0);
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: AspectRatio(
        aspectRatio: 12 / 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    child: linkPreview.image != null
                        ? CachedNetworkImage(
                            imageUrl: linkPreview.image,
                            fit: BoxFit.contain,
                            height: double.infinity,
                          )
                        : Text(""),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (linkPreview.title != null)
                          Text(
                            linkPreview.title,
                            style: TextStyle(
                                fontFamily: 'raleway',
                                fontWeight: FontWeight.bold),
                          ),
                        if (linkPreview.description != null) ...[
                          SizedBox(height: 5),
                          Expanded(
                            child: Text(
                              linkPreview.description,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  fontFamily: 'sans',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
