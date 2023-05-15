import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ControllPannal extends StatefulWidget {
  final double mediaFontSize;
  final double paddingSize;
  final double itemHeightSize;
  final double screenHeight;
  final double screenWidth;
  final double menuMaxHeight;

  ControllPannal(
      {super.key,
      required this.mediaFontSize,
      required this.paddingSize,
      required this.itemHeightSize,
      required this.screenHeight,
      required this.screenWidth,
      required this.menuMaxHeight});

  @override
  State<ControllPannal> createState() => _ControllPannalState();
}

class _ControllPannalState extends State<ControllPannal> {
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
  // final List<int> words = [1, 2, 3, 4, 5, 6];
  // int _selectedWords = 1;
  int _selectedFontSize = 500;
  int _durationSpeed = 1000;

  String _fileName = '';
  int wordCnt = 0;
  Timer? timer;

  // orgin
  List<String> _contentsAll = [''];
  String _contents = '';
  String _showContent = '';

  // List<String> _contentsAll = [
  //   "Hello.",
  //   "It is a test file.",
  //   "It shows contents.",
  //   "I wish there is no error.",
  //   "Please!",
  //   "End of contents"
  // ];
  // String _contents =
  //     'Hello. It is a test file. It shows contents. I wish there is no error. Please! End of contents';

