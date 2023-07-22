import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ControllPannalTablet extends StatefulWidget {
  final double mediaFontSize;
  final double descFontSize;
  final double iconSize;
  final double paddingSize;
  final double itemHeightSize;
  final double screenHeight;
  final double screenWidth;
  final double menuMaxHeight;

  ControllPannalTablet(
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
  State<ControllPannalTablet> createState() => _ControllPannalTabletState();
}

class _ControllPannalTabletState extends State<ControllPannalTablet> {
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
  int _durationSpeed = 1000;

  String _fileName = '';
  int wordCnt = 0;
  Timer? timer;

  // orgin
  // List<String> _contentsAll = [''];
  String _contents = '';
  String _showContent = '';

  List<String> _contentsAll = [
    "START",
    "Hello.",
    "It is a test file.",
    "It shows contents.",
    "I wish there is no error.",
    "Please!",
    "End of contents"
  ];
  // String _contents =
  //     // _contentsAll.join(",");
  //     'Hello. It is a test file. It shows contents. I wish there is no error. Please! End of contents';

  void _autoPlay() {
    // int count = wordCnt;
    timer?.cancel();
    int maxVal = _contentsAll.length;
    wordCnt = 0;
    timer = Timer.periodic(Duration(milliseconds: _durationSpeed), (timer) {
      if (wordCnt < maxVal) {
        setState(() {
          _showContent = _contentsAll[wordCnt];
          wordCnt++;
        });
      } else {
        timer.cancel();
      }
      print(wordCnt);
      print(_durationSpeed);
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
      print(wordCnt);
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
          try {
            _showContent = _contentsAll[0];
          } catch (e) {
            _showContent = '';
          }
          _fileName = filename;
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
            Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: DropdownSearch<int>(
                  items: const [250, 300, 350, 400, 450, 500],
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Play Speed",
                        // hintText: "country in menu mode",
                      ),
                      baseStyle: TextStyle(fontSize: widget.descFontSize)),
                  onChanged: (value) => setState(() {
                    int intVal = value ?? 300;
                    if (intVal > 900) {
                      _durationSpeed = 100;
                    }
                    _durationSpeed = 1000 - intVal;

                    print(_durationSpeed);
                  }),
                  selectedItem: 350,
                )),
            const SizedBox(
              width: 3.0,
            ),
            Flexible(
              // fit: FlexFit.tight,
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _autoPlay();
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 18.0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'START',
                  style: TextStyle(fontSize: widget.mediaFontSize),
                ),
              ),
            ),
            const SizedBox(
              width: 3.0,
            ),
            Flexible(
              // fit: FlexFit.tight,
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _resetWordCnt();
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 18.0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'RESET',
                  style: TextStyle(fontSize: widget.mediaFontSize),
                ),
              ),
            ),
            const SizedBox(
              width: 3.0,
            ),
            Flexible(
              // fit: FlexFit.tight,
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _findAll();
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 18.0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '본문보기',
                  style: TextStyle(fontSize: widget.mediaFontSize),
                ),
              ),
            ),
          ],
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
                    initialValue: _fileName == ""
                        ? "Please open your text file"
                        : _fileName,
                    enabled: false, // Disable user input
                    decoration: InputDecoration(
                      labelText: 'File Name',
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
                // IconButton(
                //   icon: Icons.file_open,
                //   onPressed: () => _openFile(),
                //   style: TextButton.styleFrom(
                //     minimumSize: Size.zero,
                //     padding: EdgeInsets.zero,
                //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //   ),
                // ),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(widget.paddingSize),
          child: Container(
            height: widget.screenHeight * 0.65,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Align the children at the ends
              children: [
                IconButton(
                  iconSize: widget.iconSize,
                  onPressed: () => {_decrementWordCnt()},
                  icon: Icon(Icons.keyboard_double_arrow_left_rounded),
                ),
                Expanded(
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
                IconButton(
                  iconSize: widget.iconSize,
                  onPressed: () {
                    if (_contentsAll.length > wordCnt - 1 && wordCnt >= 0) {
                      _incrementWordCnt();
                    }
                  },
                  icon: Icon(Icons.keyboard_double_arrow_right_rounded),
                ),
              ],
            ),
          ),
        )
        // )
      ],
    );
  }
}
