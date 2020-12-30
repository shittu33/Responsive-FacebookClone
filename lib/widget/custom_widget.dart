import 'dart:ui';
import 'package:facebookclone/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../appBarData.dart';
import '../sizes.dart';

class FacebookAppBar extends ResponsiveAppBar {
  FacebookAppBar({
    Key key,
    this.mobileWidth,
    this.actionAtCenter,
    this.centerCondition,
    this.preferredHeight: cToolBarHeight,
    this.leadWidget,
    this.tabBarWidget,
    this.actions,
  }) : super(key: key);

  final ResponsiveCenterAction actionAtCenter;
  final double preferredHeight;
  final double mobileWidth;
  final Widget leadWidget;
  final PreferredSizeWidget tabBarWidget;
  final List<Widget> actions;
  final bool Function(double screenSize, double smallScreenWidth)
      centerCondition;

  @override
  double get smallScreenWidth => mobileWidth;

  @override
  get leadFlexWeight => 13;

  @override
  get trailFlexWeight => 13;

  @override
  get centerFlexWeight => 20;

  @override
  Widget get trailing => Row(children: actions);

  @override
  PreferredSizeWidget get center => tabBarWidget;

  @override
  Widget get leading => leadWidget;

  @override
  bool Function(double screenSize, double smallSize)
      get centerActionCondition => centerCondition;

  @override
  double get height => preferredHeight;

  @override
  ResponsiveCenterAction get centerAction =>
      actionAtCenter ?? ResponsiveCenterAction.MOVE_TO_BOTTOM;
}

class FacebookTab extends StatelessWidget {
  const FacebookTab({
    Key key,
    @required this.icon,
    this.iconShape: BoxShape.circle,
    this.isCircleIcon: false,
    this.iconColor,
    this.alertCount: 0,
    this.counterBackground,
    this.tipMessage,
    this.iconSize: appBarIconHeight,
    this.iconAltWidget,
  }) : super(key: key);

  final BoxShape iconShape;
  final bool isCircleIcon;
  final Color iconColor;
  final int alertCount;
  final Color counterBackground;
  final String tipMessage;
  final IconData icon;
  final Widget iconAltWidget;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    var vAppBarIconHeight =
        isMobileScreen(context) ? mAppBarIconHeight : appBarIconHeight;
    return CounterWidget(
      childWidth: vAppBarIconHeight,
      counterAlignment: Alignment.topRight,
      isMiniCounter: isMobileScreen(context),
      truncateCount: true,
      showIfZero: false,
      count: alertCount,
      counterBackground: counterBackground ?? FbStyle.red,
      child: ShapedWidget(
        shape: iconShape,
        noBorder: !isCircleIcon,
        borderColor: iconColor ?? FbStyle.iconGrey,
        child: CustomToolTip(
          message: tipMessage,
          child: icon == Icons.menu || icon == MdiIcons.menu
              ? FbMenuIcon(iconColor: iconColor)
              : Icon(
                  icon,
                  color: iconColor ?? FbStyle.iconGrey,
                  size:
                      isCircleIcon ? vAppBarIconHeight - 5 : vAppBarIconHeight,
                ),
        ),
      ),
    );
  }
}

