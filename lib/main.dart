import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io' as io;
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'QR Code Generator'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File path;
  String qrtext = '';
  List data = [];
  List column = [];
  GlobalKey globalKey = new GlobalKey();
  bool isDownloaded = false;
  var path11;
  var dirPath;
  var rootPath;
  var pp = '';
  var pdf;
  var webController;
  var pdfdata;
  bool isError =false;
  bool showPdf = false;
  Future<void> _pickDir(BuildContext context) async {
    // var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    // print(pixelRatio);
    // Directory directory = await getApplicationDocumentsDirectory();
    // print(directory.path);
    // await directory.list().toList().then((filesList) => print(filesList));
    // print(directory.parent.path);
    String path = await FilesystemPicker.open(
      title: 'Save to folder',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.folder,
      pickText: 'Save file to this folder',
      folderIconColor: Colors.red,
    );
    setState(() {
      print(path);
      dirPath = path;
      pp = path;
    });
    Navigator.pop(context);
  }
  Uint8List dd;
  void initState() {
    super.initState();
    // print(dd.runtimeType);
    // dd = (File('C:/Users/sulaiman kc/Documents/1608384286886.pdf')).readAsBytesSync();
    // print(dd);
    // print(dd.runtimeType);

    setPath();
  }



  setPath() async{
    var pt = await getApplicationDocumentsDirectory();
    pp = pt.path;
    var pt1 = pt.path;
    var pt2 = pt1.split("\\");
    pt2.removeLast();
    pt1 = pt2.join("\\");
    print(pt1);
    rootPath = Directory('/');//Directory(pt1);
    // print(rootPath);
  }

  excelUpload() async{
    pdf = pw.Document();

    data = [];

    // print(qrimage);
    final file = OpenFilePicker();
    // print(file);
    file.hidePinnedPlaces = true;
    file.forcePreviewPaneOn = true;
    file.filterSpecification = {
      'Excel Files': '*.xlsx;*.xls',
    };
    file.title = 'Select an Excel';
    final result = file.getFile();
    if (result != null) {
      print(path);
      setState(() {
        path = result;
      });
    }
    var bytes = File(path.path).readAsBytesSync();
    var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
    var table = decoder.tables['Sheet1'];
    var values = table.rows;
    var length = table.rows.length;
    var json ={};
    // print(values);
      setState(() {
        showPdf = false;
      });
    for(var i = 1;i<values.length;i++){
      if(values[i][0] == null || values[i][0] == '' || values[i][1] == null || values[i][1] == '' || values[i][2] == null || values[i][2] == ''){
        setState(() {
          showPdf = false;
          data = [];
        });
        Toast.show("Invalid Excel Data", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
        return 0;
      }
      if(values[i][1].toString().length != 4 || ( values[i][2].toString().length > 4)){
        setState(() {
          showPdf = false;
          data = [];
        });
        Toast.show("Invalid Excel Data", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
        return 0;
      }
      var code = '';
      setState(() {
        this.column = values[0];
        var qr = values[i][0].replaceAll(' ', '');
        // if(i == 1){
        //   print('qr : '+qr);
        // }
        if(qr == '2FSM'){
          code = '000002F';
        }
        else if(qr == '2FSMYARN'){
          code = '00002FY';
        }
        else if(qr == '4FSM'){
          code = '000004F';
        }
        else if(qr == '4FSMYARN'){
          code = '00004FY';
        }
        else if(qr == '6FSM'){
          code = '000006F';
        }
        else if(qr == '6FSMYARN'){
          code = '00006FY';
        }
        else if(qr == '12FSM'){
          code = '000012F';
        }
        else if(qr == '12FSMYARN'){
          code = '00012FY';
        }
        else if(qr == '2FFTTHYARN'){
          code = '02FTTHY';
        }
        else if(qr == '4FFTTHYARN'){
          code = '04FTTHY';
        }
        else if(qr == '2FSMADSS'){
          code = '02FADSS';
        }
        else if(qr == '4FSMADSS'){
          code = '04FADSS';
        }
        else if(qr == '6FSMADSS'){
          code = '06FADSS';
        }
        else if(qr == '12FSMADSS'){
          code = '12FADSS';
        }
        else if(qr == '2FSMA2SERIES'){
          code = '0002FA2';
        }
        else if(qr == '4FSMA2SERIES'){
          code = '0004FA2';
        }
        else if(qr == '6FSMA2SERIES'){
          code = '0006FA2';
        }
        else if(qr == '12FSMA2SERIES'){
          code = '0012FA2';
        }
        else{
          code = '';
        }
      });

      if(code != ''){
        var len;
        var qcode;
        setState(() {
          json = {};
          len = values[i][2].toString().length == 3? '0'+values[i][2].toString():values[i][2].toString().length == 2? '00'+values[i][2].toString():values[i][2].toString().length == 1? '000'+values[i][2].toString():values[i][2].toString();
          qcode = code+len+values[i][1];
        });
        // await _captureAndSharePng(values[i][0]+values[i][1]+len, i, qcode);
        setState(() {

          json[values[0][0]] = values[i][0];
          json[values[0][1]] = values[i][1];
          json[values[0][2]] = len;
          json['qrText'] = qcode;

        });
        final directory = await getTemporaryDirectory();
        setState(() {
          json['img'] = directory.path+'\\$qcode.png';
          data.add(json);
        });
        _generatePdf1(PdfPageFormat.a3, json);

        // qrtext = values[i][0]+values[i][1]+values[i][2];
      }
      if(i == this.data.length){
        // _timer = new Timer(const Duration(milliseconds: 1000), () {

        // });
      }
    }
    pdfdata = pdf.save();
    setState(() {
      showPdf = true;
    });
    // print(data[1]['Item']);

  }


  Future<Uint8List> _generatePdf1(PdfPageFormat format, json) async {
    // int i = 0;
    pdf.addPage(
        pw.MultiPage(
            maxPages: 1000,
            header: (pw.Context context) {
              return pw.Container(
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text('POLY INFOCOM CABLES PRIVATE LIMITED',
                            style: pw.Theme.of(context)
                                .defaultTextStyle
                                .copyWith(color: PdfColors.grey800, fontSize: 10)),

                      ]
                  )
              );
            },
            margin: pw.EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 15),
            // symmetric(horizontal: 30, vertical: 20),
            pageFormat:
            PdfPageFormat(9.9822 * PdfPageFormat.cm,7.493 * PdfPageFormat.cm).copyWith(marginBottom: 0.5 * PdfPageFormat.cm),
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            build: (pw.Context context) => <pw.Widget>[
              pw.Row(
                children: [

                ]
              ),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // for(i = 0;data.length>i;i++)
                      // if(i %2 == 0)
                      pw.Row(
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Column(
                                // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                  children: [
                                    pw.SizedBox(height: 30,),

                                    pw.Row(
                                        children: [
                                          pw.Center(child: pw.BarcodeWidget(
                                            data: json['qrText'].toString(),
                                            width: 80,
                                            height: 80,
                                            barcode: pw.Barcode.qrCode(),
                                          ),),
                                          pw.SizedBox(width: 10),
                                          pw.Column(
                                              mainAxisSize: pw.MainAxisSize.max,
                                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                                              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                              children: [
                                                pw.Row(
                                                    children: [
                                                      // pw.Text('QR Code    '),
                                                      pw.Text(json['qrText'].toString(),style: pw.TextStyle(fontSize: 12)),
                                                    ]
                                                ),
                                                pw.SizedBox(height: 5,),
                                                pw.Row(
                                                    children: [
                                                      pw.Text('Code         ',style: pw.TextStyle(fontSize: 12)),
                                                      pw.Text(': '+json[this.column[0]].toString(),style: pw.TextStyle(fontSize: 12)),
                                                    ]
                                                ),
                                                pw.SizedBox(height: 5,),
                                                pw.Row(
                                                    children: [
                                                      pw.Text('Cable No. ',style: pw.TextStyle(fontSize: 12)),
                                                      pw.Text(': '+json[this.column[1]].toString(),style: pw.TextStyle(fontSize: 12)),
                                                    ]
                                                ),
                                                pw.SizedBox(height: 5,),
                                                pw.Row(
                                                    children: [
                                                      pw.Text('Length      ',style: pw.TextStyle(fontSize: 12)),
                                                      pw.Text(': '+json[this.column[2]].toString(),style: pw.TextStyle(fontSize: 12)),
                                                    ]
                                                ),

                                              ]
                                          )
                                        ]
                                    )
                                  ]
                              )
                          ),
                        ]
                      )
                  ]
              ),
            ])
    );
    // return pdf.save();
  }


  pdfDownload() async{

    setState(() {
      isDownloaded = false;
      this.isError = false;
    });
    if(data.length == 0){
      Toast.show("No File Selected", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
    else{
      final directory = await getApplicationDocumentsDirectory();
      print(directory);
      io.Directory(pp).exists().then((value){
        if(value){
          Toast.show("Downloaded To "+pp, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          var name = DateTime.now().millisecondsSinceEpoch;
          var paths = File(pp);
          path11 = paths.path+'\\$name.pdf';
          File(paths.path+'\\$name.pdf').writeAsBytes(pdf.save());
          setState(() {
            isDownloaded = true;
          });
        }
        else{
          Toast.show("Download Location not Exist", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
          setState(() {
            this.isError = true;
          });
        }
      });
    }


    // _timer = new Timer(const Duration(milliseconds: 4000), () {
    //   setState(() {
    //     path = null;
    //     isDownloaded = false;
    //   });
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Material(
              // needed
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  this.excelUpload();
                }, // needed
                child: Image.asset(
                  "excel.png",
                  // width: 22,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // SizedBox(width: 20,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Material(
                // needed
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    this.pdfDownload();
                    // this.excelUpload();
                  }, // needed
                  child: Image.asset(
                    "pdf.png",
                    // width: 22,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Material(
                // needed
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _openPopup(context);
                    // this.excelUpload();
                  }, // needed
                  child: Image.asset(
                    "settings.png",
                    // width: 22,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              !showPdf || data.length == 0?Container():Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height - 55,
                child:
                PdfPreview(
                  // useActions: false,
                  // pageFormats: {'size':PdfPageFormat(350,220)},
                  // initialPageFormat: PdfPageFormat(350,220),
                  pdfFileName: DateTime.now().millisecondsSinceEpoch.toString(),
                  // pageFormats: PdfPageFormat.a3,
                  canChangePageFormat: true,
                  build:  (format) async=> pdfdata//await _generatePdf1(PdfPageFormat.a3, 'title'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _openPopup(context) {
    Alert(
        context: context,
        title: "SETTINGS",
        content: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Text('Download Location', style: TextStyle(fontSize: 14),),
            SizedBox(height: 10,),
            Container(
              width: 300,
              height: 30,
              child: TextField(
                controller: TextEditingController()..text = pp,
                scrollPadding: EdgeInsets.zero,
                // cursorColor: p,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87,
                      )),
                  focusColor: Colors.black87,
                  fillColor: Colors.black87,
                  hoverColor: Colors.black87,
                  hintText: 'Download Location',
                  hintStyle: TextStyle(fontSize: 12),

                ),
                onChanged: (text) => {
                  pp = text
                },
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: RaisedButton(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text('Browse'),
                onPressed:
                (rootPath != null) ? () => _pickDir(context) : null,
              ),
            ),
          ],
        ),
        buttons: [
        ]
    ).show();
  }
}
