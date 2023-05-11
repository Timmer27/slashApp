import 'dart:async';

import 'package:flutter/material.dart';

class FontCounterModel with ChangeNotifier {
  int _selectedFontSize = 500;
  int _durationSeconds = 1000;
  Timer? timer;
  int wordCnt = 0;

  // orgin
  // List<String> _contentsAll = [''];
  // String _contents = '';

  // to be deleted - 나중에 전역변수로 ㄱㄱ
  List<String> _contentsAll = [
    "안녕하세요.",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    "이건 테스트입니다.",
    "잘 될까요?.",
    "제발..."
  ];
  String _contents = '안녕하세요ㅁㄴㅇㄻㄴㅇㄻㄴㅇㄹ이건 테스트입니다 잘될까요?> ㅈㅂ...';
  String _showContent = '';

  int get selectedFontSize => _selectedFontSize;
  int get durationSeconds => _durationSeconds;
  List<String> get contentsAll => _contentsAll;
  String get showContent => _showContent;
  String get contents => _contents;

  void setFont(int newFontSize) {
    _selectedFontSize = newFontSize;
    notifyListeners();
  }

  void setDuration(int newDuration) {
    _durationSeconds = newDuration;
    notifyListeners();
  }

  void setContentsAll(List<String> newContentsAll) {
    _contentsAll = newContentsAll;
    notifyListeners();
  }

  void setShowContent(String newshowContent) {
    _showContent = newshowContent;
    notifyListeners();
  }

  void setContents(String newContents) {
    _contents = _contents;
    notifyListeners();
  }

  String incrementWordCnt(List<String> contentsAll, String showContent) {
    timer?.cancel();
    if (contentsAll.length - 1 > wordCnt) {
      if (wordCnt == 0) {
        _showContent = contentsAll[0];
        wordCnt++;
      } else {
        wordCnt++;
        _showContent = contentsAll[wordCnt];
      }

      // print(_showContent);
      // print(wordCnt);
    }
    print(_showContent);
    return _showContent;
  }
}
