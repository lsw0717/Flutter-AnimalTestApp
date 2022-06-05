import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import './result.dart' as result;
import 'package:provider/provider.dart';
import './provider.dart' as provider;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => provider.Store1()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Tensorflow app',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: AnimalApp(),
      ),
    );
  }
}

class AnimalApp extends StatefulWidget {
  const AnimalApp({Key? key}) : super(key: key);

  @override
  _AnimalAppState createState() => _AnimalAppState();
}

class _AnimalAppState extends State<AnimalApp> {
  final picker = ImagePicker();

  // 앱이 실행될 때 loadModel() 함수를 호출
  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  // 모델과 label.txt를 가져온다.
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    ).then((value) {
      setState(() {
        //_loading = false;
      });
    });
  }

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    context.read<provider.Store1>().changeImage(File(image!.path));

    await classifyImage(File(image.path)); // 가져온 이미지를 분류 하기 위해 await을 사용
  }

  // 이미지 분류
  Future classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        // defaults to 117.0
        imageStd: 255.0,
        // defaults to 1.0
        numResults: 2,
        // defaults to 5
        threshold: 0.2,
        // defaults to 0.1
        asynch: true // defaults to true
        );
    context.read<provider.Store1>().changeOutputs(output);
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        color: const Color(0xffd0cece),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: context.watch<provider.Store1>().image == null
                ? Text('No image selected.')
                : Image.file(
                    File(context.watch<provider.Store1>().image!.path))));
  }

  //dialog 삭제
  //결과 페이지로 이동하는 함수
  goToResultPage() {
    context.read<provider.Store1>().outputs != null
        ? Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => result.ResultPage()),
          )
        : showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "데이터가 없거나 잘못된 이미지 입니다.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Center(
                    child: ElevatedButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        backgroundColor: const Color(0xfff4f3f9),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '동물상 테스트',
              style: TextStyle(fontSize: 25, color: const Color(0xff1ea271)),
            ),
            SizedBox(height: 25.0),
            showImage(),
            SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // 카메라 촬영 버튼
                FloatingActionButton(
                  child: Icon(Icons.add_a_photo),
                  tooltip: 'pick Iamge',
                  onPressed: () async {
                    await getImage(ImageSource.camera);
                    //recycleDialog();
                    goToResultPage();
                  },
                ),

                // 갤러리에서 이미지를 가져오는 버튼
                FloatingActionButton(
                  child: Icon(Icons.wallpaper),
                  tooltip: 'pick Iamge',
                  onPressed: () async {
                    await getImage(ImageSource.gallery);
                    //recycleDialog();
                    goToResultPage();
                  },
                ),
              ],
            )
          ],
        ));
  }

  // 앱이 종료될 때
  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
