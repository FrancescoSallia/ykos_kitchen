import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ykos_kitchen/Page/order_detail_page.dart';
import 'package:ykos_kitchen/repository/time_repository.dart';
import 'package:ykos_kitchen/theme/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ykos_kitchen/enum/order_status_enum.dart';
import 'package:ykos_kitchen/model/order.dart';
import 'package:ykos_kitchen/viewmodel/viewmodel_orders.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var timeRepo = TimeRepository();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModelOrders = context.read<ViewmodelOrders>();
      if (viewModelOrders.error != null) {
        AnimatedSnackBar.material(
          viewModelOrders.error.toString(),
          type: AnimatedSnackBarType.error,
        ).show(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModelOrders = context.watch<ViewmodelOrders>();

    if (viewModelOrders.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AnimatedSnackBar.material(
          viewModelOrders.error!,
          type: AnimatedSnackBarType.error,
        ).show(context);
        viewModelOrders.clearError(); // Error zurücksetzen.
      });
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: Image.asset("lib/img/logo_ykos.png"),
              ),
            ),
            SizedBox(width: 5),
            SizedBox(
              height: 70,
              width: 70,
              child: Image.asset("lib/img/ykos_title.png"),
            ),
          ],
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        width: 300,
        backgroundColor: AppColors.primary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings_outlined),
              onTap: () {},
            ),
            ListTile(
              title: Text("Adress"),
              // trailing: Icon(AdressEnum.suit.label),
              onTap: () {},
            ),
            ListTile(
              title: Text("Clear Orders"),
              // trailing: Icon(AdressEnum.suit.label),
              onTap: () {
                final dialog = AlertDialog(
                  title: Text("Alle Bestellungen wirklich löschen?"),
                  content: Text("Alle Bestellungen werden gelöscht."),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        final lists = viewModelOrders.orderLists;

                        await Future.wait([
                          viewModelOrders.clearListsFromDB(
                            lists[OrderStatusEnum.recieved],
                          ),
                          viewModelOrders.clearListsFromDB(
                            lists[OrderStatusEnum.inProgress],
                          ),
                          viewModelOrders.clearListsFromDB(
                            lists[OrderStatusEnum.onWay],
                          ),
                          viewModelOrders.clearListsFromDB(
                            lists[OrderStatusEnum.delivered],
                          ),
                          viewModelOrders.clearListsFromDB(
                            lists[OrderStatusEnum.ready],
                          ),
                        ]);
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Ja, löschen",
                        style: GoogleFonts.inter(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Abbrechen",
                        style: GoogleFonts.inter(color: Colors.black),
                      ),
                    ),
                  ],
                );
                showDialog(context: context, builder: (context) => dialog);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            subTitle(),
            Divider(thickness: 2, height: 0, color: Colors.grey),

            //New Orders
            orderProgressTitle(
              "NEU",
              viewModelOrders.orderLists[OrderStatusEnum.recieved]?.length ?? 0,
            ),
            listView(
              viewModelOrders.orderLists[OrderStatusEnum.recieved] ?? [],
              "Neue Aufträge hier!",
            ),

            //Progress Orders (KÜCHE)
            orderProgressTitle(
              "KÜCHE",
              viewModelOrders.orderLists[OrderStatusEnum.inProgress]?.length ??
                  0,
            ),
            listView(
              viewModelOrders.orderLists[OrderStatusEnum.inProgress] ?? [],
              "Hier werden die Gerichte von der Bestellung zubereitet.",
            ),

            //OnWay Orders
            orderProgressTitle(
              "UNTERWEGS",
              viewModelOrders.orderLists[OrderStatusEnum.onWay]?.length ?? 0,
            ),
            listView(
              viewModelOrders.orderLists[OrderStatusEnum.onWay] ?? [],
              "Die Bestellungen sind hier Unterwegs.",
            ),

            //Delivered Orders
            orderProgressTitle(
              "GELIEFERT",
              viewModelOrders.orderLists[OrderStatusEnum.delivered]?.length ??
                  0,
            ),
            listView(
              viewModelOrders.orderLists[OrderStatusEnum.delivered] ?? [],
              "Alle gelieferten Bestellungen befinden sich hier.",
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  ListView listView(List<Order> list, String dottedBoxText) {
    // Sortiere die Liste nach Datum und Zeit (älteste zuerst)
    list.sort((a, b) {
      final aDateTime = DateTime(
        a.selectedDate?.year ?? 0,
        a.selectedDate?.month ?? 0,
        a.selectedDate?.day ?? 0,
        a.selectedTime?.hour ?? 0,
        a.selectedTime?.minute ?? 0,
      );

      final bDateTime = DateTime(
        b.selectedDate?.year ?? 0,
        b.selectedDate?.month ?? 0,
        b.selectedDate?.day ?? 0,
        b.selectedTime?.hour ?? 0,
        b.selectedTime?.minute ?? 0,
      );

      return aDateTime.compareTo(bDateTime);
    });

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      reverse: false,
      itemCount: list.isNotEmpty ? list.length : 1,
      itemBuilder: (context, index) {
        if (list.isEmpty) {
          return dottedBox(dottedBoxText);
        } else {
          final order = list[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => OrderDetailPage(order: order),
                  ),
                );
              },
              child: orderedItem(
                order,
                context,
                () {
                  context.read<ViewmodelOrders>().moveOrderBackward(order);
                },
                () {
                  context.read<ViewmodelOrders>().moveOrderForward(order);
                },
              ),
            ),
          );
        }
      },
    );
  }

  Container orderedItem(
    Order order,
    BuildContext context,
    Function() arrowUpOnTap,
    Function() arrowDownOnTap,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Lottie.asset(
                animate: true,
                order.orderStatus.lottieAnimation,
                repeat: false,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Bestellt am: "),
                    timeRepo.dateDayMonthYearToString(order.currentDate),
                    SizedBox(width: 10),
                    timeRepo.timeToString(order.currentTime, context),
                  ],
                ),
                Text(
                  order.isDelivery
                      ? order.deliveryAdress!.name
                      : "${order.pickUpUser?.name} ${order.pickUpUser?.lastName}",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                Text(
                  order.isDelivery ? "Lieferung" : "Abholung",
                  style: GoogleFonts.inter(
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  order.isDelivery ? "Zustellung" : "Abholung",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                Visibility(
                  visible: true,
                  child: timeRepo.dateLabelOrFormatted(order.selectedDate),
                ),
                SizedBox(width: 10),
                timeRepo.timeToString(
                  order.selectedTime ?? order.fastDeliveryTime,
                  context,
                ),
              ],
            ),
          ),

          Row(
            children: [
              Visibility(
                visible: order.orderStatus != OrderStatusEnum.recieved
                    ? true
                    : false,
                child: arrowIconButton(
                  arrowUpOnTap,
                  Icons.arrow_drop_up_rounded,
                ),
              ),
              SizedBox(width: 30),
              Visibility(
                visible: order.orderStatus != OrderStatusEnum.delivered
                    ? true
                    : false,
                child: arrowIconButton(
                  arrowDownOnTap,
                  Icons.arrow_drop_down_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Material arrowIconButton(Function() onTap, IconData iconData) {
    return Material(
      color: Colors.amber, // Hintergrundfarbe
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(iconData, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  Padding dottedBox(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: DottedBorder(
        options: RectDottedBorderOptions(
          color: Colors.grey,
          dashPattern: [3, 2],
          strokeWidth: 2,
          padding: EdgeInsets.symmetric(vertical: 60),
        ),
        child: Center(
          child: Text(
            description,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }

  Padding orderProgressTitle(String title, int amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Text(
        "$title ($amount)",
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 32, 88, 119),
          fontSize: 17,
        ),
      ),
    );
  }

  Container subTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 16, left: 15),
            child: Text(
              "HEUTIGE BESTELLUNGEN",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: AppColors.timerPrimary2,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
