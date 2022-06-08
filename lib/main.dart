import 'package:add_autometic_fake_data_to_api/common/common_util.dart';
import 'package:add_autometic_fake_data_to_api/common/ui_util.dart';
import 'package:add_autometic_fake_data_to_api/network/api_repository.dart.dart';
import 'package:add_autometic_fake_data_to_api/response_demo_api.dart';
import 'package:dio/dio.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      /// set Easy Loading
      builder: EasyLoading.init(),

      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _running = false;

  final ApiRepository? _apiRepository = ApiRepository();

  final Faker faker = Faker.instance;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Generated Image Path : ${faker.image.loremPixel.image()}");
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(onPressed: (){}, child: const Text("end")),
        ElevatedButton(onPressed: (){
          if (!CommonUtil.instance.isRedundantClick(DateTime.now(), 3)) {
            CommonUtil.instance.internetCheck().then((internetCheckValue) async {
              if (internetCheckValue) {
                UIUtil.instance.showLoading();
                CommonUtil.instance.downloadFile().then((imagePathValue) async {
                  Map<String, dynamic>? data = await createInstrumentDynamicData(imagePath: imagePathValue);
                  _apiRepository?.postCreateInstrument(null, data,
                      onSuccess: (ResponseDemoAPI? response) async {
                        UIUtil.instance.stopLoading();
                        if (response != null) {
                          if (response.success) {
                            print("Server image address : ${response.data!.image}");
                          } else {
                            UIUtil.instance.onFailed(response.error.toString());
                          }
                        } else {
                          // print("Failed to Log In");
                          UIUtil.instance.onFailed('Failed to Sign Up');
                        }
                      },
                      onFailure: (String error) {
                        UIUtil.instance.stopLoading();
                        // print(error);
                        UIUtil.instance.onFailed(error.toString());
                      });
                });
              } else {
                // UIUtil.instance.stopLoading();
                // print("No Internet");
                UIUtil.instance.onNoInternet();
              }
            });
          }
        }, child: const Text("start")),
      ],
    );
  }

  /// Dynamic Data
  // Create Instrument Dynamic Data
  Future<Map<String, dynamic>?> createInstrumentDynamicData({String? imagePath}) async{
    print("phone storage image path : $imagePath");
    Map<String, dynamic>? data = {};
    data["item"] = faker.commerce.productName();
    data["quantity"] = faker.datatype.number(max: 50);
    data["image"] = await MultipartFile.fromFile(imagePath!, filename: "image.jpg"/*filename: imagePath.split('/').last*/);
    return data;
  }
}
