import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../appBarData.dart';
import '../fbData.dart';
import '../sizes.dart';
import '../style.dart';
import 'custom_widget.dart';

class FacebookBody extends StatefulWidget {
  final int screenIndex;
  final List<TabScreen> tabScreens;
  @required
  final Widget firstPanel;
  @required
  final Widget Function(TabScreen tabScreen, double bodyPadding)
      mainPanelBuilder;
  @required
  final Widget lastPanel;

  FacebookBody(
      {this.screenIndex: 0,
      this.tabScreens,
      this.firstPanel,
      this.mainPanelBuilder,
      this.lastPanel});

  @override
  _FacebookBodyState createState() => _FacebookBodyState();
}

class _FacebookBodyState extends State<FacebookBody> {
  double lastScreenWidth = 0;
  double last2PanelGap = 0;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.screenIndex,
      children: widget.tabScreens.map((tabScreen) {
        double gap = isOnlyBody(context)
            ? getSingleMainContGap(screenWidth(context))
            : getMultiPanelGap(screenWidth(context));
        if (tabScreen.title != HomeTitle)
          return tabScreen.screen;
        else
          return Scaffold(
              body: Container(
            color: FbStyle.fbBackground,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                if (isAtLeastLarge(context))
                  Expanded(
                    flex: 19,
                    child: widget.firstPanel,
                  ),
                SizedBox(width: gap),
                Expanded(
                  flex: 40,
                  child: widget.mainPanelBuilder(
                      tabScreen, getBodyPadding(context)),
                ),
                SizedBox(width: gap),
                if (!isOnlyBody(context))
                  Expanded(
                    flex: 19,
                    child: widget.lastPanel,
                  ),
              ],
            ),
          ));
      }).toList(),
    );
  }

  double getBodyPadding(BuildContext context) {
    double bodyPadding = 0;
    if (isRequirePadWidth(context)) {
      var screenWidth2 = screenWidth(context);
      bodyPadding = calcLargerBodyPadding(screenWidth2);
      lastScreenWidth = screenWidth2;
    } else if (isStopBodyPadWidth(context)) {
      lastScreenWidth = lastScreenWidth > 0 ? lastScreenWidth : noGap4BodyWidth;
      bodyPadding = calcLargerBodyPadding(lastScreenWidth);
    } else if (isSmallerScreen(context)) {
      var screenWidth2 = screenWidth(context);
      bodyPadding = calcSmallerBodyPadding(screenWidth2);
      lastScreenWidth = screenWidth2;
    } else if (isSmallScreen(context)) {
      bodyPadding = calcBodyPaddingStatic;
    } else if (isMediumScreen(context) /*|| isSmallScreen(context)*/) {
      bodyPadding = calcBodyPaddingStatic;
    } else if (isAtLeastLarge(context))
      bodyPadding = 0;
    else {
      bodyPadding = 0;
    }
//    print("last Width is $lastScreenWidth");
    print("body Padding is $bodyPadding");
    return bodyPadding;
  }

  double getSingleMainContGap(double screenWidth) {
    double gap = calcSingleBodyGap(screenWidth);
    print("Main contFlex is $gap");
    if (isSmallerScreen(context))
      return 0;
    else
      return gap > 0 ? gap : 0;
  }

  double getMultiPanelGap(double screenWidth) {
    if (isStopTwoPanelGap(context)) {
      last2PanelGap = last2PanelGap > 0
          ? last2PanelGap
          : calcTwoPanelGap(noGap4TwoPanelWidth - 2.0);
      return last2PanelGap;
    } else if (isAtLeastLarge(context)) {
      if (isStopBodyPadWidth(context))
        return calcThreePanelGap(screenWidth) /*screenWidth*0.04*/;
      else
        return calcThreePanelGap(noBodyPadWidth + 10);
    } else {
      var gap = calcTwoPanelGap(screenWidth);
      last2PanelGap = gap;
      return gap;
    }
  }

  double calcThreePanelGap(double screenWidth) {
    var gap = ((screenWidth - extraLargeSize) + 90) / 2.0;
    print("Three Panel gap is $gap");
    return gap > 0 ? gap : 0;
//    return calcSingleBodyGap(screenWidth) * 0.29;
  }

  double calcTwoPanelGap(double screenWidth) {
    var gap = ((screenWidth - largeSize) + 230) / 2.0;
    print("Two pannel gap is $gap");
    return gap > 0 ? gap : 0;
//    return calcSingleBodyGap(screenWidth) * 0.29;
  }

  double calcSingleBodyGap(double screenWidth) {
    var gap = ((screenWidth - onlyBodyWidth) + 300) / 2.0;
    return gap > 0 ? gap : 0;
  }

  double calcLargerBodyPadding(double screenWidth) {
    return calcBodyPadding(screenWidth, noBodyPadWidth);
  }

  double calcSmallerBodyPadding(double screenWidth) {
    return calcBodyPadding(screenWidth, smallerSize);
  }

  double calcBodyPadding(double screenWidth, double noBodyPadWidth) {
    var bodyPadding = ((screenWidth - noBodyPadWidth) + 100) / 2.0;
    return bodyPadding > 0 ? bodyPadding : 0;
  }

  double get calcBodyPaddingStatic => calcLargerBodyPadding(noGap4BodyWidth);
}

