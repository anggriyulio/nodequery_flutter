// To parse this JSON data, do
//
//     final serverLoadModel = serverLoadModelFromJson(jsonString);

import 'dart:convert';

ServerLoadModel serverLoadModelFromJson(String str) => ServerLoadModel.fromJson(json.decode(str));

String serverLoadModelToJson(ServerLoadModel data) => json.encode(data.toJson());

class ServerLoadModel {
  ServerLoadModel({
    this.time,
    this.pingEu,
    this.pingUs,
    this.pingAs,
    this.loadAvg,
    this.loadCpu,
    this.loadIo,
    this.loadDisk,
    this.loadRam,
    this.loadSwap,
    this.loadRx,
    this.loadTx,
  });

  int time;
  double pingEu;
  double pingUs;
  double pingAs;
  int loadAvg;
  int loadCpu;
  int loadIo;
  int loadDisk;
  int loadRam;
  int loadSwap;
  int loadRx;
  int loadTx;

  factory ServerLoadModel.fromJson(Map<String, dynamic> json) => ServerLoadModel(
    time: json["time"],
    pingEu: json["ping_eu"].toDouble(),
    pingUs: json["ping_us"].toDouble(),
    pingAs: json["ping_as"].toDouble(),
    loadAvg: json["load_avg"],
    loadCpu: json["load_cpu"],
    loadIo: json["load_io"],
    loadDisk: json["load_disk"],
    loadRam: json["load_ram"],
    loadSwap: json["load_swap"],
    loadRx: json["load_rx"],
    loadTx: json["load_tx"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "ping_eu": pingEu,
    "ping_us": pingUs,
    "ping_as": pingAs,
    "load_avg": loadAvg,
    "load_cpu": loadCpu,
    "load_io": loadIo,
    "load_disk": loadDisk,
    "load_ram": loadRam,
    "load_swap": loadSwap,
    "load_rx": loadRx,
    "load_tx": loadTx,
  };
}
