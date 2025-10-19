import 'package:flutter/material.dart';
import 'package:ykos_kitchen/model/order.dart';
import 'package:ykos_kitchen/theme/colors.dart';
import 'package:ykos_kitchen/repository/time_repository.dart';

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
      title: const Text(
        "Neue Bestellung eingegangen",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.order.isDelivery ? "🚗 Lieferung" : "👜 Abholung"),
            const SizedBox(height: 10),
            if (widget.order.isDelivery && widget.order.deliveryAdress != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("👤 ${widget.order.deliveryAdress!.name}"),
                  Text(widget.order.deliveryAdress!.telefon),
                  Text(
                    "${widget.order.deliveryAdress!.street} ${widget.order.deliveryAdress!.houseNumber}",
                  ),
                  Text(
                    "${widget.order.deliveryAdress!.plz} ${widget.order.deliveryAdress!.place}",
                  ),
                ],
              )
            else if (!widget.order.isDelivery &&
                widget.order.pickUpUser != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "👤 ${widget.order.pickUpUser!.name} ${widget.order.pickUpUser!.lastName}",
                  ),
                  Text(widget.order.pickUpUser!.telefon),
                ],
              ),
            const SizedBox(height: 10),
            Text("🕓 Kunde erwartet: $deliveryTimeText"),
            const SizedBox(height: 20),

            // 🔹 Anpassbare Vorbereitungszeit
            Center(
              child: Column(
                children: [
                  const Text(
                    "⏱ Zubereitungszeit anpassen",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _adjustTime(-5),
                      ),
                      Text(
                        "${prepareTime.hour.toString().padLeft(2, '0')}:${prepareTime.minute.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => _adjustTime(5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text("💳 Zahlung: ${widget.order.payment.name}"),
            const SizedBox(height: 5),
            Text("📦 ${widget.order.orderSummary.foods.length} Artikel"),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => widget.onConfirm(prepareTime),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text("Bestätigen"),
        ),
      ],
    );
  }
}