class MainBodyPanel extends StatelessWidget {
  const MainBodyPanel(
    this.tabScreen,
    this.bodyPadding, {
    Key key,
    @required this.scrollController,
  }) : super(key: key);
  final TabScreen tabScreen;
  final bodyPadding;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        children: [
          if (isMobileScreen(context))
            Align(
                alignment: Alignment.topCenter,
                child: NewPostWidget(
                  horizontalPadding: 0,
                  isMobile: true,
                )),
          if (isMobileScreen(context))
            RoomWidget(
                horizontalPadding: bodyPadding,
                images: roomImages,
                isMobile: true),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child:
                FbStory(isMobile: isMobileScreen(context), stories: fbStories),
          ),
          if (!isMobileScreen(context))
            NewPostWidget(
              horizontalPadding: bodyPadding,
              isMobile: false,
            ),
          if (!isMobileScreen(context))
            RoomWidget(
              horizontalPadding: bodyPadding,
              images: roomImages,
            ),
          ...posts.map((post) => PostItem(
                bodyPadding: bodyPadding,
                post: post,
              )),
        ],
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  const PostItem({
    Key key,
    @required this.bodyPadding,
    @required this.post,
  }) : super(key: key);

  final bodyPadding;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: bodyPadding, vertical: 12),
      child: Material(
        color: Colors.white,
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 8),
              child: PostHeader(post: post),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              child: Text(post.postMessage,
                  maxLines: 7, overflow: TextOverflow.ellipsis),
            ),
            if (post.postImage != null)
              Divider(
                height: 11,
                thickness: 0.4,
                color: Colors.grey[500],
              ),
            if (post.postImage != null)
              Image.network(
                post.postImage,
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            PostFooter(post: post)
          ],
        ),
      ),
    );
  }
}

class PostHeader extends StatelessWidget {
  const PostHeader({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading:
            RoundPostOwner(isStoryViewed: false, userImage: post.posterImage),
        title: Text(post.posterName),
        subtitle: Row(
          children: [
            Text(post.postTime),
            DotCircle(size: 1.5, color: Colors.black),
            SizedBox(
              width: 5,
            ),
            Icon(
              MdiIcons.earth,
              size: 14,
            )
          ],
        ),
        trailing: Icon(
          Icons.more_horiz,
          color: Colors.grey[600],
        ));
  }
}