/// A customizable and [ResponsiveAppBar] you can use to customize and specify whatever you like as [leading],[trailing] and [center]
/// (referred to as "tittle") in the normal AppBar.
/// The appBar automatically decide to either move the center widget to bottom, or make the center widget disappear  once
/// the condition you provide in the [centerActionCondition] Function is met,
/// the default condition is when the[ MediaQuery] size width of the screen
///  is less or equal to [smallScreenWidth] which have default value  of 500
///  and the default action for the condition is [ResponsiveCenterAction.MOVE_TO_BOTTOM]
///
class ResponsiveAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height;

  /// A functional parameter that specify the condition to fire the action specified in [centerAction]
  /// the condition includes [ResponsiveCenterAction.DO_NOTHING],[ResponsiveCenterAction.MOVE_TO_BOTTOM]
  /// ,[ResponsiveCenterAction.DISAPPEAR],
  /// like when the screenSize is too small and can't both accommodate [center] widget with the [leading]
  /// and [trailing] widget in a Row
  /// if null the default condition is when the[ MediaQuery] size   of the screen
  ///is less than [smallScreenWidth] which have default value  of [500], if false, it means you want the
  ///center child to remain as it is regardless of the action specified in [centerAction]
  ///
  final bool Function(double screenSize, double smallScreenWidth)
      centerActionCondition;

  /// Action to be fired if [centerActionCondition] is computted to be true
  /// The value of this variables are [ResponsiveCenterAction.DO_NOTHING],[ResponsiveCenterAction.MOVE_TO_BOTTOM]
  /// ,[ResponsiveCenterAction.DISAPPEAR]
  /// if null the default action is [ResponsiveCenterAction.MOVE_TO_BOTTOM], which shift the center widget to bottom,
  /// once the [centerActionCondition] is true
  /// if the action passed is  [ResponsiveCenterAction.DISAPPEAR], the center child disappears once the [centerActionCondition] is true
  /// if the action passed is  [ResponsiveCenterAction.DO_NOTHING], the center child stays at the same position regardless of whether the
  /// [centerActionCondition] is true or false
  ///
  final ResponsiveCenterAction centerAction;

  /// if the [centerActionCondition] condition is not supplied, [centerAction] will be fired once the
  /// screen size is less or equal to the value of this variable, and the default value is 500
  final double smallScreenWidth;

  /// The widget to be displayed at the start of the CustomAppBar
  final Widget leading;

  /// The widget to be displayed at the center of the CustomAppBar
  final PreferredSizeWidget center;

  /// The widget to be displayed at the end of the CustomAppBar
  final Widget trailing;
  final Color backgroundColor;

  /// Padding for the whole widget contained in the CustomAppBar, the default is const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0)
  final EdgeInsetsGeometry contentPadding;

  /// custom Padding for the leading widget contained in the CustomAppBar, the default const EdgeInsets.only(bottom: 8.0)
  final EdgeInsetsGeometry leadPadding;

  /// custom Padding for the trailing widget contained in the CustomAppBar, the default const EdgeInsets.only(bottom: 8.0)
  final EdgeInsetsGeometry trailPadding;

  /// custom Padding for the bottom widget contained in the CustomAppBar, the default const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0)
  final EdgeInsetsGeometry bottomPadding;

  /// The weight size that represent the ratio of space to be occupied by the leading widget compare to the trail and center widget, the weight is 1 by default.

  final leadFlexWeight;

  /// The weight size that represent the ratio of space to be occupied by the child widget at the center compare to the trail and lead widget, the weight is 2 by default.
  final centerFlexWeight;

  /// The weight size that represent the ratio of space to be occupied by the trailing widget compare to the trail and center widget, the weight is 1 by default.
  final trailFlexWeight;

  ResponsiveAppBar({
    Key key,
    this.height: cToolBarHeight,
    this.leading,
    this.center,
    this.trailing,
    this.backgroundColor,
    this.contentPadding:
        const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
    this.leadPadding: const EdgeInsets.only(bottom: 8.0),
    this.trailPadding: const EdgeInsets.only(bottom: 8.0),
    this.leadFlexWeight: 1,
    this.centerFlexWeight: 2,
    this.trailFlexWeight: 1,
    this.centerActionCondition,
    this.smallScreenWidth: 710,
    this.bottomPadding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 3.0),
    this.centerAction: ResponsiveCenterAction.MOVE_TO_BOTTOM,
  }) : super(key: key);

  @override
  _ResponsiveAppBarState createState() => _ResponsiveAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height +
      (centerAction == ResponsiveCenterAction.MOVE_TO_BOTTOM
          ? (center?.preferredSize?.height ?? 0.0)
          : 0.0));
//      (center!=null?100:0.0));
}

