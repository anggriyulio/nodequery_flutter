import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:nodequery_client/endpoints/nodequery_endpoint.dart';
import 'package:nodequery_client/models/server_load_model.dart';
import 'package:nodequery_client/models/server_model.dart';

class ServerLoad extends StatefulWidget {
  final ServerModel server;

  ServerLoad({
    Key key,
    @required this.server,
  }) : super(key: key);

  @override
  _ServerLoadState createState() => _ServerLoadState();
}

class _ServerLoadState extends State<ServerLoad> {
  List<ServerLoadModel> serverLoads;
  bool _isLoading = true;
  String _range = 'hourly';

  Future getServerLoad(String range) async {
    var res =
        await NodeQueryEndpoint().loads(_range, widget.server.id.toString());
    if (res != null) {
      setState(() {
        serverLoads = res;
        _isLoading = false;
      });
    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Request fail!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  setRange(String range) async {
    await getServerLoad(range).then((value) => setState(() => _range = range));
  }

  @override
  void initState() {
    getServerLoad(_range);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Center(
              child: CircularProgressIndicator(),
            ))
        : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GFButton(
                      onPressed: () => setRange('hourly'),
                      color: Colors.black,
                      textStyle: TextStyle(fontSize: 10),
                      text: "HOURLY",
                      shape: GFButtonShape.standard,
                    ),
                    GFButton(
                      onPressed: () => setRange('daily'),
                      color: Colors.black,
                      textStyle: TextStyle(fontSize: 10),
                      text: "DAILY",
                      shape: GFButtonShape.standard,
                    ),
                    GFButton(
                      onPressed: () => setRange('monthly'),
                      color: Colors.black,
                      textStyle: TextStyle(fontSize: 10),
                      text: "MONTHLY",
                      shape: GFButtonShape.standard,
                    ),
                    GFButton(
                      onPressed: () => setRange('yearly'),
                      color: Colors.black,
                      textStyle: TextStyle(fontSize: 10),
                      text: "YEARLY",
                      shape: GFButtonShape.standard,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 12.0),
                      children: [
                        WidgetSpan(
                            child: Icon(
                          Icons.memory,
                          size: 16,
                        )),
                        TextSpan(
                          text: 'Average Load',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' with CPU & Disk IO',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: LineChart(
                    LineChartData(
                      maxY: 100.0,
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        horizontalInterval: 25.0,
                      ),
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.white,
                          tooltipPadding: const EdgeInsets.all(5),
                          tooltipBottomMargin: 20,
                          getTooltipItems: (
                            List<LineBarSpot> touchedSpots,
                          ) {
                            return touchedSpots
                                .map((e) => LineTooltipItem(
                                      e.y.toString() + '%',
                                      TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))
                                .toList();
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.normal,
                              fontSize: 12),
                          margin: 15,
                          reservedSize: 20,
                          getTitles: (double value) {
                            var intVal = value.toInt();
                            if ((serverLoads.singleWhere(
                                    (it) => it.time == intVal,
                                    orElse: () => null)) !=
                                null) {
                              return parseLoadTime(value.toInt(), _range);
                            } else {
                              return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(showTitles: false),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: serverLoads
                              .map(
                                (e) => FlSpot(
                                    e.time.toDouble(), e.loadCpu.toDouble()),
                              )
                              .toList(),
                          isCurved: true,
                          colors: [
                            Colors.blue,
                            Colors.blueAccent,
                          ],
                          barWidth: 3,
                          dotData: FlDotData(
                            show: false,
                          ),
                        ),
                        LineChartBarData(
                          spots: serverLoads
                              .map(
                                (e) => FlSpot(
                                    e.time.toDouble(), e.loadAvg.toDouble()),
                              )
                              .toList(),
                          isCurved: true,
                          colors: [
                            Colors.black,
                          ],
                          barWidth: 3,
                          dotData: FlDotData(
                            show: false,
                          ),
                        ),
                        LineChartBarData(
                          spots: serverLoads
                              .map(
                                (e) => FlSpot(
                                    e.time.toDouble(), e.loadIo.toDouble()),
                              )
                              .toList(),
                          isCurved: true,
                          colors: [
                            Colors.greenAccent,
                            Colors.green,
                          ],
                          barWidth: 3,
                          dotData: FlDotData(
                            show: false,
                          ),
                        ),
                      ],
                    ),
                    swapAnimationDuration: Duration(milliseconds: 300),
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 12.0),
                      children: [
                        WidgetSpan(
                            child: Icon(
                          Icons.linear_scale,
                          size: 12,
                          color: Colors.black,
                        )),
                        TextSpan(
                          text: 'Average Load',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        WidgetSpan(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.linear_scale,
                            size: 12,
                            color: Colors.blue,
                          ),
                        )),
                        TextSpan(
                          text: 'CPU Load',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        WidgetSpan(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.linear_scale,
                            size: 12,
                            color: Colors.green,
                          ),
                        )),
                        TextSpan(
                          text: 'IO Load',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 12.0),
                      children: [
                        WidgetSpan(
                            child: Icon(
                          Icons.network_check,
                          size: 16,
                        )),
                        TextSpan(
                          text: 'Latency',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' to Europe, USA & Asia',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        horizontalInterval: 50,
                      ),
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.white,
                          tooltipPadding: const EdgeInsets.all(5),
                          tooltipBottomMargin: 20,
                          getTooltipItems: (
                            List<LineBarSpot> touchedSpots,
                          ) {
                            return touchedSpots
                                .map((e) => LineTooltipItem(
                                      e.y.toString() + ' ms',
                                      TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))
                                .toList();
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.normal,
                              fontSize: 12),
                          margin: 15,
                          reservedSize: 20,
                          getTitles: (double value) {
                            var intVal = value.toInt();
                            if ((serverLoads.singleWhere(
                                    (it) => it.time == intVal,
                                    orElse: () => null)) !=
                                null) {
                              return parseLoadTime(value.toInt(), _range);
                            } else {
                              return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(showTitles: false),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: serverLoads
                              .map(
                                (e) => FlSpot(
                                    e.time.toDouble(), e.pingEu.toDouble()),
                              )
                              .toList(),
                          isCurved: true,
                          colors: [
                            Colors.blue,
                            Colors.blueAccent,
                          ],
                          barWidth: 3,
                          dotData: FlDotData(
                            show: false,
                          ),
                        ),
                        LineChartBarData(
                          spots: serverLoads
                              .map(
                                (e) => FlSpot(
                                    e.time.toDouble(), e.pingUs.toDouble()),
                              )
                              .toList(),
                          isCurved: true,
                          colors: [
                            Colors.black,
                          ],
                          barWidth: 3,
                          dotData: FlDotData(
                            show: false,
                          ),
                        ),
                        LineChartBarData(
                          spots: serverLoads
                              .map(
                                (e) => FlSpot(
                                    e.time.toDouble(), e.pingAs.toDouble()),
                              )
                              .toList(),
                          isCurved: true,
                          colors: [
                            Colors.greenAccent,
                            Colors.green,
                          ],
                          barWidth: 3,
                          dotData: FlDotData(
                            show: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 12.0),
                      children: [
                        WidgetSpan(
                            child: Icon(
                          Icons.linear_scale,
                          size: 12,
                          color: Colors.black,
                        )),
                        TextSpan(
                          text: 'USA',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        WidgetSpan(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.linear_scale,
                            size: 12,
                            color: Colors.blue,
                          ),
                        )),
                        TextSpan(
                          text: 'Europe',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        WidgetSpan(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.linear_scale,
                            size: 12,
                            color: Colors.green,
                          ),
                        )),
                        TextSpan(
                          text: 'Asia',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  String parseLoadTime(int updateTime, String range) {
    final time = new DateTime.fromMillisecondsSinceEpoch(updateTime * 1000);

    switch (range) {
      case 'yearly':
        return DateFormat('y').format(time).toString();
        break;
      case 'monthly':
        return DateFormat('Md').format(time).toString();
        break;
      case 'daily':
        return DateFormat('jm').format(time).toString();
        break;
      case 'hourly':
        return DateFormat('Hm').format(time).toString();
        break;
      default:
        return DateFormat('y-m-d hj').format(time).toString();
    }
  }
}
