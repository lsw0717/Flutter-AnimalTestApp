import 'dart:io';
import 'package:flutter/material.dart';

class Store1 extends ChangeNotifier {
  late List outputs; //동물 index state
  File? image; //이미지 state

  //state outputs 값을 바꾸기 위한 함수
  changeOutputs(var output) {
    outputs = output;
    notifyListeners();
  }

  //state image 값을 바꾸기 위한 함수
  changeImage(var file) {
    image = file;
    notifyListeners();
  }
}
