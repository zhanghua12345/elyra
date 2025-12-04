import 'package:elyra/page/test/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final logic = Get.put(TestController());
  final state = Get.find<TestController>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
