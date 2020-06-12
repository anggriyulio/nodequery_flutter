import 'package:flutter/material.dart';
import 'package:nodequery_client/helpers/widget.dart';
import 'package:nodequery_client/models/server_model.dart';

class ServerInfo extends StatefulWidget {
  final ServerModel server;

  ServerInfo({
    Key key,
    @required this.server,
  }) : super(key: key);

  @override
  _ServerInfoState createState() => _ServerInfoState();
}

class _ServerInfoState extends State<ServerInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: <Widget>[
          dynamicList('Agent Version', widget.server.agentVersion),
          dynamicList('System Uptime', widget.server.systemUptime.toString()),
          dynamicList('Operating System', widget.server.osName),
          dynamicList('Kernel', widget.server.osKernel),
          dynamicList('Processes', widget.server.processes.toString()),
          dynamicList('CPU Model', widget.server.cpuName),
          dynamicList('CPU Speed', widget.server.cpuFreq.toString()),
          dynamicList('IP v4', widget.server.ipv4),
          dynamicList('IP v6', widget.server.ipv6),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical:10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Disk Usage',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14.0),
                    children: [
                      TextSpan(
                        text: formatBytes(widget.server.diskUsage, 0, true),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' / ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: formatBytes(widget.server.diskTotal, 0, true),
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
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: widget.server.diskArray
                .map((s) => Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              s.label,
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 14.0),
                              children: [
                                TextSpan(
                                  text: formatBytes(int.parse(s.usage), 0, true),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' / ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: formatBytes(int.parse(s.total), 0, true),
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
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget dynamicDiskList(String title, int usage, int total) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textBaseline: TextBaseline.ideographic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
              flex: 1,
              child: Text(
                title,
                style: TextStyle(fontSize: 12),
              )),
          Expanded(
              child: Text(
            usage.toString(),
            maxLines: 2,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ],
      ),
    );
  }

  Widget dynamicList(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textBaseline: TextBaseline.ideographic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
              flex: 1,
              child: Text(
                title,
                style: TextStyle(fontSize: 12),
              )),
          Expanded(
              child: Text(
            value,
            maxLines: 2,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ],
      ),
    );
  }
}
