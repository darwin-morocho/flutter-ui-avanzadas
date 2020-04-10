import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modernui/examples/chat/models/stickers.dart';
import 'package:modernui/utils/config.dart';

class StickersPicker extends StatefulWidget {
  const StickersPicker({Key key}) : super(key: key);

  @override
  _StickersPickerState createState() => _StickersPickerState();
}

class _StickersPickerState extends State<StickersPicker>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: Stickers.all.length, vsync: this);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6 / 5,
      child: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
                child: TabBarView(
                    controller: _controller,
                    children: List.generate(Stickers.all.length, (index) {
                      final Stickers stickers = Stickers.all[index];
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                        itemBuilder: (_, index) {
                          final item = stickers.items[index];
                          return CachedNetworkImage(
                            imageUrl: item,
                            fit: BoxFit.cover,
                            height: double.infinity,
                            placeholder: (_, __) => Center(
                              child: CupertinoActivityIndicator(radius: 15),
                            ),
                          );
                        },
                        itemCount: stickers.items.length,
                      );
                    }))),
            TabBar(
              indicator: CustomTabIndicator(),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black54,
              tabs: List.generate(Stickers.all.length, (index) {
                final Stickers stickers = Stickers.all[index];
                return Tab(
                  text: stickers.name,
                );
              }),
              indicatorWeight: 4,
              controller: _controller,
            )
          ],
        ),
      ),
    );
  }
}

class CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return new _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    //offset is the position from where the decoration should be drawn.
    //configuration.size tells us about the height and width of the tab.
    final Rect rect = Rect.fromLTWH(
        offset.dx + 2,
        configuration.size.height / 2 - 30 / 2,
        configuration.size.width - 4,
        30);
    final Paint paint = Paint();
    paint.color = AppColors.primary;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(30.0)), paint);
  }
}