  void _autoPlay() {
    // int count = wordCnt;
    timer?.cancel();
    int maxVal = _contentsAll.length;
    timer = Timer.periodic(Duration(milliseconds: _durationSpeed), (timer) {
      if (wordCnt + 1 < maxVal) {
        setState(() {
          _showContent = _contentsAll[wordCnt];
          wordCnt++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _incrementWordCnt() {
    timer?.cancel();
    if (_contentsAll.length - 1 > wordCnt) {
      setState(() {
        if (wordCnt == 0) {
          _showContent = _contentsAll[0];
          wordCnt++;
        } else {
          wordCnt++;
          _showContent = _contentsAll[wordCnt];
        }
      });
    }
  }

  void _decrementWordCnt() {
    timer?.cancel();
    if (wordCnt > 0) {
      setState(() {
        wordCnt--;
        _showContent = _contentsAll[wordCnt];
      });
    }
  }

  void _resetWordCnt() {
    timer?.cancel();
    setState(() {
      _showContent = _contentsAll[0];
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
          children: [
            // font size selection dropdown button
            SizedBox(
              child: Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: widget.paddingSize),
                    child: Text(
                      "FONT SIZE",
                      style: TextStyle(fontSize: widget.mediaFontSize),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.paddingSize,
                        vertical: widget.paddingSize),
                    child: Container(
                      color: Colors.white,
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        menuMaxHeight: widget.menuMaxHeight,
                        // widget.mediaFontSize * (_contentsAll.length + 6),
                        itemHeight: widget.itemHeightSize,
                        items: fontSize
                            .map((val) => DropdownMenuItem(
                                  child: SizedBox(
                                    child: Text(
                                      val.toString(),
                                      style: TextStyle(
                                          fontSize: widget.mediaFontSize),
                                    ),
                                  ),
                                  value: val,
                                ))
                            .toList(),
                        value: _selectedFontSize,
                        onChanged: (val) {
                          if (val != null) {
                            // null 여부 검사
                            _selectedFontSize = val;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            // words cnt check
            // SizedBox(
            //   child: Row(
            //     children: [
            //       Padding(
            //         padding:
            //             EdgeInsets.symmetric(horizontal: widget.paddingSize),
            //         child: Text(
            //           "WORDS",
            //           style: TextStyle(fontSize: widget.mediaFontSize),
            //         ),
            //       ),
            //       Padding(
            //         padding:
            //             EdgeInsets.symmetric(horizontal: widget.paddingSize),
            //         child: Container(
            //           color: Colors.white,
            //           child: DropdownButton(
            //             dropdownColor: Colors.white,
            //             menuMaxHeight: widget.menuMaxHeight,
            //             itemHeight: widget.itemHeightSize,
            //             items: words
            //                 .map((val) => DropdownMenuItem(
            //                       child: SizedBox(
            //                           child: Text(
            //                         val.toString() + " word",
            //                         style: TextStyle(
            //                             fontSize: widget.mediaFontSize),
            //                       )),
            //                       value: val,
            //                     ))
            //                 .toList(),
            //             value: _selectedWords,
            //             onChanged: (val) => setState(() {
            //               if (val != null) {
            //                 // null 여부 검사
            //                 setState(() {
            //                   _selectedWords = val;
            //                   // 워드 별 배속 변경
            //                   _durationSpeed = 1000 - (val * 100);
            //                 });
            //               }
            //             }),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // practice speed
            // SizedBox(
            //   child: Row(
            //     children: [
            //       // const Text("평균 250 이내로 연습"),
            //       Container(
            //         color: Colors.white,
            //         width:
            //             widget.screenWidth * 0.25, // widget.mediaFontSize * 5,
            //         child: TextField(
            //           style: TextStyle(fontSize: widget.mediaFontSize),
            //           decoration: InputDecoration(
            //             fillColor: Colors.white,
            //             contentPadding:
            //                 EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //             labelText: "워딩 숫자",
            //             hintText: "평균 250 이내로 연습",
            //             border: OutlineInputBorder(),
            //           ),
            //           keyboardType: TextInputType.number,
            //           inputFormatters: <TextInputFormatter>[
            //             FilteringTextInputFormatter.allow(
            //                 RegExp(r'^[1-9][0-9]{0,2}$|^[0-9]$')),
            //           ],
            //           onChanged: (value) => setState(() {
            //             int intVal = int.parse(value);
            //             if (intVal > 900) {
            //               _durationSpeed = 100;
            //             }
            //             _durationSpeed = 1000 - int.parse(value);
            //           }),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
        // load text files
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            direction: Axis.horizontal, // 나열 방향
            alignment: WrapAlignment.start, // 정렬 방식
            spacing: 4, // 좌우 간격
            runSpacing: 0.5, // 상하 간격
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.paddingSize),
                child: Text(
                  "FILE NAME",
                  style: TextStyle(fontSize: widget.mediaFontSize),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.paddingSize),
                child: SizedBox(
                  width: widget.mediaFontSize * 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      _fileName,
                      style: TextStyle(fontSize: widget.mediaFontSize),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.paddingSize),
                child: TextButton(
                  onPressed: () => _openFile(),
                  child: Text(
                    'FILE OPEN',
                    style: TextStyle(fontSize: widget.mediaFontSize),
                  ),
                ),
              ),
              IconButton(
                  iconSize: widget.mediaFontSize * 1.5,
                  padding: EdgeInsets.all(0.0),
                  onPressed: () => {_decrementWordCnt()},
                  icon: Icon(Icons.keyboard_double_arrow_left_rounded)),

              // file play arrow right
              IconButton(
                iconSize: widget.mediaFontSize * 1.5,
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  if (_contentsAll.length > wordCnt - 1 && wordCnt >= 0) {
                    _incrementWordCnt();
                  }
                },
                icon: Icon(Icons.keyboard_double_arrow_right_rounded),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _resetWordCnt();
                  });
                },
                child: Text(
                  'RESET',
                  style: TextStyle(fontSize: widget.mediaFontSize),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _findAll();
                  });
                },
                child: Text(
                  '본문보기',
                  style: TextStyle(fontSize: widget.mediaFontSize),
                ),
              ),
            ],
          ),
        ),

        // file play button - auto start
        // IconButton(
        //     iconSize: widget.mediaFontSize * 1.2,
        //     onPressed: () => {_autoPlay()},
        //     icon: Icon(Icons.play_arrow)),
        // Text(_showContent)
        // Flexible(
        // child:
        Padding(
          padding: EdgeInsets.all(widget.paddingSize),
          child: Container(
            height: widget.screenHeight * 0.65,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Center(
                child: SingleChildScrollView(
                    child: Text(
              _showContent,
              style: TextStyle(fontSize: _selectedFontSize / 10),
              textAlign: TextAlign.center,
            ))),
          ),
        )
        // )
      ],
    );
  }
}
