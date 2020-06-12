import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nodequery_client/models/contributor_model.dart';

class GithubEndpoint {
  var client = http.Client();

  Future<List<ContributorModel>> contributors() async {
    try {
      var response = await client.get(
          'https://api.github.com/repos/anggriyulio/nodequery_flutter/contributors');

      List<ContributorModel> contributors = [];
      var resString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (Map i in resString) {
          contributors.add(ContributorModel.fromJson(i));
        }

        return contributors;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
