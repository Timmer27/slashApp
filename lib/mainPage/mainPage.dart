import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:slash/mainPage/ControllPanner_Mobile_Portrait.dart';
import 'package:slash/mainPage/ControllPanner_Tablet.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    double mediaFontSize = 0.0;
    double itemHeightSize = 0.0;
    double paddingSize = 0.0;
    double menuMaxHeight = 0.0;

    if (screenWidth < 700) {
      mediaFontSize = screenWidth * 0.03;
      itemHeightSize = 50.0;
      paddingSize = 0.5;
      menuMaxHeight = 500;
    } else if (screenWidth < 1050) {
      mediaFontSize = screenWidth * 0.030;
      itemHeightSize = 65.0;
      paddingSize = 2.0;
      menuMaxHeight = 800;
    } else if (screenWidth < 2000) {
      mediaFontSize = screenWidth * 0.025;
      itemHeightSize = (screenWidth * 0.025) * 2;
      paddingSize = 13.0;
      menuMaxHeight = 1000;
    } else {
      mediaFontSize = screenWidth * 0.025;
      itemHeightSize = (screenWidth * 0.025) * 2;
      paddingSize = 30.0;
      menuMaxHeight = 1200;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: mediaFontSize),
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(builder: (context, sizingInformation) {
          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
            return OrientationLayoutBuilder(
              landscape: (context) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: [
                    // text size && words
                    ControllPannalTablet(
                        mediaFontSize: 16.0,
                        descFontSize: 18.0,
                        iconSize: 32.0,
                        paddingSize: paddingSize,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        itemHeightSize: itemHeightSize,
                        menuMaxHeight: menuMaxHeight),
                  ],
                ),
              ),
              portrait: (context) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: [
                    // text size && words
                    ControllPannalTablet(
                        mediaFontSize: 16.0,
                        descFontSize: 18.0,
                        iconSize: 32.0,
                        paddingSize: paddingSize,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        itemHeightSize: itemHeightSize,
                        menuMaxHeight: menuMaxHeight),
                  ],
                ),
              ),
            );
          }

          if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
            return OrientationLayoutBuilder(
              landscape: (context) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: [
                    // text size && words
                    ControllPannalTablet(
                        mediaFontSize: 16.0,
                        descFontSize: 18.0,
                        iconSize: 32.0,
                        paddingSize: paddingSize,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        itemHeightSize: itemHeightSize,
                        menuMaxHeight: menuMaxHeight),
                  ],
                ),
              ),
              portrait: (context) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: [
                    // text size && words
                    ControllPannalTablet(
                        mediaFontSize: 16.0,
                        descFontSize: 18.0,
                        iconSize: 32.0,
                        paddingSize: paddingSize,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        itemHeightSize: itemHeightSize,
                        menuMaxHeight: menuMaxHeight),
                  ],
                ),
              ),
            );
          }

          if (sizingInformation.deviceScreenType == DeviceScreenType.watch) {
            return OrientationLayoutBuilder(
              portrait: (context) => Container(color: Colors.green),
              landscape: (context) => Container(color: Colors.pink),
            );
          }

          // 이건 모바일
          return OrientationLayoutBuilder(
            landscape: (context) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  // text size && words
                  ControllPannalTablet(
                      mediaFontSize: 16.0,
                      descFontSize: 18.0,
                      iconSize: 32.0,
                      paddingSize: paddingSize,
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      itemHeightSize: itemHeightSize,
                      menuMaxHeight: menuMaxHeight),
                ],
              ),
            ),
            portrait: (context) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  // text size && words
                  ControllPannalMobilePortrait(
                      mediaFontSize: 16.0,
                      descFontSize: 18.0,
                      iconSize: 32.0,
                      paddingSize: paddingSize,
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      itemHeightSize: itemHeightSize,
                      menuMaxHeight: menuMaxHeight),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