class PostFooter extends StatelessWidget {
  const PostFooter({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    List<Comment> comments = post.comment;
    int commentCount = comments.length;
//    bool isLoved=post.comment;
    var footerFlatGrey = Colors.grey[700];
    var footerFlatStyle = TextStyle(color: footerFlatGrey);
    var isMobile = isMobileScreen(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                LikeIcon(),
//                SizedBox(width: 2),
                LoveIcon(),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    post.postLikeMessage,
                    maxLines: 1,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            trailing: comments != null ? Text("$commentCount comments") : null,
          ),
          Divider(
            height: 5,
            thickness: 1,
            color: Colors.grey[400],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton.icon(
                label: Text(
                  "Like",
                  style: footerFlatStyle,
                ),
                icon: Icon(
                  MdiIcons.thumbUpOutline,
                  color: footerFlatGrey,
                ),
                onPressed: () {},
              ),
              FlatButton.icon(
                label: Text(
                  "Comment",
                  style: footerFlatStyle,
                ),
                icon: Icon(
                  MdiIcons.commentOutline,
                  size: 22,
                  color: footerFlatGrey,
                ),
                onPressed: () {},
              ),
              FlatButton.icon(
                label: Text(
                  "Share",
                  style: footerFlatStyle,
                ),
                icon: Icon(
                  isMobile ? MdiIcons.facebookMessenger : MdiIcons.replyOutline,
                  color: footerFlatGrey,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Divider(
            height: 5,
            thickness: 1,
            color: Colors.grey[400],
          ),
          SizedBox(height: 10),
          if (comments != null)
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "View ${commentCount - 2} more comments",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[600]),
              ),
            ),
          if (comments != null)
            ...comments.sublist(commentCount - 2).map((comment) {
              return CommentItem(comment: comment);
            }),
          ListTile(
            leading: RoundPostOwner(
                isOnline: true,
                circleRadius: 20,
                isStoryViewed: true,
                userImage: profilePic),
            title: RoundSearchBar(
              height: 38,
              noPrefix: true,
              noBorder: true,
              borderWidth: 0,
              backgroundColor: Colors.grey[200],
              label: "Write a comment...",
              txtController: TextEditingController(),
              onSubmitted: (searchedText) {},
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  ...[
                    if (!isMobile) MdiIcons.emoticonHappyOutline,
                    MdiIcons.cameraOutline,
                    if (!isMobile) Icons.gif,
                    if (!isMobile) MdiIcons.emoticonOutline,
                    if (isMobile) MdiIcons.emoticonHappyOutline,
                  ].map((icon) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: icon == Icons.gif
                            ? Container(
                                width: 21,
                                height: 21,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[600]),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Icon(icon, size: 20),
                              )
                            : Icon(icon),
                      )),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({
    Key key,
    @required this.comment,
  }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    bool loved = comment.loved;
    bool isReply = comment.isReply;
    int likeCount = comment.likeCount;
    var liked = likeCount > 0;
    var commentButtonStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey[700]);
    var isMobile = isMobileScreen(context);
    return Padding(
      padding: EdgeInsets.only(left: isReply ? 40.0 : 0.0),
      child: Stack(
        children: [
          ListTile(
            leading: RoundPostOwner(
                circleRadius: isReply ? 16 : null,
                isStoryViewed: true,
                userImage: comment.commentatorImage),
            title: Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 13.0),
                      child: Column(
                        children: [
                          Text(
                            comment.commentatorName,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            comment.commentMessage,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[900]),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Text(
                    "Like",
                    style: commentButtonStyle,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  if (!isMobile)
                    DotCircle(
                      color: Colors.black,
                      size: 3,
                    ),
                  SizedBox(
                    width: 3,
                  ),
                  Text("Reply", style: commentButtonStyle),
                  SizedBox(
                    width: 3,
                  ),
                  if (!isMobile)
                    DotCircle(
                      color: Colors.black,
                      size: 3,
                    ),
                  SizedBox(
                    width: 6,
                  ),
                  if (isMobile && liked)
                    CommentLikeIndicator(
                      comment: comment,
                      isMobile: isMobile,
                    )
                  else if (liked)
                    Text(comment.commentTime),
                ],
              ),
            ),
          ),
          if (liked && !isMobile)
            Positioned(
              top: loved ? 40 : 39,
              left: loved ? 168 : 130,
              child: CommentLikeIndicator(
                comment: comment,
                isMobile: isMobile,
              ),
            )
        ],
      ),
    );
  }
}

class CommentLikeIndicator extends StatelessWidget {
  const CommentLikeIndicator({
    Key key,
    @required this.comment,
    this.isMobile: false,
  }) : super(key: key);
  final Comment comment;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    var loved = comment.loved;
    var likeCount = comment.likeCount;
    return Material(
      elevation: isMobile ? 0 : 2,
      color: isMobile ? Colors.transparent : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(loved ? 2.0 : 1.0),
        child: Row(
          children: [
            if (isMobile)
              Text(
                "$likeCount",
                style: TextStyle(fontSize: 14),
              ),
            LikeIcon(
              mini: true,
            ),
            if (loved)
              LoveIcon(
                mini: true,
              ),
            SizedBox(
              width: loved ? 3 : 6,
            ),
            if (!isMobile)
              Text(
                "$likeCount",
                style: TextStyle(fontSize: 14),
              )
          ],
        ),
      ),
    );
  }
}

class LoveIcon extends StatelessWidget {
  const LoveIcon({
    Key key,
    this.mini: false,
  }) : super(key: key);
  final bool mini;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: mini ? 8 : 10,
      backgroundColor: Colors.red[700],
      child: Icon(
        MdiIcons.heart,
        color: Colors.white,
        size: mini ? 10 : 14,
      ),
    );
  }
}

class LikeIcon extends StatelessWidget {
  const LikeIcon({
    Key key,
    this.mini: false,
  }) : super(key: key);
  final bool mini;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: mini ? 8 : 10,
      backgroundColor: Colors.blue[700],
      child: Icon(
        MdiIcons.thumbUp,
        color: Colors.white,
        size: mini ? 10 : 14,
      ),
    );
  }
}

