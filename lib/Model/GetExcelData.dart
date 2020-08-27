import 'dart:convert';

List<GetExcelData> getExcelDataFromJson(String str) => List<GetExcelData>.from(json.decode(str).map((x) => GetExcelData.fromJson(x)));

String getExcelDataToJson(List<GetExcelData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetExcelData {
  String s0;
  String firstName;
  String lastName;
  String gender;
  String country;
  String age;
  String date;
  String id;

  GetExcelData(
      {this.s0,
        this.firstName,
        this.lastName,
        this.gender,
        this.country,
        this.age,
        this.date,
        this.id});

  GetExcelData.fromJson(Map<String, dynamic> json) {
    s0 = json['0'];
    firstName = json['First Name'];
    lastName = json['Last Name'];
    gender = json['Gender'];
    country = json['Country'];
    age = json['Age'];
    date = json['Date'];
    id = json['Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.s0;
    data['First Name'] = this.firstName;
    data['Last Name'] = this.lastName;
    data['Gender'] = this.gender;
    data['Country'] = this.country;
    data['Age'] = this.age;
    data['Date'] = this.date;
    data['Id'] = this.id;
    return data;
  }
}