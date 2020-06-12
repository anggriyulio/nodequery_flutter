import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nodequery_client/models/server_list_model.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget serverList(ServerListModel s) {
  return Container(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 4))
        ]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              s.status == 'active' ? active(s.availability) : inactive(),
              _update_time(s.updateTime),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              s.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 12.0),
                children: [
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Icon(
                        Icons.settings_ethernet,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  TextSpan(
                      text: s.ipv4,
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        _chartData(s),
      ],
    ),
  );
}

Widget _chartData(ServerListModel s) {
  return Container(
    width: double.infinity,
    height: 180,
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: const EdgeInsets.all(0),
            tooltipBottomMargin: 0,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                rod.y.round().toString() + '%',
                TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              );
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
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return 'CPU Load';
                case 1:
                  return 'RAM Usage';
                case 2:
                  return 'Disk Usage';
                default:
                  return '';
              }
            },
          ),
          leftTitles: SideTitles(showTitles: false),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(
              y: s.loadPercent.toDouble(),
              color: Colors.lightBlueAccent,
              width: 35,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            )
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(
              y: (s.ramUsage / s.ramTotal) * 100,
              color: Colors.lightBlueAccent,
              width: 35,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            )
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(
              y: (s.diskUsage / s.diskTotal) * 100,
              color: Colors.lightBlueAccent,
              width: 35,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
          ], showingTooltipIndicators: [
            0
          ]),
        ],
      ),
    ),
  );
}

Widget _update_time(int updateTime) {
  final lastUpdate =
      new DateTime.now().subtract(Duration(milliseconds: updateTime));

  return Container(
    child: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 12.0),
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.access_time,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ),
          TextSpan(
              text: timeago.format(lastUpdate),
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    ),
  );
}

Widget inactive() {
  return Container(
    child: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 12.0),
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.radio_button_checked,
                size: 16,
                color: Colors.red,
              ),
            ),
          ),
          TextSpan(
              text: 'Not Responding',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

Widget active(String avl) {
  return Container(
    child: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 12.0),
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.radio_button_checked,
                size: 16,
                color: Colors.green,
              ),
            ),
          ),
          TextSpan(
              text: '$avl Availability',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

String formatBytes(int bytes, int decimals, bool suffix) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  String ss = suffix ? ' ' + suffixes[i] : '';
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ss ;
}
