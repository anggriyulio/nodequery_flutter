import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getflutter/getflutter.dart';
import 'package:nodequery_client/endpoints/nodequery_endpoint.dart';
import 'package:nodequery_client/models/account_model.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _isLoading = true;
  bool _isValid = false;
  bool _isValidating = false;
  String _apiKey;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  AccountModel acc;

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
        _isValid = true;
        acc = res;
      });
      final snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text('Hurray! Your API Key is working.'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('API Key is not valid!'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
    setState(() => _isValidating = false);
  }

  _getToken() async {
    var token = await NodeQueryEndpoint().getToken();
    setState(() => {
          _apiKey = token,
          _isLoading = false,
        });
  }

  @override
  void initState() {
    _getToken();
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
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 35.0, right: 35.0, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Hi with no excuses and travel with no regrets oscar wilde',
                          style: TextStyle(
                              fontSize: 16.0,
                              height: 1.5,
                              fontFamily: 'OpenSans'),
                        ),
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
                      autovalidate: true,
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Get an API key for your account'),
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

                ],
              ),
            ),
    );
  }
}