class FbStory extends StatelessWidget {
  const FbStory({
    Key key,
    @required this.stories,
    this.isMobile: false,
  }) : super(key: key);
  final List<Story> stories;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: isMobile ? 250 : 190,
        width: double.infinity,
        child: isMobile
            ? Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: FbStoryCore(
                          stories: stories,
                          isMobile: isMobile,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 30,
                        width: double.infinity,
                        child: FlatButton(
                            onPressed: () {},
                            color: Colors.blue[50],
                            child: Text(
                              "Show All Story",
                              style: TextStyle(color: Colors.blue),
                            )),
                      )
                    ],
                  ),
                ),
              )
            : FbStoryCore(
                stories: stories,
                isMobile: isMobileScreen(context),
              ));
  }
}

class FbStoryCore extends StatelessWidget {
  const FbStoryCore({
    Key key,
    @required this.stories,
    this.isMobile: false,
  }) : super(key: key);
  final List<Story> stories;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            itemBuilder: (BuildContext ctx, position) {
              String username = stories[position].userName;
              String userImage = stories[position].userImage;
              String storyImage = stories[position].storyImage;
              bool addStory = stories[position].addStory;
              bool isStoryViewed = stories[position].isStoryViewed;
              return FbStoryItem(
                userName: username,
                addStory: addStory,
                isStoryViewed: isStoryViewed,
                userImage: userImage,
                storyImage: storyImage,
              );
            }),
        if (!isMobile)
          Align(
              alignment: FractionalOffset(1, 0.5),
              child: RoundIcon(
                elevation: 4,
//                  mini: true,
                circleBackground: Colors.white,
                icon: Icons.arrow_forward,
                iconSize: 30,
                iconColor: Colors.grey[700],
                onPress: () {},
              )),
      ],
    );
  }
}

class FbStoryItem extends StatelessWidget {
  const FbStoryItem({
    Key key,
    this.isStoryViewed: false,
    this.addStory: false,
    this.userName: 'UserName PlaceHolder',
    this.userImage: "",
    this.storyImage: "",
  }) : super(key: key);
  final isStoryViewed;
  final addStory;
  final String userName;
  final String userImage;
  final String storyImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 4.0),
      child: Stack(
        children: [
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(8),
            child: Container(
//              color: Colors.blue,
              width: 110,
              height: double.infinity,
              child: addStory
                  ? Image.network(
                      profilePic,
                      fit: BoxFit.cover,
                      height: double.infinity,
                    )
                  : Stack(
                      children: [
                        Image.network(
                          storyImage,
                          fit: BoxFit.cover,
                          height: double.infinity,
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8, left: 12),
                              child: Text(
                                userName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )),
                      ],
                    ),
            ),
          ),
          addStory
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 90,
                    width: 110,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Material(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            child: Container(
                              height: 69,
                              width: double.infinity,
                              color: Colors.white,
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      "Create a\n   Story",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset(0.5, 0),
                          child: Material(
                            elevation: 0,
//                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: CircleBorder(
                                side: BorderSide(
                              color: FbStyle.white,
                              width: 4,
                            )),
                            child: FloatingActionButton(
                              onPressed: () {},
                              mini: true,
                              backgroundColor: FbStyle.accent,
                              child: Icon(Icons.add),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              : Positioned(
                  left: 9,
                  top: 9,
                  child: RoundPostOwner(
                      isStoryViewed: isStoryViewed, userImage: userImage),
                ),
        ],
      ),
    );
  }
}

class RoundPostOwner extends StatelessWidget {
  const RoundPostOwner({
    Key key,
    this.isStoryViewed: true,
    @required this.userImage,
    this.circleRadius,
    this.isOnline: false,
    this.stackWidget,
    this.stackTop,
    this.stackLeft,
  }) : super(key: key);

  final isStoryViewed;
  final isOnline;
  final String userImage;
  final double circleRadius;
  final double stackTop;
  final double stackLeft;
  final Widget stackWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          shape: CircleBorder(
              side: isStoryViewed
                  ? BorderSide.none
                  : BorderSide(
                      color: FbStyle.accent,
                      width: 3,
                    )),
          child: CircleAvatar(
            radius: circleRadius,
            backgroundImage: NetworkImage(userImage),
          ),
        ),
        if (isOnline || stackWidget != null)
          Positioned(
              top: stackTop ?? 26,
              left: stackLeft ?? 29,
              child: stackWidget ??
                  DotCircle(
                    bordered: true,
                    color: Colors.green,
                  )),
      ],
    );
  }
}

