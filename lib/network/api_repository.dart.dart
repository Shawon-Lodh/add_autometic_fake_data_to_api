import 'package:add_autometic_fake_data_to_api/response_demo_api.dart';
import 'api_client.dart';

const baseUrl = "https://gym-management97.herokuapp.com";
const folderUrl = "/api";
const createInstrumentPath = "/instruments/";

class ApiRepository {

  /// POST Call for Create Issue
  void postCreateInstrument(Map<String, dynamic>? params,  Map<String, dynamic>? body, {void Function(ResponseDemoAPI)? onSuccess,
    void Function(String)? onFailure}) async {
    try {
      final response = await ApiClient.upload(baseUrl + folderUrl + createInstrumentPath, params, body, true);
      var callResponse = ResponseDemoAPI.fromJson(response);
      if (callResponse != null) {
        onSuccess!(callResponse);
      } else {
        print(callResponse);
        onFailure!('Something went Wrong!');
      }
    } catch (e) {
      print(e.toString());
      onFailure!('Something went Wrong!');
    }
  }

}