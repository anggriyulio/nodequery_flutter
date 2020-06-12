// To parse this JSON data, do
//
//     final serverLoadModel = serverLoadModelFromJson(jsonString);

import 'dart:convert';

Map<String, double> serverLoadModelFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, double>(k, v.toDouble()));

String serverLoadModelToJson(Map<String, double> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)));
