import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class LinkPreview {
  final String title, description, image;

  LinkPreview({this.title = '', this.description = '', this.image});

  static Future<LinkPreview> fetch(String url) async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Document document = parse(response.body);
        final List<Element> elements = document.getElementsByTagName("meta");
        String title, description, image;

        for (final element in elements) {
          final property = element.attributes['property'];
          final content = element.attributes['content'];
          if (property == "og:title") {
            title = content;
          } else if (property == "og:description") {
            description = content;
          } else if (property == "og:image") {
            image = content;
          }
        }
        return LinkPreview(
            title: title, description: description, image: image);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static bool isUrl(String text) {
    return text.startsWith("http://") || text.startsWith("https://");
  }

  static bool hasUrl(String text) {
    return text.contains("http://") || text.contains("https://");
  }

  static String getUrlFromString(String text) {
    final urlRegExp = new RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    final matches = urlRegExp.allMatches(text);

    if (matches.length > 0) {
      final match = matches.elementAt(0);
      return text.substring(match.start, match.end);
    }
    return null;
  }
}
