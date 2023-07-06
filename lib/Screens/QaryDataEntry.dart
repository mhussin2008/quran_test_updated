//import 'dart:js_interop';



import 'package:flutter/material.dart';
import 'package:quran_test_updated/Screens/QaryExamScreen.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:quran_test_updated/Data/qaryData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Data/QaryDataSource.dart';
import 'DialogScreen.dart';

class qaryDataEntry extends StatefulWidget {
  final String testName;
  qaryDataEntry({Key? key, required this.testName}) : super(key: key);

  @override
  State<qaryDataEntry> createState() => _qaryDataEntryState();
}

class _qaryDataEntryState extends State<qaryDataEntry> {
  //QaryDataSource dataSource=QaryDataSource(qaryList: QaryList);
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  List<bool> theSelected=<bool>[true,false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   CheckDbase();
    // });
    QaryList.clear();

    CheckDbase().then((value) =>
    {
      if (value=='Ok'){
      GetFromDb(widget.testName).then((value) => {
        print('Loaded all data')

      })
    }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    //var chkbox_value='4 أسئلة';

    DataGridController dataGridController=DataGridController();
    QaryDataSource dataSource = QaryDataSource(qaryList: QaryList);
    //dataGridController.addListener((){listnerFunction();});

    return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('  مسابقة  ${widget.testName}') ,backgroundColor: Colors.cyan,),

        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/jpg/back.jpg' ),fit: BoxFit.cover
              )
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text('اسم الطالب'),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  style: const TextStyle(height: 0.5),
                  keyboardType: TextInputType.text,
                  textDirection: TextDirection.rtl,
                  controller: nameController,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder())),
              SizedBox(
                height: 20,
              ),
              Text('عمر الطالب'),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  style: const TextStyle(height: 0.5),
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.rtl,
                  controller: ageController,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder())),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  OutlinedButton(
                      onPressed: () async {
                        List<QaryData>? search=[];
                       search=QaryList.where((element) => element.qaryName==nameController.text).toList();
                        print(search);
                        if(search.length>0){
                          return;
                        }
                       //
                        if (nameController.text.isNotEmpty &&
                            ageController.text.isNotEmpty) {
                          setState(()  {
                            QaryList.add(QaryData.fromFields(nameController.text,
                                int.parse(ageController.text),100,widget.testName,getQuestNum(theSelected[0])));
                              });
                          String retVal=await  CheckDbase();
                          if (retVal=='Ok'){
                            print('ok');
                            await AddtoDb();
                          }
                          Fluttertoast.showToast(
                              msg: "تم إضافة بيانات الطالب بنجاح ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blueAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          nameController.text = '';
                          ageController.text = '';
                          FocusManager.instance.primaryFocus?.unfocus();
                          print(QaryList.toString());
                            print(QaryList.length.toDouble());
                            dataGridController.refreshRow(QaryList.length);
                           //dataGridController.scrollToRow(QaryList.length.toDouble());



                          // Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: "بيانات الطالب غير مكتملة",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: Text('حفظ البيانات')),
                  SizedBox(width: 20,),
                  ToggleButtons(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.red[700],
                      selectedColor: Colors.white,
                      fillColor: Colors.red[200],
                      color: Colors.red[400],
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 80.0,
                      ),


                    isSelected: theSelected,

                      onPressed: (int toggleIndex) {
                        print(toggleIndex);
                        //theSelected=<bool>[false,true];
                        setState(() {
                          if(toggleIndex==1){theSelected=<bool>[false,true];}
                          else{theSelected=<bool>[true,false];}
                          print(theSelected);
                          // The button that is tapped is set to true, and the others to false.

                        });
                      },
                    //color: Colors.white,
                      //fillColor: Colors.white,
                      children: [Text('4 أسئلة',textDirection: TextDirection.rtl,),Text('5 أسئلة',textDirection: TextDirection.rtl)]),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                //color: Colors.tealAccent,
                child: SfDataGrid(
                  allowEditing: true,
                allowSorting: true,
                selectionMode: SelectionMode.single,
                columnWidthMode: ColumnWidthMode.fill,
                isScrollbarAlwaysShown: true,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                controller: dataGridController,
                source: dataSource,
                // onCellTap: (cellDetails){
                //     // setState(() {
                //     //
                //       print(cellDetails.rowColumnIndex.rowIndex-1);
                //       int x=(QaryList[cellDetails.rowColumnIndex.rowIndex-1].questions);
                //     //});
                //   setState(() {
                //     if(x==4){theSelected=[true,false];}
                //     else{theSelected=[false,true];}
                //   });
                //     //print(cellDetails.rowColumnIndex.rowIndex);
                // },
                columns: <GridColumn>[
                  GridColumn(

                      columnName: 'name',
                      label: Container(
                            color: Colors.cyanAccent,
                          padding: EdgeInsets.all(4.0),
                          alignment: Alignment.centerRight,
                          child: Text(
                           'اسم الطالب',

                          ))),
                  GridColumn(

                      columnName: 'age',
                      label: Container(
                          color: Colors.cyanAccent,
                          padding: EdgeInsets.all(4.0),
                          alignment: Alignment.centerRight,
                          child: Text('عمر الطالب  '))),

                  GridColumn(
                      columnName: 'degree',
                      label: Container(
                          color: Colors.cyanAccent,
                          padding: EdgeInsets.all(4.0),
                          alignment: Alignment.centerRight,
                          child: Text('الدرجة  ')))
,                     GridColumn(

                      columnName: 'questions',
                      label: Container(
                          color: Colors.cyanAccent,
                          padding: EdgeInsets.all(4.0),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'الأسئلة',

                          ))),

                ].reversed.toList(),
                  ),
              ),
              SizedBox(height: 10,),
             // Container(width: 20,color: Colors.green,),
              Row(mainAxisAlignment: MainAxisAlignment.start ,children: [

                OutlinedButton(

                    onPressed: () async {
                      if(dataGridController.selectedRow != null){
                        print(dataGridController.selectedRow?.getCells().first.value);
                        String qname=dataGridController.selectedRow?.getCells().first.value;

                        setState(() {
                          QaryList.removeWhere(
                                  (element) => element.qaryName==dataGridController.selectedRow?.getCells().first.value);
                        });
                        await DelSrowFromDb(qname,widget.testName);

                      }
                      //Navigator.pop(context);
                    },
                    child: Text('مسح بيانات \n الطالب')),
//////////////////////////////////////////////////////////////////////////////////////////////////
              //////////////////////////////////////////
                OutlinedButton(

                    onPressed: () async {
                      String Selected='';
                      double selected_deg=0;
                      int selected_quest=4;
                      if(dataGridController.selectedRow != null){
                      Selected=dataGridController.selectedRow!.getCells().first.value.toString();
                      if(dataGridController.selectedRow!.getCells()[2].value !=null){
                      selected_deg=dataGridController.selectedRow!.getCells()[2].value;
                      }
                      if(dataGridController.selectedRow!.getCells()[3].value !=null){
                        selected_quest=dataGridController.selectedRow!.getCells()[3].value;
                      }
                      //selected_quest=int.parse(dataGridController.selectedRow!.getCells()[2].value.toString());

                        print(dataGridController.selectedRow?.getCells().first.value);
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => QaryExam(qaryName: Selected,degree: selected_deg ,testName: widget.testName,questions: selected_quest ,)));
                      }

                      GetFromDb(widget.testName).then((value) => {
                        print('Loaded all data')

                      });
                      // setState(() {
                      // print('updating');
                      // });
                      //Navigator.pop(context);
                    },
                    child: Text('بدء الإختبار')),

                OutlinedButton(
                    onPressed: () async {
                      String result= await showDialog(
                          context: context,
                          builder: (BuildContext context) => const DialogScreen());

                      print(result);
                      if(result=='OK'){
                        print('deleting');
                        setState(() {
                          QaryList.clear();
                        });
                        CheckDbase().then(
                                (value) async {
                                  if(value=='Ok'){
                                    await ClearDb();
                                  };
                                });
                      }

                    },
                    child: Text('مسح الجدول \n بالكامل')),


              ],


              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('عودة الى الشاشة الرئيسية')),

            ],
          ),
        ));
  }

  Future<String> CheckDbase() async {

    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    var dbExists = File(dbFilePath).existsSync();
    if (dbExists == false) {
      print('no such database');

    } else {

    }
    late Database db;
    db = await openDatabase('qary_dbase.db');
    if (db.isOpen == false) {
      print('cant open database');
      return 'No';
    }
    var tables = await db
        .rawQuery('SELECT * FROM sqlite_master WHERE name="datatable";');

    if (tables.isEmpty) {
      // Create the table
      print('no such table');
      try {
        await db.execute('''
        create table datatable (
        qaryname TEXT NOT NULL ,
        qaryage INTEGER DEFAULT 0 ,
        degree REAL DEFAULT 100.0,
        testname TEXT NOT NULL,
        questions INTEGER DEFAULT 4
       )''');
      } catch (err) {
        if (err.toString().contains('DatabaseException') == true) {
          print(err.toString());
          return 'No';
        }
        //print(err.toString().substring(0,30));
      }
    }
      return 'Ok';







  }

  Future<void> AddtoDb() async {

    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    int age=int.parse(ageController.text);
    String line=''' '${nameController.text}', $age , 100, '${widget.testName}', ${getQuestNum(theSelected[0])}  ''';
    String insertString =
    '''INSERT INTO datatable ( qaryname, qaryage, degree, testname, questions) VALUES ( ${line} )''';
    print(insertString);
    await db.execute(insertString);

  }


  Future<void> GetFromDb(String tname) async{
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    List<Map<String,dynamic>>? gotlist =
    await db.database.rawQuery('''SELECT * FROM datatable WHERE testname='${tname}' ''');
    print(gotlist);
    print(gotlist.length);
    if(gotlist.isNotEmpty){

      QaryList.clear();

    setState(() {
      gotlist.forEach((e) {
        {
          //QaryList.add(QaryData.fromJson(e));
          //int qn=getQuestNum(theSelected[0]);
         QaryList.add(QaryData.fromFields(e['qaryname'],e['qaryage'],e['degree'],e['testname'], e['questions']  ));
      };
    });
    print(QaryList);
  });}
}

  Future<void> ClearDb() async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    await db.database.rawQuery('DELETE FROM datatable');
    setState(() {

    });

  }


  Future<void> DelSrowFromDb(String qname,String tname) async {

    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    await db.rawDelete('DELETE FROM datatable WHERE qaryname = ? AND testname = ?',[qname,tname]);




  }

  int getQuestNum(bool theInput){
    if(theInput==true){return 4;}
    else{return 5;}

  }



}
