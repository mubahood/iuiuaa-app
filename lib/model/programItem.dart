import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'programItem.g.dart';

@JsonSerializable()
class ProgramItem {
  String award = "";
  String title = "";
  String year = "";
  String campus = "";

  ProgramItem() {
    this.award = "";
    this.title = "";
    this.year = "";
    this.campus = "";
  }

  Map<String, dynamic> toJson() => _$ProgramItemToJson(this);
  factory ProgramItem.fromJson(Map<String, dynamic> json) => _$ProgramItemFromJson(json);

  static List<ProgramItem> fromJsonList(String programsJson) {
    List<ProgramItem> programs = [];
    if(programsJson == null){
      return programs;
    }
    if(programsJson.isEmpty){
      return programs;
    }
    List<dynamic> m = jsonDecode(programsJson);

    m.forEach((element) {
      ProgramItem p;
      try{
        p = ProgramItem.fromJson(element);
      }catch(e){
        print("Failed because "+e.toString());
      }

      if(p != null){
        if(p.title != null && p.award != null  ){
          programs.add(p);
        }
      }else{
        print("Null item");
      }
    });
    return programs;
  }


}
