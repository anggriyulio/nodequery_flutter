import 'package:flutter/material.dart';
import 'package:nodequery_client/endpoints/nodequery_endpoint.dart';
import 'package:nodequery_client/helpers/widget.dart';
import 'package:nodequery_client/models/account_model.dart';
import 'package:nodequery_client/models/server_list_model.dart';
import 'package:nodequery_client/screens/detail.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = true;

  AccountModel acc;
  List<ServerListModel> listServers = [];
  List<ServerListModel> searchlistServers = [];

  _checkAccount() async {
    var res = await NodeQueryEndpoint().account();
    if (res != null) {
      setState(() {
        acc = res;
      });
    } else {
      final snackBar = SnackBar(
        duration: Duration(seconds: 8),
        backgroundColor: Colors.red,
        content: Text('API Key is not valid, go to setting page!'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
    _getServers();
  }

  _getServers() async {
    var res = await NodeQueryEndpoint().servers();
    if (res != null) {
      res.sort((a, b) => b.updateTime.compareTo(a.updateTime));
      setState(() {
        listServers = res;
        _isLoading = !_isLoading;
      });
    }
  }

  void _searchServer(String q) {
    searchlistServers.clear();
    listServers.forEach((element) {
      if (element.name.toLowerCase().contains(q.toLowerCase())) {
        setState(() {
          searchlistServers.add(element);
        });
      }
    });
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = !_isLoading);
    _checkAccount();
  }

  @override
  void initState() {
    _checkAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
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
                          'NodeQuery',
                          style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Linux Servers Monitoring',
                      style: TextStyle(
                          fontSize: 16.0, height: 1.5, fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
              ),
              _isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ))
                  : Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(
                                    Icons.account_circle,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    acc.name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Account Limit: ${listServers.length} of ${acc.serverLimit} Servers',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            color: Theme.of(context)
                                                .primaryColorLight),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      hintText: 'Server Name'),
                                  maxLines: 1,
                                  onChanged: (val) => _searchServer(val),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.filter_list),
                                onPressed: () => {},
                              )
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: searchlistServers.isEmpty
                              ? listServers
                                  .map((s) => GestureDetector(
                                        onTap: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ServerDetail(
                                                      srv: s,
                                                    )),
                                          ),
                                        },
                                        child: serverList(s),
                                      ))
                                  .toList()
                              : searchlistServers
                                  .map((s) => GestureDetector(
                                        onTap: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ServerDetail(
                                                      srv: s,
                                                    )),
                                          ),
                                        },
                                        child: serverList(s),
                                      ))
                                  .toList(),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