class _ResponsiveAppBarState extends State<ResponsiveAppBar> {
  @override
  Widget build(BuildContext context) {
    var isLeadExist = widget.leading != null;
    var isTailExist = widget.trailing != null;
    var isCenterExist = widget.center != null;
    var isCenterActionCondition = /*this.isCenterActionCondition;*/
        widget.centerActionCondition != null
            ? widget.centerActionCondition(
                MediaQuery.of(context).size.width, widget.smallScreenWidth)
            : MediaQuery.of(context).size.width <= widget.smallScreenWidth;
    var isShowCenter = (!isCenterActionCondition ||
        (isCenterActionCondition &&
            widget.centerAction == ResponsiveCenterAction.DO_NOTHING));
    var isMoveToBottom = isCenterActionCondition &&
        widget.centerAction == ResponsiveCenterAction.MOVE_TO_BOTTOM;

    return Column(
      children: [
        Container(
          height: isMoveToBottom
              ? widget.height - 4 /*- (widget.contentPadding.vertical)*/
              : widget.height,
//              -
//              (widget.contentPadding.vertical/*+widget.leadPadding.vertical+widget.trailPadding.vertical*/),
          child: Material(
              elevation: isMoveToBottom ? 0 : 2,
              color: widget.backgroundColor ?? Colors.white,
              child: Padding(
                padding: widget.contentPadding,
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: [
                    if (isLeadExist)
                      Expanded(
                        flex: widget.leadFlexWeight,
                        child: Padding(
                          padding: widget.leadPadding,
                          child: widget.leading,
                        ),
                      ),
                    if (isCenterExist && isShowCenter)
                      Expanded(
                          flex: widget.centerFlexWeight, child: widget.center),
                    if (isTailExist)
                      Expanded(
                        flex: widget.trailFlexWeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: widget.trailPadding,
                              child: widget.trailing,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              )),
        ),
        if (isMoveToBottom)
          Container(
            height: widget.center?.preferredSize?.height,
            child: Material(
//                elevation: 2,
                type: MaterialType.canvas,
                color: widget.backgroundColor ?? Colors.white,
                child: Padding(
                  padding: widget.bottomPadding,
                  child: widget.center,
                )),
          ),
        if (isMoveToBottom) Container(height: 1, color: Colors.grey[300])
      ],
    );
  }
}

enum ResponsiveCenterAction { DO_NOTHING, DISAPPEAR, MOVE_TO_BOTTOM }

class CustomToolTip extends StatelessWidget {
  const CustomToolTip({
    Key key,
    this.message,
    this.child,
    this.tipPadding: const EdgeInsets.all(10),
    this.tipMargin: const EdgeInsets.only(top: 8),
    this.tipRadius: 8,
    this.tipColor: Colors.black54,
    this.tipDecoration,
  }) : super(key: key);
  final message;
  final Widget child;
  final tipPadding;
  final tipMargin;
  final double tipRadius;
  final tipColor;
  final tipDecoration;

  @override
  Widget build(BuildContext context) {
    return message != null
        ? Tooltip(
            decoration: tipDecoration ??
                CustomDecorations.roundRectDecoration(
                    radius: tipRadius, color: tipColor),
            margin: tipMargin,
            padding: tipPadding,
            message: message,
            child: child)
        : child;
  }
}

class CustomDecorations {
  static BoxDecoration roundRectDecoration({double radius, Color color}) {
    return BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        color: color);
  }
}

class ShapedWidget extends StatelessWidget {
  const ShapedWidget({
    Key key,
    @required this.borderColor,
    @required this.child,
    this.backgroundColor: Colors.transparent,
    this.borderWidth: 1.5,
    this.padding,
    this.shape,
    this.decoration,
    this.noBorder: false,
  }) : super(key: key);

  final Color borderColor;
  final bool noBorder;
  final Color backgroundColor;
  final Widget child;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final BoxShape shape;
  final Decoration decoration;

  @override
  Widget build(BuildContext context) {
    return noBorder
        ? child
        : Container(
            padding: padding ?? EdgeInsets.only(bottom: 3, right: 3, left: 3),
            decoration: decoration ??
                BoxDecoration(
                    color: backgroundColor,
                    shape: shape ?? BoxShape.rectangle,
                    border: Border.all(
                        width: borderWidth,
                        color: borderColor ?? FbStyle.iconGrey)),
            child: child,
          );
  }
}

class CounterWidget extends StatelessWidget {
  final double childWidth;
  final double childHeight;
  final int count;
  final Alignment counterAlignment;
  final Widget child;
  final Color counterBackground;
  final Color counterTextColor;
  final double counterTextSize;
  final int maximumCount;
  final bool truncateCount;
  final bool showIfZero;
  final bool isMiniCounter;
  final BoxConstraints counterConstraints;
  final TextStyle counterTextStyle;
  final EdgeInsetsGeometry counterPadding;

  CounterWidget(
      {@required this.child,
      this.count: 0,
      this.counterBackground: Colors.red,
      this.showIfZero: false,
      this.counterTextColor: Colors.white,
      this.counterTextSize,
      this.maximumCount: 10,
      this.truncateCount: false,
      this.childWidth: 30,
      this.childHeight,
      this.counterAlignment,
      this.counterConstraints,
      this.counterTextStyle,
      this.counterPadding, this.isMiniCounter:false});

