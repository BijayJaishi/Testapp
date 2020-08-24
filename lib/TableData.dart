import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime currentBackPressTime;
  List<List<dynamic>> tableData = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExcel();
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
        SingleChildScrollView(
            child: SafeArea(
          child: getTable(),
        )),
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
      child: Table(
        columnWidths:{
          0: FlexColumnWidth(1.08),
          1: FlexColumnWidth(1.8),
          2: FlexColumnWidth(2.0),
          3: FlexColumnWidth(1.5),
          4: FlexColumnWidth(1.58),
          5: FlexColumnWidth(1.08),
          6: FlexColumnWidth(1.5),
          7: FlexColumnWidth(1.3),
        },
        border: TableBorder.all(width: 1.0),
        children: tableData.map((item) {
          return TableRow(
              children: item.map((row) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  row.toString(),
                  style: mediaQueryData.orientation == Orientation.portrait
                      ? TextStyle(fontSize: 8.0, color: Colors.black)
                      : TextStyle(fontSize: 13.0, color: Colors.black),
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
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        tableData.add(row);
      }
    }
  }
}
