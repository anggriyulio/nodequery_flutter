import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getwidget/getwidget.dart';
import 'package:nodequery_client/endpoints/github_endpoint.dart';
import 'package:nodequery_client/endpoints/nodequery_endpoint.dart';
import 'package:nodequery_client/models/account_model.dart';
import 'package:nodequery_client/models/contributor_model.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _isLoading = true;
  bool _isValidating = false;
  bool _isLoadContributors = true;
  String _apiKey;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  AccountModel acc;
  List<ContributorModel> contributors;

  void _validateKey(String token) async {
    setState(() => _isValidating = true);
    NodeQueryEndpoint()
        .setToken(token)
        .then((t) => t is String ? _checkAccount() : null);
  }

  _checkAccount() async {
    var res = await NodeQueryEndpoint().account();
    if (res != null) {
      setState(() {
        _isLoading = false;
        acc = res;
      });
      final snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text('Hurray! Your API Key is working.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('API Key is not valid!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() => _isValidating = false);
  }

  _getToken() async {
    var token = await NodeQueryEndpoint().getToken();
    setState(() {
      _apiKey = token;
      _isLoading = false;
    });
  }

  _getContributors() async {
    var res = await GithubEndpoint().contributors();
    if (res != null) {
      setState(() {
        contributors = res;
        _isLoadContributors = false;
      });
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    showAboutDialog(
      context: context,
      applicationVersion: 'v' + packageInfo.version,
    );
  }

  @override
  void initState() {
    _getToken();
    _getContributors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: Container(
              child: CircularProgressIndicator(),
            ))
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 35.0, right: 35.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Application Settings',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.info),
                            onPressed: () {
                              showPackageInfo();
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(5),
                      child: FormBuilder(
                        key: _formKey,
                        initialValue: {
                          'apiKey': _apiKey,
                        },
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: FormBuilderTextField(
                                maxLines: 1,
                                obscureText: true,
                                attribute: "apiKey",
                                decoration: InputDecoration(
                                    labelText: "NodeQuery API Key"),
                                validators: [
                                  FormBuilderValidators.required(),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                child: Text('Get an API key for your account'),
                                onTap: () => {
                                  _launchURL(
                                      'https://nodequery.com/help/developer-api'),
                                },
                              ),
                            ),
                            _isValidating
                                ? Center(child: CircularProgressIndicator())
                                : GFButton(
                                    onPressed: () {
                                      if (_formKey.currentState
                                          .saveAndValidate()) {
                                        _validateKey(_formKey
                                            .currentState.value['apiKey']);
                                      }
                                    },
                                    child: Text(
                                      'Validate Key',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    fullWidthButton: true,
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                    color: Colors.black,
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, bottom: 10, right: 20, left: 20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Project Repository',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () => {
                              _launchURL(
                                  'https://github.com/anggriyulio/nodequery_flutter')
                            },
                            child: Image.asset(
                              'assets/github_logo.png',
                              width: 120,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                      width: double.infinity,
                      child: Text(
                        'Github Contributors',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _isLoadContributors
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : GridView.count(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 4,
                            children: contributors
                                .map((c) => Container(
                                      child: Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () => {
                                              _launchURL(c.htmlUrl),
                                            },
                                            child: GFAvatar(
                                              size: GFSize.SMALL,
                                              shape: GFAvatarShape.standard,
                                              backgroundImage:
                                                  NetworkImage(c.avatarUrl),
                                            ),
                                          ),
                                          Text(
                                            c.login,
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ))
                                .toList()),
                  ],
                ),
              ),
            ),
    );
  }
}