  @override
  Widget build(BuildContext context) {
    return !showIfZero && count == 0
        ? child
        : Container(
            width: childWidth * 2,
            height: childHeight ?? childWidth * 2,
            child: Stack(
              children: [
                Align(
//                    alignment: FractionalOffset(0.5, 0.5)
                    alignment: Alignment.center,
                    child: child),
                if (count > 0 || showIfZero) buildCounter(context)
              ],
            ),
          );
  }

  buildCounter(BuildContext context) {
    var isSingleNum = count < maximumCount;
    return Align(
      alignment:  isMiniCounter?FractionalOffset(0.8,0.22):Alignment.topRight,
      child: Container(
        constraints: counterConstraints ??
            BoxConstraints(minWidth:isMiniCounter?15:( isSingleNum ? 20 : 28), minHeight:isMiniCounter?15:20),
        decoration: isSingleNum
            ? BoxDecoration(
                shape: BoxShape.circle,
                color: counterBackground,
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: counterBackground,
              ),
        child: Padding(
          padding: counterPadding ??
              (isSingleNum
                  ? const EdgeInsets.only(top: 3, left: 5, right: 5, bottom: 2)
                  : const EdgeInsets.only(
                      top: 1, left: 5, right: 2, bottom: 0)),
          child: Text(
            (!isSingleNum && truncateCount)
                ? "${maximumCount - 1}+"
                : count.toString(),
            style: counterTextStyle ??
                TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: counterTextSize?? (isMiniCounter?9:14),
                  color: counterTextColor,
                ),
            textAlign: isSingleNum ? TextAlign.center : TextAlign.start,
          ),
        ),
      ),
    );
  }
}

class RoundIcon extends StatelessWidget {
  const RoundIcon({
    Key key,
    @required this.icon,
    @required this.onPress,
    this.iconColor,
    this.padding: const EdgeInsets.only(right: 8.0),
    this.circleBackground,
    this.iconSize: appBarIconHeight - 7,
    this.elevation: 0 /*22*/,
  }) : super(key: key);

  final IconData icon;
  final Function onPress;
  final Color iconColor;
  final double iconSize;
  final double elevation;
  final Color circleBackground;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        elevation: elevation,
        type: MaterialType.circle,
        color: circleBackground ?? Colors.grey[200],
        child: IconButton(
          iconSize: iconSize,
          color: iconColor != null ? iconColor : Colors.black,
          icon: Icon(icon),
          onPressed: onPress,
        ),
      ),
    );
  }
}

class RoundSearchBar extends StatelessWidget {
  final TextEditingController txtController;
  final String label;
  final String initialText;
  final double width;
  final IconData prefixIcon;
  final Color prefixIconColor;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Function iconTap;
  final Function onSubmitted;
  final Function onTap;
  final double height;
  final bool noPrefix;
  final bool noBorder;
  final Widget trailing;

  RoundSearchBar(
      {@required this.txtController,
      this.label,
      this.initialText,
      this.width,
      this.prefixIcon,
      this.height,
      this.prefixIconColor,
      this.iconTap,
      this.onSubmitted,
      this.onTap,
      this.noPrefix: false,
      this.backgroundColor,
      this.borderColor,
      this.borderWidth: 0, this.trailing, this.noBorder:false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side:noBorder?BorderSide.none: BorderSide(
                color: borderColor ?? Colors.grey[600], width: borderWidth)),
        color: backgroundColor ?? Colors.grey[200],
        elevation: 0,
        child: ListTile(
          leading: noPrefix
              ? null
              : IconButton(
                  icon: Icon(prefixIcon == null ? Icons.search : prefixIcon),
                  color: prefixIconColor == null
                      ? Colors.black12
                      : prefixIconColor,
                  onPressed: iconTap,
                ),
          title: TextField(
            /*expands: true,maxLines: null,minLines: null,*/
            style: TextStyle(fontSize: height == null ? 13 : height / 2.3),
            controller: txtController /*..text = initialText*/,
            decoration: InputDecoration(
//            labelText: label,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(
                    left: 2,
                    bottom: height == null ? 11 : height / 3,
                    /*top: 15,*/
                    right: 2),
                hintText: label),
//        onChanged: ,
            onTap: onTap,
            onSubmitted: onSubmitted,
//        onEditingComplete: ,
          ),trailing: trailing,
        ),
      ),
    );
  }
}

