// To parse this JSON data, do
//
//     final serverListModel = serverListModelFromJson(jsonString);

import 'dart:convert';

ServerListModel serverListModelFromJson(String str) => ServerListModel.fromJson(json.decode(str));

String serverListModelToJson(ServerListModel data) => json.encode(data.toJson());

class ServerListModel {
  ServerListModel({
    this.id,
    this.status,
    this.availability,
    this.updateTime,
    this.name,
    this.loadPercent,
    this.loadAverage,
    this.ramTotal,
    this.ramUsage,
    this.diskTotal,
    this.diskUsage,
    this.ipv4,
    this.ipv6,
    this.currentRx,
    this.currentTx,
  });

  int id;
  String status;
  String availability;
  int updateTime;
  String name;
  int loadPercent;
  String loadAverage;
  int ramTotal;
  int ramUsage;
  int diskTotal;
  int diskUsage;
  String ipv4;
  String ipv6;
  int currentRx;
  int currentTx;

  factory ServerListModel.fromJson(Map<String, dynamic> json) => ServerListModel(
    id: json["id"],
    status: json["status"],
    availability: json["availability"],
    updateTime: json["update_time"],
    name: json["name"],
    loadPercent: json["load_percent"],
    loadAverage: json["load_average"],
    ramTotal: json["ram_total"],
    ramUsage: json["ram_usage"],
    diskTotal: json["disk_total"],
    diskUsage: json["disk_usage"],
    ipv4: json["ipv4"],
    ipv6: json["ipv6"],
    currentRx: json["current_rx"],
    currentTx: json["current_tx"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "availability": availability,
    "update_time": updateTime,
    "name": name,
    "load_percent": loadPercent,
    "load_average": loadAverage,
    "ram_total": ramTotal,
    "ram_usage": ramUsage,
    "disk_total": diskTotal,
    "disk_usage": diskUsage,
    "ipv4": ipv4,
    "ipv6": ipv6,
    "current_rx": currentRx,
    "current_tx": currentTx,
  };
}