class NewPostWidget extends StatelessWidget {
  const NewPostWidget({
    Key key,
    @required this.horizontalPadding,
    this.verticalPadding,
    this.isMobile: false,
  }) : super(key: key);

  final double horizontalPadding;
  final double verticalPadding;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    double txtSize = isMobile ? 12 : (horizontalPadding > 55 ? 13.6 : 15);
    double iconSize = isMobile ? 15 : 28;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding ?? isMobile ? 0 : 20),
      child: Column(
        children: [
          Material(
            color: Colors.white,
            elevation: isMobile ? 0 : 1,
            borderRadius: isMobile ? null : BorderRadius.circular(10),
            child: Padding(
              padding: isMobile
                  ? EdgeInsets.all(0)
                  : const EdgeInsets.only(
                      left: 12.0, top: 16.0, right: 12.0, bottom: 12.0),
              child: Column(
                children: [
                  Padding(
                    padding: isMobile
                        ? EdgeInsets.only(left: 8, right: 8, top: 8)
                        : EdgeInsets.zero,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(profilePic),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RoundSearchBar(
                            height: isMobile ? 38 : 40.0,
                            noPrefix: true,
                            borderWidth: isMobile ? 0.4 : 0,
                            backgroundColor:
                                isMobile ? Colors.transparent : null,
                            label: "What's on your mind?,Shittu?",
                            txtController: TextEditingController(),
                            onSubmitted: (searchedText) {},
                          ),
                        ),
//                          Text("What's on your mind?,Shittu")
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Divider(
                    height: 11,
                    thickness: 0.4,
                    color: Colors.grey[500],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isMobile ? 10 : 0),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.videocam,
                                  color: Colors.redAccent, size: iconSize),
                              label: Expanded(
                                  child: Text(
                                isMobile ? "Live" : "Live Video",
                                style: TextStyle(fontSize: txtSize),
                              ))),
                        ),
                        if (isMobile)
                          Container(
                              height: 26, width: 0.5, color: Colors.grey[600]),
                        Expanded(
                          child: FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.photo_library,
                                  color: Colors.green, size: iconSize),
                              label: Expanded(
                                  child: Text(
                                      isMobile ? "Photo" : "Photo/Video",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: txtSize)))),
                        ),
                        if (isMobile)
                          Container(
                              height: 25, width: 0.5, color: Colors.grey[600]),
                        Expanded(
                          child: FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                  isMobile
                                      ? Icons.video_call
                                      : Icons.emoji_emotions_outlined,
                                  color: isMobile
                                      ? Colors.purple
                                      : Colors.orangeAccent,
                                  size: iconSize),
                              label: Expanded(
                                  child: Text(
                                isMobile ? "Room" : "Feeling/Activity",
                                style: TextStyle(fontSize: txtSize),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RoomWidget extends StatelessWidget {
  const RoomWidget({
    Key key,
    @required this.horizontalPadding,
    this.verticalPadding,
    @required this.images,
    this.isMobile: false,
  }) : super(key: key);

  final double horizontalPadding;
  final double verticalPadding;
  final List<String> images;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMobile
          ? EdgeInsets.only(top: 10)
          : EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding ?? 0),
      child: Material(
        color: Colors.white,
        elevation: isMobile ? 0 : 1,
        borderRadius: isMobile ? null : BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 12.0, right: 2.0, bottom: 12.0),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (ctx, pos) {
                    if (pos == 0)
                      return OutlineRoomButton(
                        mini: isMobile,
                      );
                    else
                      return Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(images[pos]),
                            ),
                            Positioned(
                              top: 25, left: 25,
//                      alignment: FractionalOffset(1, 1),
                              child: DotCircle(
                                color: Colors.green,
                                bold: true,
                              ),
                            )
                          ],
                        ),
                      );
                  },
                ),
              ),
              if (!isMobile)
                Align(
                    alignment: FractionalOffset(1, 0.5),
                    child: RoundIcon(
                      elevation: 4,
                      circleBackground: Colors.white,
                      icon: Icons.arrow_forward_ios,
                      iconSize: 30,
                      iconColor: Colors.grey[700],
                      onPress: () {},
                    )),
            ],
          ),
        ),
      ),
    );
  }
}

class OutlineRoomButton extends StatelessWidget {
  const OutlineRoomButton({
    Key key,
    this.mini: false,
  }) : super(key: key);
  final bool mini;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mini ? 95 : 153,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue[50], width: 2)),
      child: FlatButton.icon(
          onPressed: () {},
          icon: Icon(Icons.video_call,
              color: Colors.purple, size: mini ? 24 : 27),
          label: Expanded(
              child: Text(
            mini ? "Create room" : "Create Room",
            style: TextStyle(
                fontSize: mini ? 10 : 14,
                color: Colors.blue,
                fontWeight: FontWeight.bold),
          ))),
    );
  }
}

