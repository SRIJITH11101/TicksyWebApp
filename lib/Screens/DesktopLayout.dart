import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticksy_web/Controllers/HomeController.dart';
import 'package:ticksy_web/Widgets/ChatViewWidget.dart';
import 'package:ticksy_web/Widgets/TicketsWidget.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());

    return GetBuilder<HomeController>(
      builder: (homecontroller) {
        return Scaffold(
          body: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width / 48,
                ).copyWith(top: Get.height / 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recent Tickets",
                      style: GoogleFonts.alexandria(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Get.height / 48.76),
                    Container(
                      width: Get.width / 4.21,
                      height: Get.height / 24.4,
                      child: TextField(
                        controller: homecontroller.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {},
                            child: Icon(Icons.filter_list_alt),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height / 48.76),
                    Text(
                      "All Tickets (${homecontroller.allTickets.length})",
                      style: GoogleFonts.alexandria(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Get.height / 24.4),
                    Expanded(
                      child: SizedBox(
                        width: Get.width / 4.21,
                        child: TicketsWidget(),
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(color: Colors.grey, thickness: 1),
              Expanded(
                child: homecontroller.selectedTicketId.isEmpty
                    ? Center(
                        child: Text(
                          "Chats Will be Displaed Here...",
                          style: GoogleFonts.alexandria(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : ChatViewWidget(
                        key: ValueKey(homecontroller.selectedTicketId),
                        width: Get.width / 1.45,
                        height: Get.height / 1.05,
                        ticketId: homecontroller.selectedTicketId,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
