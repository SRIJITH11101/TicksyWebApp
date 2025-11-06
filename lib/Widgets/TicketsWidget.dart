import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ticksy_web/Controllers/HomeController.dart';
import 'package:ticksy_web/Widgets/TicketCard.dart';

class TicketsWidget extends StatefulWidget {
  const TicketsWidget({super.key});

  @override
  State<TicketsWidget> createState() => _TicketsWidgetState();
}

class _TicketsWidgetState extends State<TicketsWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (HomeController homecontroller) {
        return homecontroller.isTicketFetching
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: homecontroller.selectedList.length,
                itemBuilder: (context, index) {
                  //final ticket = homecontroller.ticketList[index];
                  return Column(
                    children: [
                      TicketCard(ticketIndex: index),
                      SizedBox(height: Get.height / 54),
                    ],
                  );
                },
              );
      },
    );
  }
}
