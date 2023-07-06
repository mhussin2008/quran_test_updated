// To parse this JSON data, do
//
//     final qaryData = qaryDataFromJson(jsonString);

import 'dart:convert';

List<QaryData> qaryDataFromJson(String str) => List<QaryData>.from(json.decode(str).map((x) => QaryData.fromJson(x)));

String qaryDataToJson(List<QaryData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QaryData {
  final String qaryName;
  final int qaryAge;
  final double degree;
  final String testName;
  final int questions;
  QaryData(this.qaryName, this.qaryAge, this.degree, this.testName, this.questions);

  factory QaryData.fromJson(Map<String, dynamic> json) => QaryData(json['qaryName'],json['qaryAge'],json['degree'],json['testName'],json['questions']);
  factory QaryData.fromFields(String name,int age,double deg,String tname,int quest)=>QaryData(name, age,deg,tname,quest);

  Map<String, dynamic> toJson() => {
  };

  @override
  String toString(){return 'Qary Name is ${qaryName} , his age is ${qaryAge} \n question ${questions} ';}



 }

List<QaryData> QaryList=[];