class LeftPanel extends StatelessWidget {
  const LeftPanel({
    Key key,
    @required this.sideMenus,
    @required this.scrollController,
  }) : super(key: key);
  final List<SideMenu> sideMenus;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Container(
        child: Scrollbar(
          isAlwaysShown: true,
          controller: scrollController,
          child: ListView.builder(
              controller: scrollController,
              itemCount: sideMenus.length,
              itemBuilder: (ctx, pos) {
                String label = sideMenus[pos].label;
                String alertMessage = sideMenus[pos].alertMessage;
                String image = sideMenus[pos].image;
                bool divide = sideMenus[pos].divide;
                bool isMore = sideMenus[pos].isMore;
                IconData icon = sideMenus[pos].icon;
                bool isTitle = image == null && icon == null;
                Color iconColor = sideMenus[pos].iconColor;
                if (divide)
                  return Divider(
                    height: 11,
                    thickness: 0.4,
                    color: Colors.grey[500],
                  );
                else
                  return FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () {},
                    hoverColor: Colors.grey[300],
                    child: ListTile(
                        subtitle: alertMessage != null
                            ? Row(
                                children: [
                                  DotCircle(
                                    bordered: false,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(alertMessage,
                                        style:
                                            TextStyle(color: FbStyle.accent)),
                                  ),
                                ],
                              )
                            : null,
                        leading: image == null
                            ? (icon == null
                                ? null
                                : (isMore
                                    ? Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[300]),
                                        child: Icon(
                                          Icons.expand_more,
                                          size: 24,
                                          color: Colors.black,
                                        ),
                                      )
                                    : icon == MdiIcons.accountGroup
                                        ? CircleAvatar(
                                            radius: 13, child: Icon(icon))
                                        : Icon(
                                            icon,
                                            color: iconColor,
                                          )))
                            : CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(image),
                              ),
                        title: Text(label,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isTitle
                                    ? Colors.grey[600]
                                    : Colors.grey[700]))),
                  );
              }),
        ),
      ),
    );
  }
}

class DotCircle extends StatelessWidget {
  const DotCircle({
    Key key,
    this.color,
    this.bordered: true,
    this.bold: false,
    this.size,
  }) : super(key: key);
  final Color color;
  final bool bordered;
  final bool bold;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: bordered ? Border.all(color: Colors.white, width: 1) : null,
          color: color ?? FbStyle.accent,
          shape: BoxShape.circle),
      width: size ?? (bold ? 13 : 10),
      height: size ?? (bold ? 13 : 10),
    );
  }
}

class RightPanel extends StatelessWidget {
  const RightPanel({
    Key key,
    @required this.items,
    @required this.scrollController,
  }) : super(key: key);
  final List<RightMenu> items;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scrollbar(
        isAlwaysShown: true,
        controller: scrollController,
        child: ListView.builder(
            controller: scrollController,
            itemCount: items.length,
            itemBuilder: (ctx, pos) {
              String label = items[pos].label;
              String webLink = items[pos].webLink;
              String image = items[pos].image;
              bool divide = items[pos].divide;
              bool isDotted = items[pos].isDotted;
              bool isTrailTitle = items[pos].isTrailTitle;
              bool isRoundLead = items[pos].isRoundLead;
              if (divide)
                return Divider(
                  height: 11,
                  thickness: 0.4,
                  color: Colors.grey[500],
                );
              else if (!isRoundLead && image != null)
                return FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: () {},
                  hoverColor: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(children: [
                      if (image != null)
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              shape: BoxShape.rectangle,
                              color: Colors.grey[300]),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Expanded(
                          child: ListTile(
                        title: Text(
                          label,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(webLink),
                      )),
                    ]),
                  ),
                );
              else if (isRoundLead) {
                if (isDotted)
                  return FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () {},
                    hoverColor: Colors.grey[300],
                    child: Stack(
                      children: [
                        SimpleTile(
                            image: image,
                            label: label,
                            isTrailTitle: isTrailTitle),
                        Positioned(
                          top: 30,
                          left: 35,
                          child: DotCircle(
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  );
                else
                  return Column(
                    children: [
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        onPressed: () {},
                        hoverColor: Colors.grey[300],
                        child: SimpleTile(
                            image: image,
                            label: label,
                            isTrailTitle: isTrailTitle),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            YourPagesItem(
                              icon: MdiIcons.wechat,
                              title: "5 Messages",
                            ),
                            YourPagesItem(
                              icon: MdiIcons.bellOutline,
                              title: "20+ Messages",
                            ),
                            YourPagesItem(
                              icon: Icons.campaign_outlined,
                              title: "Create Promotion",
                            ),
                          ],
                        ),
                      )
                    ],
                  );
              } else {
                return SimpleTile(
                  image: image,
                  label: label,
                  isTrailTitle: isTrailTitle,
                  isMultiTrail: label == "Contacts",
                );
              }
            }),
      ),
    );
  }
}

