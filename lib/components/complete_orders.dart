import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ykos_kitchen/extension/my_extensions.dart';
import 'package:ykos_kitchen/model/order.dart';
import 'package:flutter_dash/flutter_dash.dart';

class CompleteOrders extends StatelessWidget {
  final Order order;
  const CompleteOrders({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: order.orderSummary.foods.length,
      itemBuilder: (context, index) {
        final orderedItem = order.orderSummary.foods[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Text(
                        "${orderedItem.count.toString()}x",
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        orderedItem.name,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Text(
                    orderedItem.price.toEuroString(),
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: orderedItem.extras?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final extra = orderedItem.extras?[index];
                  if (extra == null) return null;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                            ),
                            child: Row(
                              spacing: 10,
                              children: [
                                Text("+ ${extra.name}"),
                                Text("${extra.anzahl.toString()}x"),
                              ],
                            ),
                          ),
                          Text(extra.price.toEuroString()),
                        ],
                      ),
                    ],
                  );
                },
              ),
              Visibility(
                visible: orderedItem.note!.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5),
                  child: Text(
                    orderedItem.note!.isNotEmpty ? "↳ ${orderedItem.note}" : "",
                    style: GoogleFonts.inter(
                      fontStyle: FontStyle.italic,
                      color: Colors.red,
                    ),
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Dash(
                length: MediaQuery.of(context).size.width - 40,
                dashLength: 15,
                dashColor: Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }
}
