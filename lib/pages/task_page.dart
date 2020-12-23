import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider.builder(
        options: CarouselOptions(
          height: double.infinity,
          reverse: false,
          enableInfiniteScroll: false,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.amber,
            width: double.infinity,
            child: Text(index.toString()),
          );
        },
      ),
    );
  }
}
