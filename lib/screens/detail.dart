import 'package:flutter/material.dart';
import 'package:nodequery_client/endpoints/nodequery_endpoint.dart';
import 'package:nodequery_client/helpers/widget.dart';
import 'package:nodequery_client/models/account_model.dart';
import 'package:nodequery_client/models/server_list_model.dart';
import 'package:nodequery_client/models/server_model.dart';
import 'package:nodequery_client/screens/details/server_info.dart';
import 'package:nodequery_client/screens/details/server_load.dart';
import 'package:nodequery_client/screens/details/server_process.dart';

class ServerDetail extends StatefulWidget {
   final ServerListModel srv;
   ServerDetail({
     Key key,
     @required this.srv,
   }) : super(key: key);

  @override
  _ServerDetailState createState() => _ServerDetailState();
}

class _ServerDetailState extends State<ServerDetail> with TickerProviderStateMixin {

  bool _isLoading = true;
  int _selectedTab = 0;


  AccountModel acc;
  ServerModel server;

  _getServerDetail() async {
    var res = await NodeQueryEndpoint().server(widget.srv.id.toString());
    if (res != null) {
      setState(() {
        server = res;
        _isLoading = false;
      });

    } else{
      print('fail');
    }
  }


  @override
  void initState() {
    _getServerDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    TabController tabController =
    new TabController(length: 3, vsync: this, initialIndex: _selectedTab);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 35.0, right: 35.0, top: 30, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.srv.name,
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      widget.srv.status == 'active' ? active(widget.srv.availability) : inactive(),
                      parseUpdateTime(widget.srv.updateTime),
                    ],
                  ),

                ],
              ),
            ),
            TabBar(
              isScrollable: false,
              controller: tabController,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.green,
              labelColor: Colors.green,
                      indicator: CircleTabIndicator(
                        color: Colors.green,
                        radius: 4,
                      ),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.apps,
                    size: 28,
                  ),
                  child: Text(
                    'Details',
                    style:
                    TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.donut_large,
                    size: 28,
                  ),
                  child: Text(
                    'Process',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.trending_up,
                    size: 28,
                  ),
                  child: Text(
                    'Load',
                    style:
                    TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                  ),
                ),
              ],
              onTap: (int index) => {
                setState(() {
                  _selectedTab = index;
                })
              },
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: _isLoading ? Center(child: CircularProgressIndicator(),) : _buildChild(),

            ),

          ],
        ),
      ),
    );
  }

  Widget _buildChild() {
    if (_selectedTab == 0) {
      return ServerInfo(server: server);
    } else if (_selectedTab == 1) {
      return ServerProcess(prc: server.processesArray,);
    } else if (_selectedTab == 2) {
      return ServerLoad(server: server);
    }
    return Container();
  }
}


class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius + 10);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
