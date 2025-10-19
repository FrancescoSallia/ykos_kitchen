import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ykos_kitchen/components/complete_orders.dart';
import 'package:ykos_kitchen/components/summary_box.dart';
import 'package:ykos_kitchen/components/user_information_box.dart';
import 'package:ykos_kitchen/model/order.dart';
import 'package:ykos_kitchen/repository/time_repository.dart';
import 'package:ykos_kitchen/theme/colors.dart';
import 'package:ykos_kitchen/viewmodel/viewmodel_orders.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;
  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late TimeOfDay prepareTime;
  late TimeOfDay originalPrepareTime;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ViewmodelOrders>();
    });
    // Startzeit: jetzt + 45 Minuten (oder aus fastDeliveryTime falls vorhanden)
    prepareTime =
        // widget.initialPrepareTime ??
        widget.order.fastDeliveryTime ??
        widget.order.selectedTime ??
        TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 45)));

    // Ursprüngliche Zeit merken
    originalPrepareTime = prepareTime;
    super.initState();
  }

  bool _isTimeChanged() {
    return prepareTime.hour != originalPrepareTime.hour ||
        prepareTime.minute != originalPrepareTime.minute;
  }

  void _adjustTime(int minutes) {
    final now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      prepareTime.hour,
      prepareTime.minute,
    ).add(Duration(minutes: minutes));

    setState(() {
      prepareTime = TimeOfDay.fromDateTime(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModelOrder = context.watch<ViewmodelOrders>();
    final order = widget.order;
    final timeRepo = TimeRepository();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Timer",
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(preferredSize: Size(0, 5), child: Divider()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bestellung:",
                  style: GoogleFonts.inter(
                    color: AppColors.timerTextPrimary,
                    fontSize: 22,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "#${order.orderId.substring(0, 13)}",
                  style: GoogleFonts.inter(color: Colors.black, fontSize: 22),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  order.isDelivery ? "Ankunft:" : "Abholung:",
                  style: GoogleFonts.inter(color: Colors.black, fontSize: 18),
                ),
                SizedBox(width: 10),
                Text(
                  order.isDelivery
                      ? order.selectedTime != null && order.selectedDate != null
                            ? "${timeRepo.dateDayMonthYearToString(order.selectedDate).data} - ca. ${timeRepo.timeToString(order.selectedTime, context).data}"
                            : "Heute - ca. ${timeRepo.timeToString(order.selectedTime ?? order.fastDeliveryTime, context).data}"
                      : "${timeRepo.dateDayMonthYearToString(order.selectedDate).data} - ${timeRepo.timeToString(order.selectedTime, context).data}",
                  style: GoogleFonts.inter(
                    color: AppColors.timerTextPrimary,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Center(
              child: Text(
                order.isDelivery ? "Liefer-Information" : "Abholer/in",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          UserInformationBox(order: order),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Center(
              child: Text(
                "Deine Bestellung",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          CompleteOrders(order: order),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2, color: Colors.green),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Zahlungsmethode:",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset(order.payment.img),
                    ),
                    Text(
                      widget.order.payment.name,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30),

          Text(
            order.isDelivery ? "⏱ Lieferzeit anpassen" : "⏱ Abholzeit anpassen",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => _adjustTime(-5),
                iconSize: 30,
              ),
              Text(
                "${prepareTime.hour.toString().padLeft(2, '0')}:${prepareTime.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _adjustTime(5),
                iconSize: 30,
              ),
            ],
          ),
          SizedBox(height: 25),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              elevation: 2,
              shadowColor: Colors.black,
              backgroundColor: _isTimeChanged()
                  ? AppColors.primaryButton
                  : Colors.black.withValues(alpha: 0.1),
            ),
            onPressed: _isTimeChanged()
                ? () async {
                    await viewModelOrder.updateOrder(
                      widget.order.copyWith(selectedTime: prepareTime),
                    );

                    // Update die Originalzeit nach dem Speichern
                    setState(() {
                      originalPrepareTime = prepareTime;
                    });
                  }
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "Aktualisieren",
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                const Icon(Icons.timer, size: 30, color: Colors.white),
              ],
            ),
          ),
          SummaryBox(orderSummary: order.orderSummary),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
