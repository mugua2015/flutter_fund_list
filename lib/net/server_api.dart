import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fund_list_app/model/fund.dart';
import 'package:url_launcher/url_launcher.dart';

class ServerApi {
  String url = "";
  final fundCodes = [
    "501057",
    "501057",
    "001298",
    "007300",
    "005885",
    "007872",
    "001951",
    "011609",
    "003096",
    "005827",
    "180012",
    "009644",
    "162605",
    "007553",
    "000793",
    "001938",
    "005940",
    "005939",
    "002379",
    "008590",
    "008099",
    "161032",
    "003625",
    "165520",
    "161724",
    "502023",
    "002084",
    "162605",
    "001938",
    "003096",
    "090018",
    "005940",
    "000793",
    "001606",
    "002190",
    "003834",
    "002083",
    "260108",
    "550015",
    "180012",
    "004987",
    "110011",
    "161616",
    "161725",
    "519674"
  ];

  List<Fund> _listFound = [];
  final String _BASE_URL = "https://fundgz.1234567.com.cn/js/";

  Future<Fund> _getFund(String id) async {
    url = _BASE_URL + id + ".js?rt=1589463125600";
    var dio = Dio(BaseOptions(
        baseUrl: url,
        connectTimeout: 10000,
        receiveTimeout: 10000,
        headers: {
          "user-agent": "dio",
          "api": "1.0.0",
          // "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
          // "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
          // "Access-Control-Allow-Methods": "GET, POST, OPTIONS"
        },
////        contentType: ContentType.json,
        responseType: ResponseType.json));
    Fund _fund;
    try {
      Response<String> response = await dio.get(url);
      dynamic data = response.data;
      data = data.toString().replaceRange(0, 8, "");
      String tmp = data.toString();
      tmp = tmp.replaceRange(tmp.length - 2, tmp.length, "");
      dynamic json = jsonDecode(tmp);
      // print("************************get fund json*********************************");
      _fund = Fund.jsonToFund(json);
      print(_fund.fundcode + "_" + _fund.name + "     " + _fund.gszzl);
      _listFound.add(_fund);
    } catch (e) {
      print("getFund err:::" + e.toString());
    }
    return _fund;
  }

  Future<List<Fund>> getFundList2() async {
    print("=====================getFundList============================");
    _listFound.clear();

    List<Future<Fund>> futureList = [];
    for (int i = 0; i < fundCodes.length; i++) {
      String id = fundCodes[i];
      Future<Fund> fundFutrue = _getFund(id);
      futureList.add(fundFutrue);
    }
    return await Future.wait(futureList);
  }

  Future<List<Fund>> getFundList() async {
    print("=====================getFundList============================");
    _listFound.clear();

    for (int i = 0; i < fundCodes.length; i++) {
      url = _BASE_URL + fundCodes[i] + ".js?rt=1589463125600";
      var dio = Dio(BaseOptions(
          baseUrl: url,
          connectTimeout: 5000,
          receiveTimeout: 10000,
          headers: {
            "user-agent": "dio",
            "api": "1.0.0",
          },
          responseType: ResponseType.json));
      Fund _fund = null;
      try {
        Response<String> response = await dio.get(url);
        dynamic data = response.data;
        data = data.toString().replaceRange(0, 8, "");
        String tmp = data.toString();
        tmp = tmp.replaceRange(tmp.length - 2, tmp.length, "");
        dynamic json = jsonDecode(tmp);
        // print("************************get fund json*********************************");
        _fund = Fund.jsonToFund(json);
        _listFound.add(_fund);
      } catch (e) {
        print("getFund err:::" + e.toString());
      }
    }
    return _listFound;
  }

  static Future<void> launchInBrowser(String code) async {
    // String  url = "https://fundgz.1234567.com.cn/js/"+code+".js?rt=1589463125600";
    String url =
        "https://fund.eastmoney.com/f10/F10DataApi.aspx?type=lsjz&code=" +
            code; /*获取最近10天的净值数据*/
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: true,
        enableJavaScript: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
