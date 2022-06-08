import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:path_provider/path_provider.dart';

class CommonUtil {

  static CommonUtil instance = CommonUtil();

  /// Internet Check
  Future<bool> internetCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }


  /// Handle Over-tapping
  DateTime? initialClickTime;

  bool isRedundantClick(DateTime currentTime, int redundantClickDuration) {
    if (initialClickTime == null) {
      initialClickTime = currentTime;
      return false;
    } else {
      if (currentTime
          .difference(initialClickTime!)
          .inSeconds < redundantClickDuration) { //set this difference time in seconds (ideally 3 sec)
        return true;
      }
    }
    initialClickTime = currentTime;
    return false;
  }

  // Future<File> _fileFromImageUrl() async {
  //   final response = await Dio().get('https://example.com/xyz.jpg');
  //
  //   final documentDirectory = await getApplicationDocumentsDirectory();
  //
  //   final file = File(join(documentDirectory.path, 'imagetest.png'));
  //
  //   file.writeAsBytesSync(response.bodyBytes);
  //
  //   return file;
  // }

  Future<String> downloadFile() async {
    var generatedImagePath = Faker.instance.image.loremPicsum.image(width: 640,height: 480);
    print("Generated Image Path : $generatedImagePath");
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    var imageDownloadPath = '${dir.path}/image.jpg';
    var imageSrc = "https://i.picsum.photos/id/0/5616/3744.jpg?hmac=3GAAioiQziMGEtLbfrdbcoenXoWAW-zlyEAMkfEdBzQ";
    // await dio.download(imageSrc, imageDownloadPath);
    await dio.download(imageSrc, imageDownloadPath,
        onReceiveProgress: (received, total) {
          var progress = (received / total) * 100;
          print('Rec: $received , Total: $total, $progress%');
          // setState(() {
          //   downloadProgress = received.toDouble() / total.toDouble();
          // });
        });
    // downloadFile function returns path where image has been downloaded
    return imageDownloadPath;
  }

}