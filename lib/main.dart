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
      home: FacebookWidget() /* FacebookUI(title: 'Facebook Flutter')*/,
    );
  }
}

class FacebookWidget extends StatelessWidget {
  const FacebookWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FacebookUI(
      tabScreens: getTabsScreens(context),
    );
  }
}

class FacebookUI extends StatefulWidget {
  final List<TabScreen> tabScreens;

  FacebookUI({this.tabScreens});

  @override
  _FacebookUIState createState() => _FacebookUIState();
}

class _FacebookUIState extends State<FacebookUI> with WidgetsBindingObserver {
  int _screenIndex = 0;
  double smallScreenWidth = smallSize;
  ScrollController _lScrollController = ScrollController();
  ScrollController _mScrollController = ScrollController();
  ScrollController _rScrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: LeftPanel(
            sideMenus: leftSideMenus,
            scrollController: ScrollController()),
      ),
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
                  if (widget.tabScreens[index].title == MenuTitle && !isMobileScreen(context))
                  toggleDrawer();
                  else {
                    changeSelectedTabColor(index);
                    _screenIndex = index;
                  }
                })),
      ),
      body: FacebookBody(
        firstPanel: LeftPanel(
          sideMenus: leftSideMenus,
          scrollController: _lScrollController,
        ),
        mainPanelBuilder: (tabScreen, bodyPadding) {
          return MainBodyPanel(
            tabScreen,
            bodyPadding,
            scrollController: _mScrollController,
          );
        },
        lastPanel: RightPanel(
          items: rightMenus,
          scrollController: _rScrollController,
        ),
        screenIndex: _screenIndex,
        tabScreens: widget.tabScreens,
      ),
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

  toggleDrawer() async {
    if (_scaffoldKey.currentState.isDrawerOpen)
      _scaffoldKey.currentState.openEndDrawer();
    else {
      _scaffoldKey.currentState.openDrawer();
      setState(() {});
    }
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