showCDialog(context, {String label}) {
  List<Item> people = [
    for (var i = 0; i < 8; i++)
      Item(
        name: "Shittu Gbadebo",
      ),
  ];
  List<Item> rPeople = [
    Item(name: "Recent Searches"),
    for (var i = 0; i < 8; i++) Item(name: "Alausa Ikeja", img: "src"),
  ];
  showDialog(
    barrierColor: Colors.transparent,
    context: context,
    builder: (context) => Column(
      children: [
        Row(
          children: [
            Dialog(
              elevation: 5,
              insetPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: SearchDialogWidget(
                  inputLabel: label,
                  suggestSearchItemCount: people.length,
                  recentSearchItemsCount: rPeople.length,
                  suggestedBuilder: (context, index) =>
                      getListItem(people[index], index, false),
                  recentSearchBuilder: (context, index) =>
                      getListItem(rPeople[index], index, true)),
            ),
          ],
        ),
      ],
    ),
  );
}

getListItem(Item item, int index, bool isRecentList) => index == 0 &&
        isRecentList
    ? ListTile(
        contentPadding: EdgeInsets.only(left: 18, right: 0),
//            leading: SizedBox(width: 30,),
        title: Text(
          item.name,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        trailing: FlatButton(
          onPressed: () {},
          child: Text(
            "Edit",
            style: TextStyle(
              color: Colors.lightBlue,
            ),
          ),
        ),
      )
    : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          hoverColor: Colors.grey[300],
          onPressed: () {},
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: item.img != null
                ? CircleAvatar(
                    radius: 17,
                    child: Image.network(item.img),
                  )
                : null,
            title: Text(
              item.name,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: IconButton(
              icon: Icon(MdiIcons.tableCancel),
              onPressed: () {},
            ),
          ),
        ),
      );

class Item {
  String name;
  String img;

  Item({this.name, this.img});
}

class SearchDialogWidget extends StatefulWidget {
  //List of
  final int suggestSearchItemCount;
  final int recentSearchItemsCount;
  final String inputLabel;
  final Widget Function(BuildContext context, int index) suggestedBuilder;
  final Widget Function(BuildContext context, int index) recentSearchBuilder;

  SearchDialogWidget(
      {this.suggestSearchItemCount,
      this.recentSearchItemsCount,
      this.suggestedBuilder,
      this.recentSearchBuilder,
      this.inputLabel});

  @override
  _SearchDialogWidgetState createState() => _SearchDialogWidgetState();
}

class _SearchDialogWidgetState extends State<SearchDialogWidget> {
  final controller = TextEditingController();
  bool showRecentList = true;

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          showRecentList = true;
        });
      } else {
        setState(() {
          showRecentList = false;
        });
      }
    });
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: FbStyle.iconGrey,
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    child: TextField(
                      style: TextStyle(fontSize: 13),
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 18, bottom: 5, /*top: 15,*/ right: 18),
                        hintText: widget.inputLabel,
                      ),
//                    onChanged: (text) {},
//              onTap: onTap,
//              onSubmitted: onSubmitted,
//        onEditingComplete: ,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (showRecentList)
            ...List.generate(widget.recentSearchItemsCount, (index) => index)
                .map((index) => widget.recentSearchBuilder(context, index))
          else
            ...List.generate(widget.suggestSearchItemCount, (index) => index)
                .map((index) => widget.suggestedBuilder(context, index))
        ],
      ),
    );
  }
}

