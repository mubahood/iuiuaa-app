import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';

class LinkPreview extends StatelessWidget {
  const LinkPreview({Key key, this.url, this.text}) : super(key: key);
  final String url;
  final String text;

  /// Extract the url from text
  /// If text contains multiple weburl then only first url will be returned to fetch the url meta
  String getUrl() {
    if (text == null) {
      return null;
    }
    RegExp reg = RegExp(
        r"([#])\w+| [@]\w+|(https?|ftp|file|#)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]*");
    Iterable<Match> _matches = reg.allMatches(text);
    if (_matches.isNotEmpty) {
      return _matches.first.group(0);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var uri = url ?? getUrl();
    if (uri == null) {
      return SizedBox.shrink();
    }
    return Text("FlutterLinkPreview");
  }
}
