import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:slash/mainPage/ref/FontFileCounterModel.dart';

class FileControllPanner extends StatefulWidget {
  final double paddingSize;
  final double mediaFontSize;

  const FileControllPanner({
    super.key,
    required this.paddingSize,
    required this.mediaFontSize,
  });

  @override
  State<FileControllPanner> createState() => _FileControllPanner();
}

class _FileControllPanner extends State<FileControllPanner> {
  String _fileName = '';
  int wordCnt = 0;
  Timer? timer;

  void _autoPlay(
      int durationSeconds, List<String> contentsAll, String showContent) {
    // int count = wordCnt;
    timer?.cancel();
    int maxVal = contentsAll.length;
    timer = Timer.periodic(Duration(milliseconds: durationSeconds), (timer) {
      if (wordCnt + 1 < maxVal) {
        setState(() {
          if (wordCnt == 0) {
            Provider.of<FontCounterModel>(context)
                .setShowContent(contentsAll[wordCnt]);
            wordCnt++;
          } else {
            wordCnt++;
            Provider.of<FontCounterModel>(context)
                .setShowContent(contentsAll[wordCnt]);
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _incrementWordCnt(List<String> contentsAll, String showContent) {
    timer?.cancel();
    if (contentsAll.length - 1 > wordCnt) {
      setState(() {
        if (wordCnt == 0) {
          Provider.of<FontCounterModel>(context).setShowContent(contentsAll[0]);
          wordCnt++;
        } else {
          wordCnt++;
          Provider.of<FontCounterModel>(context)
              .setShowContent(contentsAll[wordCnt]);
        }
      });
    }
  }

  void _decrementWordCnt(List<String> contentsAll, String showContent) {
    timer?.cancel();
    if (wordCnt > 0) {
      setState(() {
        wordCnt--;
        Provider.of<FontCounterModel>(context)
            .setShowContent(contentsAll[wordCnt]);
      });
    }
  }

  void _resetWordCnt(List<String> contentsAll, String showContent) {
    timer?.cancel();
    setState(() {
      wordCnt = 0;
      Provider.of<FontCounterModel>(context)
          .setShowContent(contentsAll[wordCnt]);
    });
  }

  void _findAll(String contents, String showContent) {
    timer?.cancel();
    setState(() {
      wordCnt = 0;
      Provider.of<FontCounterModel>(context).setShowContent(contents);
    });
  }

  void _openFile(BuildContext contexts, List<String> contentsAll,
      String showContent, String contents) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['txt']);
    if (result != null) {
      File file = File(result.files.single.path!);
      final filename = file.path.split('/').last;
      final encoding = Encoding.getByName('UTF-8');

      if (encoding != null) {
        String contents = await file.readAsString(encoding: encoding);
        Provider.of<FontCounterModel>(context)
            .setContentsAll(contents.split('/'));
        Provider.of<FontCounterModel>(context).setContents(contents);
        try {
          Provider.of<FontCounterModel>(context).setShowContent(contentsAll[0]);
        } catch (e) {
          Provider.of<FontCounterModel>(context).setShowContent('');
        }
        setState(() {
          _fileName = filename;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int durationSeconds =
        Provider.of<FontCounterModel>(context).durationSeconds;

    final List<String> contentsAll =
        Provider.of<FontCounterModel>(context).contentsAll;
    final String showContent =
        Provider.of<FontCounterModel>(context).showContent;
    final String contents = Provider.of<FontCounterModel>(context).contents;

    final int selectedFontSize =
        Provider.of<FontCounterModel>(context).selectedFontSize;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              // load text files
              SizedBox(
                child: Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: widget.paddingSize),
                      child: Text(
                        "FILE NAME",
                        style: TextStyle(fontSize: widget.mediaFontSize),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: widget.paddingSize),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: widget.paddingSize),
                      child: TextButton(
                        onPressed: () => _openFile(
                            context, contentsAll, showContent, contents),
                        child: Text(
                          'FILE OPEN',
                          style: TextStyle(fontSize: widget.mediaFontSize),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // file play button - auto start
              IconButton(
                  iconSize: widget.mediaFontSize * 1.2,
                  onPressed: () =>
                      {_autoPlay(durationSeconds, contentsAll, showContent)},
                  icon: Icon(Icons.play_arrow)),

              // file play arrow left
              IconButton(
                  iconSize: widget.mediaFontSize * 1.2,
                  onPressed: () =>
                      {_decrementWordCnt(contentsAll, showContent)},
                  icon: Icon(Icons.keyboard_double_arrow_left_rounded)),

              // file play arrow right
              IconButton(
                iconSize: widget.mediaFontSize * 1.2,
                onPressed: () {
                  if (contentsAll.length > wordCnt - 1 && wordCnt >= 0) {
                    String _showContent =
                        Provider.of<FontCounterModel>(context, listen: false)
                            .incrementWordCnt(contentsAll, showContent);
                    // _incrementWordCnt(contentsAll, showContent);
                    Provider.of<FontCounterModel>(context)
                        .setShowContent(_showContent);
                  }
                  setState(() {}); // 여기에 setState 추가
                },
                icon: Icon(Icons.keyboard_double_arrow_right_rounded),
              ),

              // reset button
              SizedBox(
                child: Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: widget.paddingSize),
                      child: TextButton(
                        onPressed: () {
                          _resetWordCnt(contentsAll, contents);
                          setState(() {});
                        },
                        child: Text(
                          'RESET',
                          style: TextStyle(fontSize: widget.mediaFontSize),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // check raw text file
              SizedBox(
                child: Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: widget.paddingSize),
                      child: TextButton(
                        onPressed: () => {_findAll(contents, showContent)},
                        child: Text(
                          '본문보기',
                          style: TextStyle(fontSize: widget.mediaFontSize),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Expanded(
          //     child: Container(
          //   decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          //   child: Center(child: SingleChildScrollView(
          //     child: Consumer<FontCounterModel>(
          //       builder: (context, myModel, child) {
          //         return Text(
          //           Provider.of<FontCounterModel>(context).showContent,
          //           style: TextStyle(fontSize: selectedFontSize / 10),
          //           textAlign: TextAlign.center,
          //         );
          //       },
          //     ),
          //   )),
          // ))
        ],
      ),
    );
  }
}
