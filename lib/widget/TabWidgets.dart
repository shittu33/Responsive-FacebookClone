import 'package:facebookclone/widget/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CollapseAppBar extends StatelessWidget {
  const CollapseAppBar({
    Key key,
    this.expandedHeight,
    this.leading,
    this.actions,
    this.centerTitle,
    this.title,
    this.background,
  }) : super(key: key);

  final double expandedHeight;
  final Icon leading;
  final List<Widget> actions;
  final bool centerTitle;
  final Text title;
  final Image background;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight != null ? expandedHeight : 250,
      floating: false,
      pinned: true,
      leading: leading != null ? leading : null,
      actions: leading != null ? actions : null,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: centerTitle != null ? centerTitle : false,
        title: title != null ? title : null,
        background: background != null ? background : Image.asset(""),
      ),
    );
  }
}

class SilverTabWidget extends StatelessWidget {
  SilverTabWidget(
      {Key key,
      @required this.tabsList,
      this.unselectedColor,
      this.selectedColor,
      this.initial = 0,
      this.ontap})
      : super(key: key);

  final List<Tab> tabsList;
  final Color unselectedColor;
  final Color selectedColor;
  final int initial;
  final Function(int pos) ontap;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
//      initialIndex: initial==0?0:initial,
      length: tabsList.length,
      child: SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            TabBar(
                onTap: ontap,
                unselectedLabelColor: unselectedColor,
                labelColor: selectedColor,
                tabs: tabsList),
          )),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: new Container(
        color: Colors.white,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class TabWidget extends PreferredSize {
  TabWidget(
      {Key key,
      this.height: kToolbarHeight,
      @required this.tabsList,
      this.unselectedColor,
      this.selectedColor,
      this.initial = 0,
      this.onTap,
      this.indicatorWeight: 2,
      this.labelPadding,
      this.onlyIcon: false});

  final double height;
  final List<Widget> tabsList;
  final Color unselectedColor;
  final Color selectedColor;
  final int initial;
  final bool onlyIcon;
  final EdgeInsetsGeometry labelPadding;
  final double indicatorWeight;
  final Function(int pos, List<Widget> tabsList) onTap;

  @override
  // TODO: implement child
  Widget get child => DefaultTabController(
        length: tabsList.length,
        child: TabBar(
//          indicatorSize: TabBarIndicatorSize.label,
            labelPadding: labelPadding ??
                (onlyIcon
                    ? EdgeInsets.zero
                    : EdgeInsets.symmetric(horizontal: 16)),
//          indicator: roundRectDecoration(radius: 22, color: Colors.green),
            onTap: (index) {
              onTap(index, tabsList);
            },
            indicatorWeight: indicatorWeight,
            indicatorColor: selectedColor,
            unselectedLabelColor: unselectedColor,
            labelColor: selectedColor,
            tabs: tabsList),
      );

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class Sample2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 200),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => ListTile(
                  title: Text("Index: $index"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({@required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Image.network(
          "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          fit: BoxFit.cover,
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Text(
              "MySliverAppBar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Card(
              elevation: 10,
              child: SizedBox(
                height: expandedHeight,
                width: MediaQuery.of(context).size.width / 2,
                child: FlutterLogo(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
