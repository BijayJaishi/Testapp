import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as a;
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/Model/GetExcelData.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime currentBackPressTime;
  List<List<dynamic>> tableData = [];
  List<GetExcelData> getExcelData = [];
  bool isLoading = false;
  int i;
  var row;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExcel();
    _fetchListItem();
//    getHttp();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            getExcel();
//            print(tableData);
            setState(() {
              isLoading = false;
            });
          }),
      appBar: AppBar(
        title: Text('Table Data'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: WillPopScope(
        child: getMainContent(),
        onWillPop: onWillPop,
      ),
    );
  }

  Widget getMainContent() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        tableData.isNotEmpty?a.SingleChildScrollView(
          scrollDirection: a.Axis.vertical,
          child: a.SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SafeArea(
              child: getTable(),
            ),
          ),
        ):a.Center(child: a.CircularProgressIndicator(),),
        Positioned(
          child: isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
            ),
            color: Colors.white.withOpacity(0.8),
          )
              : Container(),
        )
      ],
    );
  }

  getTable() {
    isLoading = false;
    final mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
//      child: dataTable,
      child: Table(
        columnWidths: {
          0: a.FixedColumnWidth(50),
          1: a.FixedColumnWidth(100),
          2: a.FixedColumnWidth(100),
          3: a.FixedColumnWidth(100),
          4: a.FixedColumnWidth(80),
          5: a.FixedColumnWidth(50),
          6: a.FixedColumnWidth(100),
          7: a.FixedColumnWidth(50),
        },
        border: TableBorder.all(width: 1.0),
        children: tableData.map((item) {
          return TableRow(
              children: item.map((row) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: tableData[0] != null ? Text(row.toString(),
                        style: mediaQueryData.orientation ==
                            Orientation.portrait
                            ? TextStyle(fontSize: 10.0, color: Colors.black,fontWeight: a.FontWeight.bold)
                            : TextStyle(fontSize: 13.0, color: Colors.black,fontWeight: a.FontWeight.bold)
                    ):Text(row.toString(),
                        style: mediaQueryData.orientation ==
                            Orientation.portrait
                            ? TextStyle(fontSize: 12.0, color: Colors.black)
                            : TextStyle(fontSize: 13.0, color: Colors.black)
                    ),
                  ),
                );
              }).toList());
        }).toList(),
      ),
    );

  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "Press Again To Exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.deepOrangeAccent,
        timeInSecForIos: 1,
        textColor: Colors.white,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  getExcel() async {
    setState(() {
      isLoading = true;
    });

    ByteData data = await rootBundle.load("assets/excelConvertedData.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes, update: true);
    tableData.clear();
//    var table = excel.tables['Sheet1'];
//    var values = table.rows[0];
//    print(values);
    for (var table in excel.tables.keys) {
      for (row in excel.tables[table].rows) {
        tableData.add(row);
      }
      print(tableData[1]);
    }
  }

  _fetchListItem() async {
    var _downloadData = List<int>();
    var fileSave = new File('./excelDataDownloaded.xls');
    HttpClient client = new HttpClient();
    client.getUrl(Uri.parse("https://file-examples-com.github.io/uploads/2017/02/file_example_XLS_100.xls"))
        .then((HttpClientRequest request) {
      return request.close();
    })
        .then((HttpClientResponse response) {
      response.listen((d) => _downloadData.addAll(d),
          onDone: () {

//            Archive archive = new ZipDecoder().decodeBytes(_downloadData);
//            fileSave.writeAsBytes(_downloadData);
//
//
//        print('Data:$fileSave');

//        var excel = Excel.decodeBytes(_downloadData, update: true);
//        print('eccell:$excel');
          }
      );
//      response.transform(utf8.decoder).listen((contents) => print("Content:$contents"));
    });
  }

//  void getHttp() async {
//    try {
//      Response<List<int>> rs = await Dio().get<List<int>>("https://file-examples-com.github.io/uploads/2017/02/file_example_XLS_100.xls",
//        options: Options(responseType: ResponseType.bytes), // // set responseType to `bytes`
//      );
////      final decode = utf8.decode(rs.data);
//      print(rs.data);
//    } catch (e) {
//      print(e);
//    }
//  }
}
