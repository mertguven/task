import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/model/cardModel.dart';
import 'package:task/service/database_service.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int currentPageIndex = 1;
  int totalPageCount = 3;
  List<int> totalTask = List(3);
  String teknikUzman = "";
  String tahminiSure = "";
  String gerceklesenSure = "";
  String isinAciklamasi = "";
  String notlar = "";

  @override
  void initState() {
    super.initState();
    totalTask[0] = 0;
    totalTask[1] = 0;
    totalTask[2] = 0;
    final response = Provider.of<DatabaseService>(context, listen: false);
    response.open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        color: Color(0xff3daecc),
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
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 5);
                      },
                      shrinkWrap: true,
                      itemCount: totalTask[index],
                      itemBuilder: (context, index) {
                        return customCard(index);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButton(
                      onPressed: () => showCustomDialog(index),
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

  Widget customCard(int index) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.white,
      elevation: 7,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("asdasdasd" * (index + 5)),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(child: Text("MG")),
            ),
          ],
        ),
      ),
    );
  }

  showCustomDialog(int index) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Add A New Card"),
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
                          borderSide: BorderSide(
                            color: Color(0xff3daecc),
                          )),
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
                  /*setState(() {
                    totalTask[index]++;
                  });*/
                  saveInformation();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void saveInformation() async {
    final response = Provider.of<DatabaseService>(context, listen: false);
    CardModel cardModel = CardModel(
      teknikUzman: teknikUzman,
      tahminiSure: tahminiSure,
      gerceklesenSure: gerceklesenSure,
      isinAciklamasi: isinAciklamasi,
      notlar: notlar,
    );
    await response.addCard(cardModel);
  }
}
