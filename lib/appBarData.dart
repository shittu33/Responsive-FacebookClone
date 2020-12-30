import 'package:facebookclone/fbData.dart';
import 'package:facebookclone/strings.dart';
import 'package:facebookclone/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'sizes.dart';
import 'style.dart';

Padding buildMobileCenter() {
  return Padding(
    padding: const EdgeInsets.only(right: 0.0),
    child: RoundSearchBar(
      height: 45.0,
      prefixIcon: Icons.menu,
      prefixIconColor: FbStyle.appIconColor,
      label: "search News",
      initialText: "search something",
//      txtController: txtController,
//      iconTap: toggleDrawer,
      onSubmitted: (searchedText) {},
    ),
  );
}

List<Widget> appBarMobileLeadChildren(context) {
  return [
    SizedBox(
      width: 3,
    ),
    if (isMobileScreen(context)) FacebookLogo.full(),
  ];
}

List<Widget> appBarLeadChildren(context) {
  return [
    SizedBox(
      width: 3,
    ),
    FacebookLogo.shape(
      text: "f",
      logoShape: BoxShape.circle,
      textHeight: 1.29,
    ),
    SizedBox(
      width: 8,
    ),
    if (!isExtraLargeScreen(context))
      RoundIcon(
          iconColor: FbStyle.iconGrey,
          icon: Icons.search,
          onPress: () {
            showCDialog(context, label: FbStrings.searchHint);
          })
    else
      RoundSearchBar(
          height: 43,
          width: 230,
          label: FbStrings.searchHint,
          onTap: () {
            showCDialog(context);
          },
          txtController: TextEditingController(),
//              iconTap: toggleDrawer,
          onSubmitted: (searchedText) {}),
    if (isMobileTabletScreen(context))
      SizedBox(
        width: 8,
      ),
    if (isMobileTabletScreen(context))
      FbMenuIcon(
        padding: EdgeInsets.only(top: 12, left: 8),
        iconColor: Colors.grey[700],
      ),
  ];
}

List<Widget> getMobileTrailing(BuildContext context) {
  return [
    SizedBox(
      width: mAppBarIconHeight + 20,
      height: mAppBarIconHeight + 20,
      child: RoundIcon(
          iconSize: mAppBarIconHeight - 2,
          padding: const EdgeInsets.only(right: 8.0),
          icon: Icons.search,
          onPress: () {}),
    ),
    CounterWidget(
      isMiniCounter: true,
      counterAlignment: FractionalOffset(0.78, -0.35),
      truncateCount: true,
      count: 8,
      counterBackground: FbStyle.red,
      child: SizedBox(
        width: mAppBarIconHeight + 20,
        height: mAppBarIconHeight + 20,
        child: RoundIcon(
            iconSize: mAppBarIconHeight - 2,
            padding: const EdgeInsets.only(right: 8.0),
            icon: MdiIcons.facebookMessenger,
            onPress: () {}),
      ),
    ),
  ];
}

List<Widget> getTrailingChildren(BuildContext context) {
  return [
    if (isExtraLargeScreen(context))
      SizedBox(
          width: 100,
          height: appBarIconHeight,
          child: Row(children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(profilePic),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                "Shittu",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
          ])),
//      ),
    RoundIcon(
        icon: Icons.add,
        padding: const EdgeInsets.only(right: 3.0),
        onPress: () {}),
    CounterWidget(
      counterAlignment: FractionalOffset(0.78, -0.35),
      truncateCount: true,
      maximumCount: 100,
      count: 4,
      counterBackground: FbStyle.red,
      child: RoundIcon(
          padding: const EdgeInsets.only(right: 0.0),
          icon: MdiIcons.facebookMessenger,
          onPress: () {}),
    ),
    RoundIcon(
        padding: const EdgeInsets.only(right: 5.0),
        icon: Icons.notifications,
        onPress: () {}),
    RoundIcon(
        padding: const EdgeInsets.only(right: 3.0),
        icon: Icons.expand_more,
        onPress: () {}),
  ];
}

const GameTitle = 'Game';
const MenuTitle = 'Menu';
const PageTitle = 'Pages';
const AlertTitle = 'Notifications';