//class Facebook
class FacebookLogo extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final List<InlineSpan> textSpans;

  final bool isFullLogo;
  final double height;
  final double textHeight;
  final double width;
  final double fontSize;
  final Color fontColor;
  final Gradient logoGradient;
  final double letterSpacing;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final String fontFamily;
  final List<Shadow> textShadows;
  final BoxShape logoShape;
  final Decoration decoration;
  final BorderRadiusGeometry shapeRadius;
  final Color shapeBorderColor;
  final double borderWidth;
  final List<BoxShadow> shapeShadow;
  final TextAlign textAlign;
  final EdgeInsetsGeometry padding;

  const FacebookLogo.full(
      {this.fontSize,
      this.fontColor,
      this.text,
      this.textStyle,
      this.textSpans,
      this.letterSpacing,
      this.fontWeight,
      this.fontStyle,
      this.fontFamily,
      this.textShadows,
      this.textHeight,
      this.textAlign})
      : isFullLogo = true,
        width = null,
        height = null,
        logoGradient = null,
        logoShape = null,
        decoration = null,
        shapeRadius = null,
        shapeBorderColor = null,
        borderWidth = null,
        padding = null,
        shapeShadow = null;

  const FacebookLogo.shape({
    this.height,
    this.width,
    this.fontColor,
    this.logoGradient,
    this.textHeight,
    this.text,
    this.textStyle,
    this.fontWeight,
    this.fontStyle,
    this.fontFamily,
    this.textShadows,
    this.logoShape,
    this.decoration,
    this.shapeRadius,
    this.shapeBorderColor,
    this.textSpans,
    this.borderWidth,
    this.shapeShadow,
    this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.padding,
  }) : isFullLogo = false;

  const FacebookLogo({
    Key key,
    @required this.isFullLogo,
    this.height,
    this.width,
    this.fontSize,
    this.fontColor,
    this.logoGradient,
    this.textHeight,
    this.text,
    this.textStyle,
    this.textSpans,
    this.letterSpacing,
    this.fontWeight,
    this.fontStyle,
    this.fontFamily,
    this.textShadows,
    this.logoShape,
    this.decoration,
    this.shapeRadius,
    this.shapeBorderColor,
    this.borderWidth,
    this.shapeShadow,
    this.textAlign,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var singleHeight =
        !isFullLogo ? (height ?? (width ?? appBarLogoHeight)) : null;
    var textSize = isFullLogo ? fontSize ?? 28 : (fontSize ?? singleHeight);
    var shape = logoShape ?? BoxShape.circle;
    var style = isFullLogo
        ? (textStyle ??
            TextStyle(
                shadows: textShadows,
                color: fontColor ?? FbStyle.accent,
                fontSize: textSize,
                fontWeight: fontWeight ?? FontWeight.bold,
                fontStyle: fontStyle ?? FontStyle.normal,
                fontFamily: fontFamily,
                height: textHeight,
                letterSpacing: letterSpacing ?? -1.2))
        : (textStyle ??
            TextStyle(
                color: fontColor ?? FbStyle.white,
                fontSize: textSize,
                fontWeight: fontWeight ?? FontWeight.w700,
                fontStyle: fontStyle ?? FontStyle.normal,
                fontFamily: fontFamily,
                shadows: textShadows,
                height: textHeight ?? singleHeight / (singleHeight - 3),
                letterSpacing: letterSpacing ?? -1.2));
    var logoText = (textSpans != null
        ? Text.rich(
            TextSpan(children: textSpans),
            textAlign: isFullLogo ? TextAlign.start : TextAlign.justify,
            style: style,
          )
        : Text(
            text ?? (isFullLogo ? "facebook" : "f"),
            textAlign: TextAlign.start,
            style: style,
          ));
    return isFullLogo
        ? logoText
        : Container(
            padding: padding ??
                (shape == BoxShape.circle
                    ? null
                    : EdgeInsets.symmetric(horizontal: 15)),
            width: width,
            height: height,
            constraints: BoxConstraints(
                minWidth: appBarLogoHeight, minHeight: singleHeight),
            decoration: decoration ??
                BoxDecoration(
                  border: Border.all(
                    color: shapeBorderColor ?? Colors.white,
                    width: borderWidth ?? 0,
                  ),
                  borderRadius: shape == BoxShape.circle
                      ? null
                      : (shapeRadius ?? BorderRadius.zero),
                  boxShadow: shapeShadow,
                  shape: shape,
                  gradient: logoGradient ??
                      LinearGradient(
                          colors: [
                            Colors.blue.shade200,
                            Colors.blue.shade300,
                            FbStyle.logo2,
                            FbStyle.logo3,
                            FbStyle.logo4,
                            FbStyle.logo5,
                            FbStyle.logo6
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                ),
            child: Center(child: logoText),
          );
  }
}

Widget buildWidgetOnCondition(bool condition, Widget widget,
        {Widget altWidget}) =>
    condition ? widget : (altWidget == null ? Container() : altWidget);
//          ...widget.recentSearchItemsCount
//              .asMap()
//              .map((index, value) =>
//                  MapEntry(index, widget.recentSearchBuilder(context,index, value)))
//              .values
