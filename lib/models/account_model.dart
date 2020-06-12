// To parse this JSON data, do
//
//     final accountModel = accountModelFromJson(jsonString);

import 'dart:convert';

AccountModel accountModelFromJson(String str) => AccountModel.fromJson(json.decode(str));

String accountModelToJson(AccountModel data) => json.encode(data.toJson());

class AccountModel {
    AccountModel({
        this.name,
        this.timezone,
        this.serverLimit,
        this.api,
    });

    String name;
    int timezone;
    int serverLimit;
    Api api;

    factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        name: json["name"],
        timezone: json["timezone"],
        serverLimit: json["server_limit"],
        api: Api.fromJson(json["api"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "timezone": timezone,
        "server_limit": serverLimit,
        "api": api.toJson(),
    };
}

class Api {
    Api({
        this.requests,
        this.rateLimit,
    });

    int requests;
    int rateLimit;

    factory Api.fromJson(Map<String, dynamic> json) => Api(
        requests: json["requests"],
        rateLimit: json["rate_limit"],
    );

    Map<String, dynamic> toJson() => {
        "requests": requests,
        "rate_limit": rateLimit,
    };
}