List<TabScreen> largeScreenTabs() {
  return tabsScreens()
      .where((element) =>
          element.title != MenuTitle && element.title != AlertTitle)
      .toList();
}

List<TabScreen> mediumScreenTabs() {
  return tabsScreens()
      .where((element) =>
          element.title != GameTitle && element.title != AlertTitle)
      .toList();
}

List<TabScreen> getTabsScreens(BuildContext context) {
  if (isAtLeastLarge(context)) {
    return largeScreenTabs();
  } else if (isMobileScreen(context)) {
    return mobileScreenTabs();
  } else {
    return mediumScreenTabs();
  }
}

List<TabScreen> mobileScreenTabs() {
  final tabs = tabsScreens()
      .where(
          (element) => element.title != GameTitle && element.title != PageTitle)
      .toList();
  return tabs;
}

List<TabScreen> tabsScreens() {
  return [
    TabScreen(
        title: 'Home',
        icon: Icons.home_rounded,
        iconColor: FbStyle.accent,
        screen: HomeScreen()),
//    TabScreen(
//        title: PageTitle,
//        icon: Icons.flag_outlined,
//        iconColor: FbStyle.iconGrey,
//        screen: PageScreen(),
//        alertCount: 50),
    TabScreen(
        title: 'Watch',
        icon: Icons.ondemand_video,
        iconColor: FbStyle.iconGrey,
        screen: VideoScreen(),
        alertCount: 30),
    TabScreen(
        title: 'Groups',
        icon: MdiIcons.accountGroup,
        iconColor: FbStyle.iconGrey,
        isCircleTabIcon: true,
        screen: GroupScreen(),
        alertCount: 2),
//      if (isAtLeastLarge(context))
    TabScreen(
        title: GameTitle,
        icon: MdiIcons.facebookGaming,
        iconColor: FbStyle.iconGrey,
        screen: MenuScreen()),
//      if (!isAtLeastLarge(context))
    TabScreen(
        title: AlertTitle,
        icon: Icons.notifications_none,
//        icon: MdiIcons.bellAlertOutline,
        iconColor: FbStyle.iconGrey,
        alertCount: 10,
        screen: NotificationScreen()),
    TabScreen(
        title: MenuTitle,
        icon: Icons.menu,
        iconColor: FbStyle.iconGrey,
        screen: MenuScreen()),
//      buildTabIconButton(MdiIcons.accountGroupOutline, title: 'People'),
//      buildTabIconButton(MdiIcons.bellAlertOutline, title: 'Notifications'),
  ];
}

class FbMenuIcon extends StatelessWidget {
  final double width;
  final Color iconColor;
  final EdgeInsetsGeometry padding;

  FbMenuIcon({this.width, this.iconColor, this.padding});

  @override
  Widget build(BuildContext context) {
    final stepCount = 3;
    var isMobile = isMobileScreen(context);
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 13.0),
      child: Column(
        children: [
          for (int i = 0; i < stepCount; i++)
            Padding(
              padding: EdgeInsets.only(
                  bottom: i == stepCount - 1 ? 0 : (isMobile ? 7 : 5.8)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: iconColor ?? FbStyle.iconGrey,
                ),
                width: width ?? 22,
                height: isMobile ? 1.8 : 3.2,
              ),
            )
        ],
      ),
    );
  }
}

class TabScreen extends Object {
  final String title;
  final IconData icon;
  final Widget screen;
  final int alertCount;
  final bool isCircleTabIcon;
  Color iconColor;

  @override
  bool operator ==(Object other) {
    return this.title == (other as TabScreen).title;
  }

  TabScreen({
    this.isCircleTabIcon: false,
    this.title,
    this.icon,
    this.screen,
    this.alertCount: 0,
    this.iconColor,
  });

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
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
    return Container();
  }
}

class GroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

extension TabScreensExt on List<TabScreen> {
  bool containsTab(TabScreen tab) {
    return this.contains(tab);
  }

  bool containsTabWithTittle(String title) {
    return this.contains(getTabWithTittle);
  }

  TabScreen getTabWithTittle(String title) {
    return this.singleWhere((element) => element.title == title);
  }

  TabScreen getTabWithSameTittle(TabScreen tab) {
    return this.singleWhere((element) => element.title == tab.title);
  }
}
