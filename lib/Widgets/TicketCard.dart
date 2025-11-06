import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticksy_web/Controllers/HomeController.dart';
import 'package:ticksy_web/Models/Ticket.dart';

class TicketCard extends StatefulWidget {
  final int ticketIndex;
  const TicketCard({super.key, required this.ticketIndex});

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  final HomeController hmController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    // Access ticket object directly from controller’s list
    final Ticket ticket = hmController.selectedList[widget.ticketIndex];

    return GetBuilder<HomeController>(
      builder: (homeController) {
        return InkWell(
          onTap: () {
            hmController.setSelectedTicketId(ticket.id);
            hmController.update();
          },
          child: Container(
            width: Get.width / 3.71,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            padding: EdgeInsets.symmetric(
              vertical: Get.height / 38.75,
              horizontal: Get.width / 57.6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ───── Row 1: Icon + Date ─────
                Row(
                  children: [
                    Container(
                      width: Get.width / 36,
                      height: Get.height / 27,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    SizedBox(width: Get.width / 144),
                    Text(
                      "ticket.userId", // Or display staff name if available
                      style: GoogleFonts.alexandria(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      ticket.createdAt.toString().substring(0, 10),
                      style: GoogleFonts.alexandria(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Get.height / 98),

                // ───── Subject ─────
                Text(
                  ticket.subject,
                  style: GoogleFonts.alexandria(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: Get.height / 49),

                // ───── Tags: Status / Priority / Department ─────
                Row(
                  children: [
                    _buildTag(ticket.status),
                    SizedBox(width: Get.width / 288),
                    _buildTag(ticket.priority),
                    SizedBox(width: Get.width / 288),
                    _buildTag(ticket.department),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget for small tags
  Widget _buildTag(String text) {
    return Container(
      height: Get.height / 45,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.alexandria(fontSize: 8, fontWeight: FontWeight.w400),
      ),
    );
  }
}
