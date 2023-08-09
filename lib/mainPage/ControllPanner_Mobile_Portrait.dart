import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ControllPannalMobilePortrait extends StatefulWidget {
  final double mediaFontSize;
  final double descFontSize;
  final double iconSize;
  final double paddingSize;
  final double itemHeightSize;
  final double screenHeight;
  final double screenWidth;
  final double menuMaxHeight;

  ControllPannalMobilePortrait(
      {super.key,
      required this.mediaFontSize,
      required this.descFontSize,
      required this.iconSize,
      required this.paddingSize,
      required this.itemHeightSize,
      required this.screenHeight,
      required this.screenWidth,
      required this.menuMaxHeight});

  @override
  State<ControllPannalMobilePortrait> createState() =>
      _ControllPannalMobilePortraitState();
}

class _ControllPannalMobilePortraitState
    extends State<ControllPannalMobilePortrait> {
  final List<int> fontSize = [
    300,
    400,
    500,
    600,
    700,
    800,
    900,
    1000,
    1100,
    1200,
    1300,
    1400,
    1500,
    1600
  ];
  final List<int> words = [1, 2, 3, 4, 5, 6];
  // int _selectedWords = 1;
  int _selectedFontSize = 500;
  int _durationSpeed = 1;

  String _fileName = '';
  int wordCnt = 0;
  Timer? timer;

  // orgin
  List<String> _contentsAll = [''];
  String _contents = '';
  String _showContent = '';

  // List<String> _contentsAll = [
  //   "START",
  //   "Hello.",
  //   "It is a test file.",
  //   "It shows contents.",
  //   "I wish there is no error.",
  //   "Please!",
  //   "End of contents"
  // ];
  // String _contents =
  //     // _contentsAll.join(",");
  //     'Hello. It is a test file. It shows contents. I wish there is no error. Please! End of contents';

  double _xPosition = -10.0;
  double _yPosition = 30.0;
  double _widgetSize = 50.0;
  bool isPlaying = false;
  bool _moveToLeft = false;

  void _moveButtons() {
    if (_moveToLeft) {
      setState(() {
        _xPosition = 0;
        _moveToLeft = false;
      });
    } else {
      setState(() {
        _xPosition = MediaQuery.of(context).size.width - (_widgetSize * 1.8);
        _moveToLeft = true;
      });
    }
  }

  void _stopAutoPlay() {
    timer?.cancel();
    setState(() {
      isPlaying = !isPlaying; // Set isPlaying to false when stopping manually
    });
    print('stop');
  }

  void _autoPlay() {
    // int count = wordCnt;
    timer?.cancel();

    int maxVal = _contentsAll.length;
    // wordCnt = 0;
    setState(() {
      isPlaying = !isPlaying;
    });
    print('test');
    print('START');

    timer = Timer.periodic(Duration(seconds: _durationSpeed), (timer) {
      if (wordCnt < maxVal) {
        setState(() {
          _showContent = _contentsAll[wordCnt];
          wordCnt++;
        });
      } else {
        timer.cancel();
        setState(() {
          isPlaying = false; // Set isPlaying to false when the timer completes
        });
      }
    });
  }

  void _incrementWordCnt() {
    timer?.cancel();
    if (_contentsAll.length - 1 > wordCnt) {
      setState(() {
        wordCnt++;
        _showContent = _contentsAll[wordCnt];
      });
      print(wordCnt);
    }
  }

  void _decrementWordCnt() {
    timer?.cancel();
    if (wordCnt == 0) {
      setState(() {
        _showContent = _contentsAll[0];
      });
    } else if (_contentsAll.length > wordCnt && wordCnt != 0) {
      wordCnt--;
      setState(() {
        _showContent = _contentsAll[wordCnt];
        print('???');
      });
    }
  }

  void _resetWordCnt() {
    timer?.cancel();
    setState(() {
      _showContent = _contentsAll[0];
      wordCnt = 0;
      isPlaying = true;
    });
  }

  void _findAll() {
    timer?.cancel();
    setState(() {
      _showContent = _contents;
    });
  }

  void _openFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['txt']);
    if (result != null) {
      File file = File(result.files.single.path!);
      final filename = file.path.split('/').last;
      final encoding = Encoding.getByName('UTF-8');

      if (encoding != null) {
        String rawContents = await file.readAsString(encoding: encoding);
        setState(() {
          _contentsAll = rawContents.split('/');
          _contents = rawContents;
          _fileName = filename;
          try {
            _showContent = _contentsAll[0];
          } catch (e) {
            _showContent = '';
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final int selectedFontSize =
    //     Provider.of<FontCounterModel>(context).selectedFontSize;

    // int durationSeconds =
    //     Provider.of<FontCounterModel>(context).durationSeconds;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // font size selection dropdown button
            Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: DropdownSearch<int>(
                  items: fontSize,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Font Size",
                        // hintText: "country in menu mode",
                      ),
                      baseStyle: TextStyle(fontSize: widget.descFontSize)),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedFontSize = val;
                      });
                    }
                  },
                  selectedItem: 500,
                )),
            const SizedBox(
              width: 30.0,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),

        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widget.paddingSize,
              vertical: widget.screenHeight / 30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              direction: Axis.horizontal, // 나열 방향
              // alignment: WrapAlignment.start, // 정렬 방식
              alignment: WrapAlignment.start,
              spacing: 4, // 좌우 간격
              runSpacing: 0.5, // 상하 간격
              children: [
                Container(
                  width: 250,
                  child: TextFormField(
                    initialValue: _fileName,
                    enabled: false, // Disable user input
                    decoration: InputDecoration(
                      labelText: _fileName,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  iconSize: widget.iconSize,
                  onPressed: () => _openFile(),
                  icon: Icon(
                    Icons.attach_file_sharp,
                    size: widget.iconSize,
                    color: Color.fromARGB(174, 66, 66, 66),
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(widget.paddingSize),
          child: Container(
            height: widget.screenHeight * 0.55,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(
                        _showContent,
                        style: TextStyle(fontSize: _selectedFontSize / 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(widget.paddingSize),
          child: Container(
            height: 100,
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100, // 버튼의 고정된 너비 설정, 원하는 너비로 수정하세요.
                          child: ElevatedButton(
                            onPressed: () {
                              _autoPlay();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 18.0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'STOP WATCHING',
                              style: TextStyle(fontSize: widget.mediaFontSize),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: 100,
                          height: 35,
                          child: TextField(
                            // controller: _controller,
                            onChanged: (value) {
                              // _isTimeFilled = (value != 0);
                              setState(() {
                                _durationSpeed = int.parse(value);
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Enter seconds',
                              labelStyle:
                                  TextStyle(fontSize: widget.descFontSize),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100, // 버튼의 고정된 너비 설정, 원하는 너비로 수정하세요.
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _resetWordCnt();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 18.0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'RESET',
                              style: TextStyle(fontSize: widget.mediaFontSize),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: 100, // 버튼의 고정된 너비 설정, 원하는 너비로 수정하세요.
                          child: ElevatedButton(
                            onPressed: () {
                              _moveButtons();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 18.0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'L R',
                              style: TextStyle(fontSize: widget.mediaFontSize),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Positioned(
                  left: _xPosition - 8,
                  bottom: _yPosition,
                  child: IconButton(
                    iconSize: widget.iconSize,
                    onPressed: () => {_decrementWordCnt()},
                    icon: Icon(Icons.arrow_back_ios_rounded),
                  ),
                ),
                Positioned(
                  left: _xPosition + 14,
                  bottom: _yPosition,
                  child: IconButton(
                    iconSize: widget.iconSize,
                    onPressed: () {
                      if (_contentsAll.length > wordCnt - 1 && wordCnt >= 0) {
                        _incrementWordCnt();
                      }
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),

        // )
      ],
    );
  }
}
