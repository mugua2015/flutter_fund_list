import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fund_list_app/provider/fund_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'net/server_api.dart';
import 'widgets/widget_builder.dart';

void main() {
  WidgetsApp.debugAllowBannerOverride = false;
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FundModel())],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
        footerTriggerDistance: 15,
        dragSpeedRatio: 0.91,
        headerBuilder: () => MaterialClassicHeader(),
        footerBuilder: () => ClassicFooter(),
        enableLoadingWhenNoData: false,
        enableRefreshVibrate: false,
        enableLoadMoreVibrate: false,
        shouldFooterFollowWhenNotFull: (state) {
          // If you want load more with noMoreData state ,may be you should return false
          return false;
        },
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: MyHomePage(title: 'Fund List'),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    context.read<FundModel>().getFundList();
    print("==============MyHomePage build =============================");
    return _MyHomePageState();
  }
}

class _MyHomePageState extends StatelessWidget {
  final String title;

  RefreshController _refreshController;

  _MyHomePageState({Key key, this.title}) : super(key: key) {
    _refreshController = RefreshController(initialRefresh: false);
  }

  void launchUrl(String code) async {
    ServerApi.launchInBrowser(code);
  }

  @override
  Widget build(BuildContext context) {
    print("==============_MyHomePageState build =============================");
    return Scaffold(
      appBar: AppBar(
        title: Text("Fund List"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {
              context.read<FundModel>().getFundList();
            },
          )
        ],
      ),
      body: (context.watch<FundModel>().isShowIndicator)
          ? buildProgressbar()
          : SmartRefresher(
              controller: _refreshController,
              onRefresh: () => context.read<FundModel>().getFundList(),
              child: ListView.builder(
                itemCount: (context.watch<FundModel>().fundList?.length),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: Colors.purpleAccent,
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Card(
                            child: Column(children: [
                          /*代号  时间*/
                          buildRowCell(
                              context
                                  .watch<FundModel>()
                                  .fundList[index]
                                  ?.fundcode,
                              context
                                  .watch<FundModel>()
                                  .fundList[index]
                                  ?.gztime),
                          //*名称 净值估算*//*
                          buildRowCell2(
                              context.watch<FundModel>().fundList[index]?.name,
                              context.watch<FundModel>().fundList[index]?.gszzl)
                        ]))),
                    onTap: () {
                      //错误：： launchUrl( context .watch<FundProvider>() .fundList[index] ?.fundcode);
                      /*在组件树外使用Provider中的数据 ，必须使之停止listen 否则会抛异常 */
                      launchUrl(Provider.of<FundModel>(context, listen: false)
                          .fundList[index]
                          ?.fundcode);
                    },
                  );
                },
              ),
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => context.read<FundModel>().getFundList(),
      //   tooltip: 'Increment',
      //   child: Icon(Icons.refresh),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
