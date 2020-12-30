import 'package:facebookclone/sizes.dart';
import 'package:facebookclone/style.dart';
import 'package:facebookclone/widget/TabWidgets.dart';
import 'package:facebookclone/widget/coreWidgets.dart';
import 'package:facebookclone/widget/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'appBarData.dart';
import 'fbData.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facebook Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FacebookPage(title: 'Facebook Flutter'),
    );
  }
}

class FacebookPage extends StatefulWidget {
  FacebookPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FacebookPageState createState() => _FacebookPageState();
}

class _FacebookPageState extends State<FacebookPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    print(screenWidth(context));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: HomeWidget(
        tabScreens: getTabsScreens(context),
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  final List<TabScreen> tabScreens;

  HomeWidget({this.tabScreens});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _screenIndex = 0;
  double smallScreenWidth = smallSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FacebookAppBar(
        mobileWidth: smallScreenWidth,
        actionAtCenter: isMobileScreen(context)
            ? ResponsiveCenterAction.MOVE_TO_BOTTOM
            : ResponsiveCenterAction.DISAPPEAR,
        leadWidget: Row(
            children: isMobileScreen(context)
                ? appBarMobileLeadChildren(context)
                : appBarLeadChildren(context)),
        actions: isMobileScreen(context)
            ? getMobileTrailing(context)
            : getTrailingChildren(context),
        tabBarWidget: TabWidget(
            height: MediaQuery.of(context).size.width < smallScreenWidth
                ? kToolbarHeight
                : 0.0,
            indicatorWeight: 3,
            onlyIcon: true,
            selectedColor: FbStyle.accent,
            unselectedColor: FbStyle.iconGrey,
            tabsList: widget.tabScreens
                .map((screen) => FacebookTab(
                    iconShape: BoxShape.circle,
                    isCircleIcon: screen.isCircleTabIcon,
                    iconColor: screen.iconColor,
                    alertCount: screen.alertCount,
                    counterBackground: FbStyle.red,
                    tipMessage: screen.title,
                    icon: screen.icon,
                    iconSize: appBarIconHeight))
                .toList(),
            onTap: (index, tabsList) => setState(() {
                  changeSelectedTabColor(index);
                  _screenIndex = index;
                })),
      ),
      body: IndexScreens(
          screenIndex: _screenIndex, tabScreens: widget.tabScreens),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        mini: true,
        tooltip: 'Increment',
        child: Icon(
//          Icons.edit_road_outlined,
          MdiIcons.squareEditOutline,
          color: Colors.black,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void changeSelectedTabColor(int index) {
    widget.tabScreens.asMap().map((key, value) {
      TabScreen tab = value;
      if (index == key) {
        tab.iconColor = FbStyle.accent;
      } else
        tab.iconColor = FbStyle.iconGrey;
      return MapEntry(key, tab);
    });
  }
}

class IndexScreens extends StatefulWidget {
  final int screenIndex;
  final List<TabScreen> tabScreens;

  IndexScreens({this.screenIndex: 0, this.tabScreens});

  @override
  _IndexScreensState createState() => _IndexScreensState();
}

class _IndexScreensState extends State<IndexScreens> {
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
        return Scaffold(
            body: Container(
          color: Colors.grey[200],
          child: Flex(
            direction: Axis.horizontal,
            children: [
              if (isAtLeastLarge(context))
                Expanded(
                  flex: 19,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: LeftPanel(
                        sideMenus: leftSideMenus,
                      )),
                ),
              Container(width: gap),
              Expanded(
                flex: 40,
                child: MainContent(tabScreen, getBodyPadding(context)),
              ),
              Container(width: gap),
              if (!isOnlyBody(context))
                Expanded(
                    flex: 19,
                    child: Container(
                        child: RightPanel(
                      items: rightMenus,
                    ))),
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
