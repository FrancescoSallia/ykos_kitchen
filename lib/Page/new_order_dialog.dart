import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ykos_kitchen/components/summary_box.dart';
import 'package:ykos_kitchen/components/user_information_box.dart';
import 'package:ykos_kitchen/extension/my_extensions.dart';
import 'package:ykos_kitchen/model/order.dart';
import 'package:ykos_kitchen/theme/colors.dart';
import 'package:ykos_kitchen/repository/time_repository.dart';
import 'package:flutter_dash/flutter_dash.dart';

class NewOrderDialog extends StatefulWidget {
  final Order order;
  final ValueChanged<TimeOfDay> onConfirm;
  final TimeOfDay? initialPrepareTime;

  const NewOrderDialog({
    super.key,
    required this.order,
    required this.onConfirm,
    required this.initialPrepareTime,
  });

  @override
  State<NewOrderDialog> createState() => _NewOrderDialogState();
}

class _NewOrderDialogState extends State<NewOrderDialog> {
  late TimeOfDay prepareTime;

  @override
  void initState() {
    super.initState();
    // Startzeit: jetzt + 45 Minuten (oder aus fastDeliveryTime falls vorhanden)
    prepareTime =
        widget.initialPrepareTime ??
        widget.order.fastDeliveryTime ??
        TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 45)));
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
    final timeRepo = TimeRepository();

    String deliveryTimeText;
    if (widget.order.selectedTime != null &&
        widget.order.selectedDate != null) {
      deliveryTimeText =
          "${timeRepo.dateDayMonthYearToString(widget.order.selectedDate).data} - ${timeRepo.timeToString(widget.order.selectedTime, context).data}";
    } else if (widget.order.fastDeliveryTime != null) {
      deliveryTimeText =
          "ca. ${widget.order.fastDeliveryTime!.hour.toString().padLeft(2, '0')}:${widget.order.fastDeliveryTime!.minute.toString().padLeft(2, '0')} Uhr";
    } else {
      deliveryTimeText = "Keine Zeit ausgewählt";
    }

    return AlertDialog(
      backgroundColor: AppColors.secondary,
      title: Center(
        child: Text(
          "Neue Bestellung eingegangen",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.order.isDelivery ? "🚗 Lieferung" : "👜 Abholung",
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            // if (widget.order.isDelivery && widget.order.deliveryAdress != null)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text("👤 ${widget.order.deliveryAdress!.name}"),
            //       Text(widget.order.deliveryAdress!.telefon),
            //       Text(
            //         "${widget.order.deliveryAdress!.street} ${widget.order.deliveryAdress!.houseNumber}",
            //       ),
            //       Text(
            //         "${widget.order.deliveryAdress!.plz} ${widget.order.deliveryAdress!.place}",
            //       ),
            //     ],
            //   )
            // else if (!widget.order.isDelivery &&
            //     widget.order.pickUpUser != null)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "👤 ${widget.order.pickUpUser!.name} ${widget.order.pickUpUser!.lastName}",
            //       ),
            //       Text(widget.order.pickUpUser!.telefon),
            //     ],
            //   ),
            UserInformationBox(order: widget.order),
            const SizedBox(height: 20),
            Text(
              "🕓 Kunde erwartet die Bestellung: $deliveryTimeText",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),
            Text(
              "🛒 Kundenbestellung",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Column(
              children: widget.order.orderSummary.foods.map((orderedItem) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${orderedItem.count}x",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                orderedItem.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(orderedItem.price.toEuroString()),
                        ],
                      ),
                      ...?orderedItem.extras?.map(
                        (extra) => Padding(
                          padding: const EdgeInsets.only(left: 25.0, top: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("+ ${extra.name} (${extra.anzahl}x)"),
                              Text(extra.price.toEuroString()),
                            ],
                          ),
                        ),
                      ),
                      if (orderedItem.note != null &&
                          orderedItem.note!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "↳ ${orderedItem.note}",
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                      Dash(length: MediaQuery.of(context).size.width - 168),
                    ],
                  ),
                );
              }).toList(),
            ),

            SummaryBox(orderSummary: widget.order.orderSummary),

            // 🔹 Anpassbare Vorbereitungszeit
            Center(
              child: Column(
                children: [
                  const Text(
                    "⏱ Zubereitungszeit anpassen",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _adjustTime(-5),
                        iconSize: 40,
                      ),
                      Text(
                        "${prepareTime.hour.toString().padLeft(2, '0')}:${prepareTime.minute.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => _adjustTime(5),
                        iconSize: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                  Row(
                    children: [
                      Text(
                        widget.order.payment.name,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(widget.order.payment.img),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // const SizedBox(height: 5),
            // Text("📦 ${widget.order.orderSummary.foods.length} Artikel"),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => widget.onConfirm(prepareTime),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          child: Text(
            "Bestätigen",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
