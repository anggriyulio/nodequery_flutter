import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nodequery_client/models/account_model.dart';
import 'package:nodequery_client/models/server_list_model.dart';
import 'package:nodequery_client/models/server_load_model.dart';
import 'package:nodequery_client/models/server_model.dart';

class NodeQueryEndpoint {
  final String baseUrl = 'https://nodequery.com/api/';
  var client = http.Client();

  Future<AccountModel> account() async {
    try {
      var response =
          await client.get(baseUrl + 'account?api_key=' + await getToken());
      if (response.statusCode == 200) {
        var resString = jsonDecode(response.body);
        AccountModel acc = AccountModel.fromJson(resString['data']);
        return acc;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<ServerListModel>> servers() async {
    try {
      var response =
          await client.get(baseUrl + 'servers?api_key=' + await getToken());

      List<ServerListModel> listServers = [];
      var resString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (Map i in resString['data'][0]) {
          listServers.add(ServerListModel.fromJson(i));
        }
        return listServers;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ServerModel> server(String serverId) async {
    try {
      var response = await client.get(
          baseUrl + 'servers/' + serverId + '?api_key=' + await getToken());

      ServerModel server;

      var resString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        server = ServerModel.fromJson(resString['data'][0]);
        return server;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<ServerLoadModel>> loads(String range, String serverId) async {
    try {
      var response = await client.get(baseUrl +
          'loads/' +
          range +
          '/' +
          serverId +
          '?api_key=' +
          await getToken());

      List<ServerLoadModel> serverLoads = [];
      var resString = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (Map i in resString['data'][0]) {
          serverLoads.add(ServerLoadModel.fromJson(i));
        }
        return serverLoads;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String> getToken() async {
    try {
      final storage = new FlutterSecureStorage();
      String token = await storage.read(key: 'apiKey');
      return token;
    } catch (e) {
      return null;
    }
  }

  Future<String> setToken(String token) async {
    try {
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'apiKey', value: token);
      return token;
    } catch (e) {
      return null;
    }
  }
}
