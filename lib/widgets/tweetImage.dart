import 'package:flutter/material.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/enum.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:iuiuaa/state/feedState.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

class TweetImage extends StatelessWidget {
  const TweetImage(
      {Key key, this.model, this.type, this.isRetweetImage = false})
      : super(key: key);

  final FeedModel model;
  final TweetType type;
  final bool isRetweetImage;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      alignment: Alignment.centerRight,
      child: model.post_thumbnail == null || model.post_thumbnail.isEmpty
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(
                top: 8,
              ),
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(isRetweetImage ? 0 : 20),
                ),
                onTap: () {
                  Navigator.pushNamed(context, Constants.ImageViewPge, arguments: model.post_id);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(isRetweetImage ? 0 : 20),
                  ),
                  child: Container(
                    width: fullWidth(context) *
                            (type == TweetType.Detail ? .95 : .8) -
                        8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: customNetworkImage(model.post_thumbnail,
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
