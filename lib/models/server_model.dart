// To parse this JSON data, do
//
//     final serverModel = serverModelFromJson(jsonString);

import 'dart:convert';

ServerModel serverModelFromJson(String str) => ServerModel.fromJson(json.decode(str));

String serverModelToJson(ServerModel data) => json.encode(data.toJson());

class ServerModel {
    ServerModel({
        this.id,
        this.status,
        this.availability,
        this.updateTime,
        this.name,
        this.agentVersion,
        this.systemUptime,
        this.dataUptime,
        this.sessions,
        this.processes,
        this.processesArray,
        this.osKernel,
        this.osName,
        this.osArch,
        this.cpuName,
        this.cpuCores,
        this.cpuFreq,
        this.loadPercent,
        this.loadAverage,
        this.ramTotal,
        this.ramUsage,
        this.swapTotal,
        this.swapUsage,
        this.diskTotal,
        this.diskUsage,
        this.diskArray,
        this.nic,
        this.ipv4,
        this.ipv6,
        this.currentRx,
        this.currentTx,
        this.totalRx,
        this.totalTx,
    });

    int id;
    String status;
    String availability;
    int updateTime;
    String name;
    String agentVersion;
    int systemUptime;
    int dataUptime;
    int sessions;
    int processes;
    List<ProcessesArray> processesArray;
    String osKernel;
    String osName;
    String osArch;
    String cpuName;
    int cpuCores;
    int cpuFreq;
    int loadPercent;
    String loadAverage;
    int ramTotal;
    int ramUsage;
    int swapTotal;
    int swapUsage;
    int diskTotal;
    int diskUsage;
    List<DiskArray> diskArray;
    String nic;
    String ipv4;
    String ipv6;
    int currentRx;
    int currentTx;
    int totalRx;
    int totalTx;

    factory ServerModel.fromJson(Map<String, dynamic> json) => ServerModel(
        id: json["id"],
        status: json["status"],
        availability: json["availability"],
        updateTime: json["update_time"],
        name: json["name"],
        agentVersion: json["agent_version"],
        systemUptime: json["system_uptime"],
        dataUptime: json["data_uptime"],
        sessions: json["sessions"],
        processes: json["processes"],
        processesArray: List<ProcessesArray>.from(json["processes_array"].map((x) => ProcessesArray.fromJson(x))),
        osKernel: json["os_kernel"],
        osName: json["os_name"],
        osArch: json["os_arch"],
        cpuName: json["cpu_name"],
        cpuCores: json["cpu_cores"],
        cpuFreq: json["cpu_freq"],
        loadPercent: json["load_percent"],
        loadAverage: json["load_average"],
        ramTotal: json["ram_total"],
        ramUsage: json["ram_usage"],
        swapTotal: json["swap_total"],
        swapUsage: json["swap_usage"],
        diskTotal: json["disk_total"],
        diskUsage: json["disk_usage"],
        diskArray: List<DiskArray>.from(json["disk_array"].map((x) => DiskArray.fromJson(x))),
        nic: json["nic"],
        ipv4: json["ipv4"],
        ipv6: json["ipv6"],
        currentRx: json["current_rx"],
        currentTx: json["current_tx"],
        totalRx: json["total_rx"],
        totalTx: json["total_tx"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "availability": availability,
        "update_time": updateTime,
        "name": name,
        "agent_version": agentVersion,
        "system_uptime": systemUptime,
        "data_uptime": dataUptime,
        "sessions": sessions,
        "processes": processes,
        "processes_array": List<dynamic>.from(processesArray.map((x) => x.toJson())),
        "os_kernel": osKernel,
        "os_name": osName,
        "os_arch": osArch,
        "cpu_name": cpuName,
        "cpu_cores": cpuCores,
        "cpu_freq": cpuFreq,
        "load_percent": loadPercent,
        "load_average": loadAverage,
        "ram_total": ramTotal,
        "ram_usage": ramUsage,
        "swap_total": swapTotal,
        "swap_usage": swapUsage,
        "disk_total": diskTotal,
        "disk_usage": diskUsage,
        "disk_array": List<dynamic>.from(diskArray.map((x) => x.toJson())),
        "nic": nic,
        "ipv4": ipv4,
        "ipv6": ipv6,
        "current_rx": currentRx,
        "current_tx": currentTx,
        "total_rx": totalRx,
        "total_tx": totalTx,
    };
}

class DiskArray {
    DiskArray({
        this.label,
        this.total,
        this.usage,
    });

    String label;
    String total;
    String usage;

    factory DiskArray.fromJson(Map<String, dynamic> json) => DiskArray(
        label: json["label"],
        total: json["total"],
        usage: json["usage"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "total": total,
        "usage": usage,
    };
}

class ProcessesArray {
    ProcessesArray({
        this.command,
        this.count,
        this.cpu,
        this.memory,
        this.user,
    });

    String command;
    int count;
    double cpu;
    int memory;
    String user;

    factory ProcessesArray.fromJson(Map<String, dynamic> json) => ProcessesArray(
        command: json["command"],
        count: json["count"],
        cpu: json["cpu"].toDouble(),
        memory: json["memory"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "command": command,
        "count": count,
        "cpu": cpu,
        "memory": memory,
        "user": user,
    };
}
