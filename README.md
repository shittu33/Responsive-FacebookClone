# Facebook-UI clone (Web & Mobile)

A responsive Facebook UI clone for both Facebook web and Mobile.
# Preview

![screenShot](https://github.com/shittu33/Responsive-FacebookClone/blob/master/screen.gif?raw=true)

## Technology Used
- Flutter

## How Facebook UI works
The Facebook UI is a responsive UI for Facebook web and Mobile which support any screen Size.
The App maintains its responsiveness with the following declared sizes:
- MobileScreenWidth (450 px)
- WebSize:
  - SmallerSize: (610 px)
  - SmallSize: (723 px)
  - LargeSize: (1100 px)
  - ExtraLargeSize: (1258 px)

The app handles responsiveness for  all its Components with 2 Main Components: **FacebookAppBar** and **FacebookBody**
#### Responsive FacebookAppBar
The App used a Custom widget named ResponsiveAppBar whose view depends on the current Screen Size:
- MobileScreenWidth: when the screen is so small (like MobileScreen) it displays two level AppBar at the top of the App
- WebSize: when the app is viewed from Desktop browser it displays one Level AppBar at the top of the App, when the screen is Very Large it display
all the tabs,fullSearchBar and buttons on the AppBar, then as the screen grew smaller, some of the buttons,fullSearchBar and Tab get Smaller and eventually disappears

#### Responsive FacebookBody
The app divide the Body Contents in to 3 segments namely: RightPanel,LeftPanel & MainBodyPanel.
The app display one,two or both segments depending on the current screenSize:
- MobileScreenWidth: when the screen is so small (like **MobileScreen**)  only the MainBodyPanel will be shown on the Screen
and reduce its children Components Sizes to fit the current screen.
- WebSize: when the app is viewed from Desktop browser the app decide how much Panel to be
shown depending on the browser window width, if the width is of smallSize or SmallerSize, it displays
only MainBodyPanel: when its a LargeSize it display just 2 Panels(RightPanel & MainBodyPanel); when its
ExtraLargeSize it displays the 3 panels and adjust its children Components Sizes too.
## Installation
```cmd
git clone https://github.com/shittu33/Responsive-FacebookClone.git
```
## Run the App on a Web Browser
Run the following commands to use the latest version of the Flutter SDK from the beta channel and enable web support:
```cmd
 flutter channel beta
 flutter upgrade
 flutter config --enable-web
```
To serve your app from localhost in Chrome, enter the following from the top of the package:
```cmd
flutter run -d chrome
```
If everything goes fine You can now run your own version of FacebookClone.
## Run the App on your Mobile Device
To Build Apk:
```cmd
flutter build apk
```
To Run it directly on your device, run the following command and select your device:
```cmd
flutter run 
```
## Run the App on your Browser (no Setup/Installation Required)
- [Click here for Demo](https://shittu33.github.io/Responsive-FacebookClone/)


