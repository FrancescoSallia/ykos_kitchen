import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ykos_kitchen/model/order.dart';
import 'package:ykos_kitchen/theme/colors.dart';

class UserInformationBox extends StatelessWidget {
  final Order order;
  const UserInformationBox({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColors.primaryButton),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: order.isDelivery
              ? Column(
                  //Lieferinformation
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.deliveryAdress!.name,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        Text(order.deliveryAdress!.street),
                        SizedBox(width: 5),
                        Text(order.deliveryAdress!.houseNumber),
                      ],
                    ),
                    Row(
                      children: [
                        Text(order.deliveryAdress!.plz),
                        SizedBox(width: 5),
                        Text(order.deliveryAdress!.place),
                      ],
                    ),
                    Text(order.deliveryAdress!.telefon),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kurier- Information:",
                          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Icon(order.deliveryAdress!.icon?.iconData),
                            SizedBox(width: 10),
                            Text(
                              order.deliveryAdress!.icon != null
                                  ? order.deliveryAdress!.icon!.name
                                  : "",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      order.deliveryAdress!.information ?? "",
                      style: GoogleFonts.inter(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ],
                  //Abholer information
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order.pickUpUser!.name,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(width: 5),
                        Text(
                          order.pickUpUser!.lastName,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Text(order.pickUpUser!.telefon),
                  ],
                ),
        ),
      ),
    );
  }
}
