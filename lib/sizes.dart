import 'package:flutter/material.dart';

const cToolBarHeight = 63.0;
const appBarLogoHeight = cToolBarHeight * 0.64;
const appBarIconHeight = cToolBarHeight * 0.50;
const mAppBarIconHeight = cToolBarHeight * 0.46;
const topAppBarHeight = cToolBarHeight / 1.3;
const double mobileScreenWidth = 450;
const double smallerSize = 610;
const double smallSize = 723;
const largeSize = 1100;
const extraLargeSize = 1258;
const onlyBodyWidth = 897;
const noGap4TwoPanelWidth = 1038.0;
const noGap4BodyWidth = 1227.0;
const rPanelScaleWidth = 1035;
const requireBodyPadWidth = 1142;
const double noBodyPadWidth = 1233;

bool isLargeScreen(BuildContext context) {
  var screenWidth = MediaQuery.of(context).size.width;
  return screenWidth > largeSize && screenWidth < extraLargeSize;
}

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

bool isExtraLargeScreen(BuildContext context) =>
    MediaQuery.of(context).size.width > extraLargeSize;

bool isSmallScreen(BuildContext context) =>
    MediaQuery.of(context).size.width < smallSize &&
    MediaQuery.of(context).size.width > smallerSize;

bool isSmallerScreen(BuildContext context) =>
    MediaQuery.of(context).size.width <= smallerSize;

bool isMobileTabletScreen(BuildContext context) =>
//    isSmallerScreen(context) ||
//    isSmallScreen(context) ;
MediaQuery.of(context).size.width>mobileScreenWidth && MediaQuery.of(context).size.width<=smallSize;

bool isMobileScreen(BuildContext context) =>
    MediaQuery.of(context).size.width <= mobileScreenWidth ;

bool isMediumScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > smallSize &&
      MediaQuery.of(context).size.width < largeSize;
}

bool isOnlyBody(BuildContext context) =>
    MediaQuery.of(context).size.width <
    onlyBodyWidth /*&& MediaQuery.of(context).size.width<largeSize*/;

bool isRequirePadWidth(BuildContext context) =>
    MediaQuery.of(context).size.width >= requireBodyPadWidth &&
    MediaQuery.of(context).size.width <= noBodyPadWidth;

bool isStopBodyPadWidth(BuildContext context) =>
    MediaQuery.of(context).size.width >= noBodyPadWidth;

bool isStopTwoPanelGap(BuildContext context) =>
    MediaQuery.of(context).size.width >= noGap4TwoPanelWidth &&MediaQuery.of(context).size.width <= largeSize  ;

bool isMediumLarge(BuildContext context) =>
    isMediumScreen(context) || isLargeScreen(context);

bool isAtLeastMedium(BuildContext context) =>
//    isSmallScreen(context) ||
    isMediumScreen(context) ||
    isLargeScreen(context) ||
    isExtraLargeScreen(context);

bool isAtLeastLarge(BuildContext context) {
  var screenWidth = MediaQuery.of(context).size.width;
  return screenWidth > largeSize;
}
