import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slash/mainPage/ControllPanner.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _fileName = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    double mediaFontSize = 0.0;
    double itemHeightSize = 0.0;
    double paddingSize = 0.0;
    double menuMaxHeight = screenHeight / 3;

    if (screenWidth < 700) {
      mediaFontSize = screenWidth * 0.020;
      itemHeightSize = 65.0;
      paddingSize = 0.5;
    } else if (screenWidth < 1050) {
      mediaFontSize = screenWidth * 0.020;
      itemHeightSize = 65.0;
      paddingSize = 2.0;
    } else if (screenWidth < 2000) {
      mediaFontSize = screenWidth * 0.025;
      itemHeightSize = (screenWidth * 0.025) * 2;
      paddingSize = 13.0;
    } else {
      mediaFontSize = screenWidth * 0.025;
      itemHeightSize = (screenWidth * 0.025) * 2;
      paddingSize = 30.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                // text size && words
                ControllPannal(
                    mediaFontSize: mediaFontSize,
                    paddingSize: paddingSize,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    itemHeightSize: itemHeightSize,
                    menuMaxHeight: menuMaxHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
