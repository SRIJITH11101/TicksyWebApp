import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ticksy_web/ApiCalls/ApiRequests.dart';
import 'package:ticksy_web/Controllers/ChatController.dart';
import 'package:ticksy_web/Models/Ticket.dart';

class HomeController extends GetxController {
  final authStorage = GetStorage();
  final api = ApiRequests();
  final TextEditingController searchController = TextEditingController();
  bool isTicketFetching = false;
  List<Ticket> allTickets = [];
  List<Ticket> selectedList = [];
  int ticketListSize = 7;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadTickets();
  }

  Future<void> loadTickets() async {
    isTicketFetching = true;
    update();
    allTickets = await api.fetchUserTickets(
      authStorage.read('department'),
      authStorage.read('accessToken'),
    );
    selectedList = allTickets;
    isTicketFetching = false;
    update();
  }

  Future<void> reloadTickets() async {
    await loadTickets();
  }

  String selectedTicketId = "";
  void setSelectedTicketId(String id) {
    selectedTicketId = id;
    print("ticket id: $id .....................");

    // Dispose old ChatController if any
    if (Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>();
    }
    // Initialize new ChatController with selected ticket
    ChatController chController = Get.put(ChatController(ticketId: id));
    chController.isLoading.value = false;
    chController.update();
    update();
  }

  Future<void> searchTicket() async {
    isTicketFetching = true;
    update();
    selectedList = await api.searchTicket(
      searchController.text.trim(),
      authStorage.read('accessToken'),
    );
    isTicketFetching = false;
    update();
  }

  // final List<Map<String, dynamic>> allTickets = [
  //   {
  //     "ticketId": "TCKT001",
  //     "ticketName": "Failed Online Transaction",
  //     "ticketDescription":
  //         "Customer reports failed UPI payment but amount debited.",
  //     "ticketStatus": "New",
  //     "ticketPriority": "High",
  //     "ticketDepartment": "Payments",
  //     "creationTime": "2025-08-20 10:15:00",
  //     "lastUpdatedTime": "2025-08-20 10:15:00",
  //   },
  //   {
  //     "ticketId": "TCKT002",
  //     "ticketName": "ATM Cash Not Dispensed",
  //     "ticketDescription":
  //         "ATM did not dispense cash, amount deducted from account.",
  //     "ticketStatus": "Ongoing",
  //     "ticketPriority": "High",
  //     "ticketDepartment": "ATM Services",
  //     "creationTime": "2025-08-19 09:45:00",
  //     "lastUpdatedTime": "2025-08-20 11:30:00",
  //   },
  //   {
  //     "ticketId": "TCKT003",
  //     "ticketName": "Update Contact Number",
  //     "ticketDescription": "Customer requested mobile number update.",
  //     "ticketStatus": "Closed",
  //     "ticketPriority": "Low",
  //     "ticketDepartment": "Customer Support",
  //     "creationTime": "2025-08-18 14:20:00",
  //     "lastUpdatedTime": "2025-08-19 12:10:00",
  //   },
  //   {
  //     "ticketId": "TCKT004",
  //     "ticketName": "Credit Card Limit Increase",
  //     "ticketDescription":
  //         "Request for increasing credit card limit due to higher usage.",
  //     "ticketStatus": "Ongoing",
  //     "ticketPriority": "Medium",
  //     "ticketDepartment": "Credit Cards",
  //     "creationTime": "2025-08-17 16:50:00",
  //     "lastUpdatedTime": "2025-08-20 13:00:00",
  //   },
  //   {
  //     "ticketId": "TCKT005",
  //     "ticketName": "Cheque Clearance Delay",
  //     "ticketDescription":
  //         "Cheque deposited but not cleared for more than 3 working days.",
  //     "ticketStatus": "New",
  //     "ticketPriority": "Medium",
  //     "ticketDepartment": "Branch Operations",
  //     "creationTime": "2025-08-21 09:30:00",
  //     "lastUpdatedTime": "2025-08-21 09:30:00",
  //   },
  //   {
  //     "ticketId": "TCKT006",
  //     "ticketName": "NetBanking Login Issue",
  //     "ticketDescription":
  //         "Customer unable to login to netbanking with correct credentials.",
  //     "ticketStatus": "Ongoing",
  //     "ticketPriority": "High",
  //     "ticketDepartment": "IT Support",
  //     "creationTime": "2025-08-20 18:40:00",
  //     "lastUpdatedTime": "2025-08-21 08:20:00",
  //   },
  //   {
  //     "ticketId": "TCKT007",
  //     "ticketName": "Debit Card Block Request",
  //     "ticketDescription":
  //         "Lost debit card, customer requested to block immediately.",
  //     "ticketStatus": "Closed",
  //     "ticketPriority": "High",
  //     "ticketDepartment": "Card Services",
  //     "creationTime": "2025-08-19 11:25:00",
  //     "lastUpdatedTime": "2025-08-19 11:40:00",
  //   },
  //   {
  //     "ticketId": "TCKT008",
  //     "ticketName": "Loan Prepayment Inquiry",
  //     "ticketDescription":
  //         "Customer requested details about loan prepayment penalties.",
  //     "ticketStatus": "New",
  //     "ticketPriority": "Low",
  //     "ticketDepartment": "Loans",
  //     "creationTime": "2025-08-21 12:10:00",
  //     "lastUpdatedTime": "2025-08-21 12:10:00",
  //   },
  //   {
  //     "ticketId": "TCKT009",
  //     "ticketName": "Wrong Beneficiary Transfer",
  //     "ticketDescription":
  //         "Funds transferred to wrong account due to incorrect IFSC.",
  //     "ticketStatus": "Ongoing",
  //     "ticketPriority": "High",
  //     "ticketDepartment": "Payments",
  //     "creationTime": "2025-08-20 15:30:00",
  //     "lastUpdatedTime": "2025-08-21 09:15:00",
  //   },
  //   {
  //     "ticketId": "TCKT010",
  //     "ticketName": "Passbook Printing Request",
  //     "ticketDescription":
  //         "Customer requested for updated passbook printing at branch.",
  //     "ticketStatus": "Closed",
  //     "ticketPriority": "Low",
  //     "ticketDepartment": "Branch Operations",
  //     "creationTime": "2025-08-18 10:00:00",
  //     "lastUpdatedTime": "2025-08-18 15:30:00",
  //   },
  // ];
}