class SimpleTile extends StatelessWidget {
  const SimpleTile({
    Key key,
    @required this.image,
    @required this.label,
    @required this.isTrailTitle,
    this.isMultiTrail: false,
  }) : super(key: key);

  final String image;
  final String label;
  final bool isTrailTitle;
  final bool isMultiTrail;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: image != null
          ? RoundPostOwner(
              isStoryViewed: true,
              userImage: image,
              circleRadius: 15,
              isOnline: true,
            )
          : null,
      title: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: image == null ? Colors.grey[600] : Colors.grey[800])),
      trailing: isTrailTitle
          ? GestureDetector(onTap: () {}, child: Icon(Icons.more_horiz))
          : (isMultiTrail
              ? SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      Icon(Icons.video_call),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.search),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  ),
                )
              : null),
    );
  }
}

class YourPagesItem extends StatelessWidget {
  const YourPagesItem({
    Key key,
    this.title,
    this.icon,
  }) : super(key: key);
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: () {},
      hoverColor: Colors.grey[300],
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600]),
        ),
        leading: Icon(icon),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class VideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 350,
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: VideoLeftPanel(
                sideMenus: notificationMenus,
                scrollController: ScrollController(),
              ),
            )),
        Container(
          color: FbStyle.fbBackground,
        )
      ],
    );
  }
}

class GroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LeftPanel(
      sideMenus: leftSideMenus,
      scrollController: ScrollController(),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: FbStyle.fbBackgroundWhite,
        child: Column(children: [
          ListTile(
            title: Text(
              "Notifications",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: MobileRoundIcon(icon: Icons.search),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (ctx, pos) {
                  var notification = notifications[pos];
                  return NotificationItem(notification: notification);
                }),
          )
        ]));
  }
}

class NotificationItem extends StatelessWidget {
  final notification;

  const NotificationItem({Key key, this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationType type = notification.notType;
    bool isDivide = notification.isDivide;
    bool isSubHead = notification.isSubHead;
    String subtitle = notification.subTitle;
    bool isFriendRequest = type == NotificationType.FRIEND_REQUEST;

    if (isSubHead)
      return ListTile(
        title: Text(subtitle, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: isFriendRequest
            ? Text("See all", style: TextStyle(color: Colors.blue))
            : null,
      );
    else if (type == NotificationType.SEE_ALL)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlatButton(
            onPressed: () {}, child: Text(subtitle), color: Colors.grey[300]),
      );
    else if (isDivide)
      return Divider(
        height: 11,
        thickness: 0.4,
        color: Colors.grey[500],
      );
    else if (isFriendRequest)
      return CNotificationItem(
        notification: notification,
      );
    else
      return FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: () {},
        hoverColor: Colors.grey[300],
        child: CNotificationItem(
          notification: notification,
        ),
      );
  }
}

class CNotificationItem extends StatelessWidget {
  final notification;

  const CNotificationItem({Key key, @required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationType type = notification.notType;
    String image = notification.image;
    String subtitle = notification.subTitle;
    String to = notification.to;
    String from = notification.from;

    var isFriendRequest = type == NotificationType.FRIEND_REQUEST;
    return Container(
//        color: isFriendRequest ? null : Colors.lightBlue[50],
      child: ListTile(
        leading: RoundPostOwner(
          circleRadius: 35,
          userImage: image ?? "",
          stackTop: 20,
          stackLeft: 38,
          stackWidget: NotificationTypeIndic(type),
        ),
        title: Text.rich(getNotificationMessage(type, to: to, from: from)),
        subtitle: isFriendRequest
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subtitle),
                  Row(
//                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          onPressed: () {},
                          child: Text("Confirm",
                              style: TextStyle(color: Colors.white)),
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          onPressed: () {},
                          child: Text("Delete"),
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  )
                ],
              )
            : Text(subtitle),
        trailing: Icon(Icons.more_horiz),
      ),
    );
  }

  TextSpan getNotificationMessage(NotificationType type,
      {String to, String from}) {
    if (type == NotificationType.Comment_NOTIFICATION)
      return TextSpan(text: "", style: TextStyle(), children: [
        TextSpan(text: from, style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: " also commented on "),
        if (to != null)
          TextSpan(text: to, style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: to == null ? "your post." : "'s post."),
      ]);
    else if (type == NotificationType.BirthDay_NOTIFICATION)
      return TextSpan(text: "", style: TextStyle(), children: [
        TextSpan(text: from, style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(
            text: " and 4 others have birthdays today.Wish them all the best ")
      ]);
    else if (type == NotificationType.LIKE_NOTIFICATION)
      return TextSpan(text: "", style: TextStyle(), children: [
        TextSpan(text: from, style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "sent you a friend request. "),
      ]);
    else if (type == NotificationType.FRIEND_REQUEST)
      return TextSpan(text: "", style: TextStyle(), children: [
        TextSpan(text: from, style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: " sent you a friend request. "),
      ]);

    return TextSpan(text: "", style: TextStyle(), children: [
      TextSpan(text: from, style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: "also commented on "),
      if (to != null)
        TextSpan(text: to, style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: to == null ? "your post." : "'s post."),
    ]);
  }
}

