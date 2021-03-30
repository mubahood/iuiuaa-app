import 'package:json_annotation/json_annotation.dart';

part 'responseModel.g.dart';

@JsonSerializable()
class ResponseModel {
  int code = 0;
  String message = "Failed to decode.";
  String data = "{}";

  ResponseModel(this.code, this.message, this.data);


  factory ResponseModel.fromJson(Map<String, dynamic> json) => _$ResponseModelFromJson(json);



}
