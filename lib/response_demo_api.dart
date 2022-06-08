class ResponseDemoAPI {
  ResponseDemoAPI({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final Data? data;
  late final String? error;

  ResponseDemoAPI.fromJson(Map<String, dynamic> json){
    success = json['success'];
    if(json['data'] != null) data = Data.fromJson(json['data']);
    if(json['error'] != null) error = json['error'];
  }
}

class Data {
  Data({
    required this.id,
    required this.item,
    required this.image,
    required this.quantity,
  });
  late final int id;
  late final String item;
  late final String image;
  late final int quantity;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    item = json['item'];
    image = json['image'];
    quantity = json['quantity'];
  }
}