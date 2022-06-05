import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider.dart' as provider;

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  var intro = 8; // 동물별 index를 관리하는 state

  //동물 별 이름 텍스트
  animal(String label) {
    if (label == '0 DOG') {
      setState(() {
        intro = 0;
      });
      return '강아지';
    }
    if (label == '1 CAT') {
      setState(() {
        intro = 1;
      });
      return '고양이';
    }
    if (label == '2 BEAR') {
      setState(() {
        intro = 2;
      });
      return '곰';
    }
    if (label == '3 DINO') {
      setState(() {
        intro = 3;
      });
      return '공룡';
    }
    if (label == '4 RABBIT') {
      setState(() {
        intro = 4;
      });
      return '토끼';
    } else {
      return '에러임 수고링';
    }
  }

  //동물 별 설명 함수
  animalIntro() {
    if (intro == 0) {
      return Column(
        children: [
          Text('당신은 귀여운 강아지와 같은 얼굴의 소유자 입니다.'),
          Text('주변 사람들이 당신을 보며 귀엽다고 생각할 것입니다.'),
          Text('강이지 같이 애교많은 그대는 최고 !'),
        ],
      );
    }

    if (intro == 1) {
      return Column(
        children: [
          Text('당신은 차가운 고양이와 같은 얼굴의 소유자 입니다.'),
          Text('주변 사람들이 당신을 보며 차갑다고 생각할 것입니다.'),
          Text('고양이 같이 차가운 그대는 최고 !'),
        ],
      );
    }

    if (intro == 2) {
      return Column(
        children: [
          Text('당신은 든든한 곰과 같은 얼굴의 소유자 입니다.'),
          Text('주변 사람들이 당신을 보며 든든하다고 생각할 것입니다.'),
          Text('곰 같이 든든한 그대는 최고 !'),
        ],
      );
    }

    if (intro == 3) {
      return Column(
        children: [
          Text('당신은 무서운 공룡과 같은 얼굴의 소유자 입니다.'),
          Text('주변 사람들이 당신을 보며 무섭다고 생각할 것입니다.'),
          Text('공룡 같이 무서운 그대는 최고 !'),
        ],
      );
    }

    if (intro == 4) {
      return Column(
        children: [
          Text('당신은 여리여리한 토끼와 같은 얼굴의 소유자 입니다.'),
          Text('주변 사람들이 당신을 보며 지켜주고 싶다고 생각할 것입니다.'),
          Text('토끼 같이 여리여히한 그대는 최고 !'),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 40),
              child: Text(
                '당신의 닮은 꼴 동물은 .. ',
                style: TextStyle(fontSize: 25, color: const Color(0xff1ea271)),
              ),
            ),
            Text(
              animal(context
                  .watch<provider.Store1>()
                  .outputs[0]['label']
                  .toString()
                  .toUpperCase()),
              style: TextStyle(
                color: Colors.black,
                fontSize: 40.0,
                background: Paint()..color = Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 60),
              child: Container(
                  color: const Color(0xffd0cece),
                  constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
                  width: double.infinity,
                  child: Center(
                      child: context.watch<provider.Store1>().image == null
                          ? Text('No image selected.')
                          : Image.file(File(
                              context.watch<provider.Store1>().image!.path)))),
            ),
            animalIntro(),
          ],
        ),
      )),
    );
  }
}
