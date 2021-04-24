import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:nodequery_client/helpers/widget.dart';
import 'package:nodequery_client/models/server_model.dart';

class ServerProcess extends StatefulWidget {
  final List<ProcessesArray> prc;

  ServerProcess({
    Key key,
    @required this.prc,
  }) : super(key: key);

  @override
  _ServerProcessState createState() => _ServerProcessState();
}

class _ServerProcessState extends State<ServerProcess> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Processes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: widget.prc.map((s) => listProcess(s)).toList(),
          )
        ],
      ),
    );
  }

  Widget listProcess(ProcessesArray p) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GFAvatar(
            size: 24,
            shape: GFAvatarShape.standard,
            backgroundColor: Colors.black,
            child: Text(
              p.count.toString(),
              style: TextStyle(fontSize: 13),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  p.command,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 11.0),
                  children: [
                    WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.only(right: 3),
                      child: Icon(
                        Icons.verified_user,
                        size: 12,
                      ),
                    )),
                    TextSpan(
                      text: p.user,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 3),
                      child: Icon(
                        Icons.memory,
                        size: 12,
                      ),
                    )),
                    TextSpan(
                      text: formatBytes(p.memory, 2, true),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 3),
                    )),
                    TextSpan(
                      text: 'CPU ' + p.cpu.round().toString() + '%',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