class NotificationTypeIndic extends StatelessWidget {
  final NotificationType type;

  const NotificationTypeIndic(
    this.type, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.blue[700];
    IconData icon = Icons.eleven_mp;
    if (type == NotificationType.Comment_NOTIFICATION) {
      color = Colors.green[400];
      icon = MdiIcons.chat;
    } else if (type == NotificationType.BirthDay_NOTIFICATION) {
      color = Colors.pinkAccent;
      icon = Icons.cake;
    } else if (type == NotificationType.LIKE_NOTIFICATION) {
      color = Colors.blue[700];
      icon = MdiIcons.thumbUp;
    } else if (type == NotificationType.BirthDay_NOTIFICATION) {
      color = Colors.pinkAccent;
      icon = Icons.cake;
    } else if (type == NotificationType.BirthDay_NOTIFICATION) {
      color = Colors.pinkAccent;
      icon = Icons.cake;
    } else if (type == NotificationType.FRIEND_REQUEST) {
      color = Colors.blue;
      icon = MdiIcons.accountGroup;
    }
    return SizedBox(
      width: 32,
      height: 32,
      child: RoundIcon(
        circleBackground: color,
        iconColor: Colors.white,
        icon: icon,
        iconSize: 19,
        isButton: false,
        iconPadding: EdgeInsets.only(top: 4, left: 2, right: 2),
      ),
    );
  }
}

class VideoLeftPanel extends StatelessWidget {
  const VideoLeftPanel({
    Key key,
    @required this.sideMenus,
    @required this.scrollController,
  }) : super(key: key);
  final List<SideMenu> sideMenus;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Container(
        child: Column(
          children: [
            ListTile(
              title: Text("Watch",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: RoundSearchBar(
                  txtController: TextEditingController(),
                  height: 38,
                  label: "Search Videos"),
            ),
            Expanded(
              child: Scrollbar(
                isAlwaysShown: true,
                controller: scrollController,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemCount: sideMenus.length,
                    itemBuilder: (ctx, pos) {
                      String label = sideMenus[pos].label;
                      String alertMessage = sideMenus[pos].alertMessage;
                      String image = sideMenus[pos].image;
                      bool divide = sideMenus[pos].divide;
//                bool isSea = sideMenus[pos].isMore;
                      bool isMore = sideMenus[pos].isMore;
                      IconData icon = sideMenus[pos].icon;
                      bool isTitle = image == null && icon == null;
                      Color iconColor = sideMenus[pos].iconColor;
                      if (divide)
                        return Divider(
                          height: 11,
                          thickness: 0.4,
                          color: Colors.grey[500],
                        );
                      else
                        return FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onPressed: () {},
                          hoverColor: Colors.blue[50],
                          child: ListTile(
                              subtitle: alertMessage != null
                                  ? Row(
                                      children: [
                                        DotCircle(
                                          bordered: false,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5.0),
                                          child: Text(alertMessage,
                                              style: TextStyle(
                                                color: FbStyle.accent,
                                              )),
                                        ),
                                      ],
                                    )
                                  : null,
                              leading: image == null
                                  ? (icon == null
                                      ? null
                                      : Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                iconColor ?? Colors.grey[300],
                                          ),
                                          child: Icon(
                                            icon,
                                            size: 24,
                                            color: iconColor == null
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ))
                                  : CircleAvatar(
                                      radius: 14,
                                      backgroundImage: NetworkImage(image),
                                    ),
                              title: Text(label,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isTitle
                                          ? Colors.grey[600]
                                          : Colors.grey[700]))),
                        );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
