import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ykos_kitchen/enum/category_enum.dart';
import 'package:ykos_kitchen/extension/my_extensions.dart';
import 'package:ykos_kitchen/model/order_summary.dart';
import 'package:ykos_kitchen/theme/colors.dart';

class SummaryBox extends StatelessWidget {
  final OrderSummary orderSummary;

  const SummaryBox({super.key, required this.orderSummary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: orderSummary.discount! > 0 ? true : false,
                child: SizedBox(
                  width: 300,
                  child: Text(
                    "Du hast ein Gutschein in wert von ${orderSummary.discount?.toEuroString()}(in porzent) benutzt",
                    style: GoogleFonts.inter(
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primary.withValues(alpha: 0.3),
            border: Border.all(width: 1, color: AppColors.primaryButton),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Zwischensumme", style: GoogleFonts.inter(fontSize: 14)),
                  Text(
                    "${orderSummary.basisPreis.toStringAsFixed(2)}€",
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ],
              ),
              Visibility(
                visible: orderSummary.deliveryCharge == 0 ? false : true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Liefer-Gebühren",
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    Text(
                      "${orderSummary.deliveryCharge.toStringAsFixed(2)}€",
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                  ],
                ),
              ),

              Visibility(
                visible: orderSummary.discount! > 0 ? true : false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Gutschein (${(orderSummary.discount! * 100).toStringAsFixed(0)}%)",
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    Text(
                      "- ${orderSummary.rabattBetrag.toStringAsFixed(2)}€",
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    //Getränke mwst.
                    "inkl. MwSt. (7%)",
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                  Text(
                    "${orderSummary.essenMwst.toStringAsFixed(2)}€",
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ],
              ),
              Visibility(
                visible: orderSummary.foods.any(
                  (element) =>
                      element.category.name == CategoryEnum.drinks.label,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Getränke mwst.
                    Text(
                      "inkl. MwSt. (19%)",
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    Text(
                      "${orderSummary.getraenkeMwst.toStringAsFixed(2)}€",
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Gesamt",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "${orderSummary.endSummeMitMwSt.toStringAsFixed(2)}€",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
