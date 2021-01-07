import 'package:carousel_slider/carousel_slider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:task/model/cardModel.dart';
import 'package:task/pages/card_information_page.dart';
import 'package:task/service/database_service.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int currentPageIndex = 1;
  int totalPageCount = 3;
  List<int> totalTask = List(3);
  String teknikUzman;
  String tahminiSure;
  String gerceklesenSure;
  String isinAciklamasi;
  String notlar;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    totalTask[0] = 0;
    totalTask[1] = 0;
    totalTask[2] = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Task Board"),
        centerTitle: true,
        backgroundColor: Color(0xff3497b1),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                "$currentPageIndex / $totalPageCount",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Color(0xff3daecc).withOpacity(0.6),
        child: CarouselSlider.builder(
          itemCount: totalPageCount,
          options: CarouselOptions(
            reverse: false,
            height: double.infinity,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                currentPageIndex = index + 1;
              });
            },
          ),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.grey.shade300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      index == 0
                          ? "Backlog"
                          : index == 1
                              ? "Doing"
                              : "Done",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder<List<CardModel>>(
                    future: getCardList(index),
                    builder: (context, result) {
                      return result.hasData
                          ? ListView.separated(
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 5);
                              },
                              shrinkWrap: true,
                              itemCount: result.data.length,
                              itemBuilder: (context, index) {
                                return customCard(index, result);
                              },
                            )
                          : Container();
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButton(
                      onPressed: () => showCustomDialog(index, "add", 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text(
                            "Add Card",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget customCard(int index, AsyncSnapshot<List<CardModel>> result) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => CardInformationPage(index: index))),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Are you sure you want to delete?"),
                    actions: [
                      RaisedButton(
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                        color: Colors.lightGreen,
                        onPressed: () => Navigator.pop(context),
                      ),
                      RaisedButton(
                        child: Text(
                          "Yes",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            deleteCard(result.data[index].id);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconSlideAction(
            caption: 'Update',
            foregroundColor: Colors.white,
            color: Color(0xff3daecc),
            icon: Icons.update,
            onTap: () => showCustomDialog(
                result.data[index].taskId, "update", result.data[index].id),
          ),
        ],
        child: Card(
          color: Colors.white,
          shadowColor: Colors.white,
          elevation: 7,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(result.data[index].isinAciklamasi),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.watch_later,
                          color: Color(0xff3497b1),
                        ),
                        Text(
                          result.data[index].tahminiSure,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xff3497b1),
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Color(0xff3497b1),
                      child: Text(
                        result.data[index].teknikUzman
                            .substring(0, 1)
                            .toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showCustomDialog(int index, String which, int id) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(which == "add" ? "Add A New Card" : "Update Card"),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10);
                },
                itemCount: 5,
                itemBuilder: (context, index) {
                  return TextFormField(
                    onChanged: (entered) {
                      index == 0
                          ? teknikUzman = entered
                          : index == 1
                              ? tahminiSure = entered
                              : index == 2
                                  ? gerceklesenSure = entered
                                  : index == 3
                                      ? isinAciklamasi = entered
                                      : notlar = entered;
                    },
                    decoration: InputDecoration(
                      hintText: index == 0
                          ? "Teknik Uzman"
                          : index == 1
                              ? "Tahmini Süre"
                              : index == 2
                                  ? "Gerçekleşen Süre"
                                  : index == 3
                                      ? "İşin Açıklaması"
                                      : "Notlar",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xff3daecc))),
                    ),
                  );
                },
              ),
            ),
            actions: [
              RaisedButton(
                child: Text(
                  "Kapat",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
                color: Colors.red,
                onPressed: () => Navigator.pop(context),
              ),
              RaisedButton(
                child: Text(
                  "Kaydet",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
                color: Colors.lightGreen,
                onPressed: () {
                  setState(() {
                    saveInformation(index, which, id);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Widget _snackbar(String message, Color color) {
    return Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: color,
      icon: Icon(
        color == Colors.red ? Icons.close : Icons.done,
        size: 28.0,
        color: Colors.white,
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 5),
    )..show(_scaffoldKey.currentState.context);
  }

  void saveInformation(int index, String which, int id) async {
    if (teknikUzman == null ||
        isinAciklamasi == null ||
        tahminiSure == null ||
        notlar == null) {
      _snackbar("Please fill all!", Colors.red);
    } else {
      final instance = Provider.of<DatabaseService>(context, listen: false);
      CardModel cardModel = CardModel(
        teknikUzman: teknikUzman,
        taskId: index,
        tahminiSure: tahminiSure,
        gerceklesenSure: gerceklesenSure,
        isinAciklamasi: isinAciklamasi,
        notlar: notlar,
      );
      await instance.open();
      if (which == "add")
        await instance.addCard(cardModel);
      else
        await instance.updateCard(id, cardModel);
    }
  }

  Future<List<CardModel>> getCardList(int index) async {
    final instance = Provider.of<DatabaseService>(context, listen: false);
    await instance.open();
    List<CardModel> result = await instance.getCardList(index);
    return result;
  }

  deleteCard(int index) async {
    final instance = Provider.of<DatabaseService>(context, listen: false);
    await instance.open();
    print(index);
    bool result = await instance.deleteCard(index);
    if (result)
      _snackbar("Card deleted", Colors.lightGreen);
    else
      _snackbar("The card could not be deleted!", Colors.red);
  }
}
