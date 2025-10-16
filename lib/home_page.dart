import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:ykos_kitchen/model/adress_symbol.dart';
import 'package:ykos_kitchen/model/category.dart';
import 'package:ykos_kitchen/model/extra.dart';
import 'package:ykos_kitchen/repository/time_repository.dart';
import 'package:ykos_kitchen/theme/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ykos_kitchen/enum/order_status_enum.dart';
import 'package:ykos_kitchen/model/adress.dart';
import 'package:ykos_kitchen/model/order_summary.dart';
import 'package:ykos_kitchen/model/payment.dart';
import 'package:ykos_kitchen/model/user.dart';
import 'package:ykos_kitchen/model/food.dart';
import 'package:ykos_kitchen/enum/category_enum.dart';
import 'package:ykos_kitchen/model/order.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var timeRepo = TimeRepository();

  @override
  Widget build(BuildContext context) {
    final List<Order> dummyOrdersNew = [
      // 🧾 1️⃣ Lieferung – Bestellung eingegangen
      Order(
        pickUpUser: null,
        isDelivery: true,
        deliveryAdress: Adress(
          name: "Mara Herrmann",
          telefon: "0176543524",
          street: "Müllerstraße",
          houseNumber: "12a",
          plz: "13437",
          place: "Berlin",
          icon: AdressSymbol(name: "Home", iconData: Icons.home),
          information: "bitte nicht klingeln ich komme denn runter",
        ),
        selectedTime: TimeOfDay(hour: 17, minute: 45),
        selectedDate: DateTime.now(),
        payment: Payment(name: "Apple Pay", img: "assets/images/applepay.png"),
        orderSummary: OrderSummary(
          foods: [
            Food(
              id: "f6",
              name: "Pizza Margherita",
              price: 6.90,
              extras: [
                Extra(
                  name: "Peperoni",
                  price: 1.50,
                  extraCategory: CategoryEnum.pizza,
                ),
              ],
              artikelNr: '0001',
              description: 'salat mit essif',
              imgAsset: 'lib/img/pizza4.png',
              labels: ["lib/img/peper.png"],
              allergens: ["A", "D"],
              category: Category(
                name: CategoryEnum.pizza.label,
                categoryImg: "lib/img/pizza_category_icon.png",
              ),
            ),
          ],
        ),
        orderStatus: OrderStatusEnum.delivered,
      ),

      Order(
        pickUpUser: User(
          name: "Tom",
          lastName: "Riddle",
          telefon: "0165234589",
        ),
        isDelivery: false,
        deliveryAdress: null,
        selectedTime: TimeOfDay(hour: 17, minute: 45),
        selectedDate: DateTime.now(),
        payment: Payment(name: "Apple Pay", img: "assets/images/applepay.png"),
        orderSummary: OrderSummary(
          foods: [
            Food(
              id: "f6",
              name: "Pizza Margherita",
              price: 6.90,
              extras: [
                Extra(
                  name: "Peperoni",
                  price: 1.50,
                  extraCategory: CategoryEnum.pizza,
                ),
              ],
              artikelNr: '0001',
              description: 'salat mit essif',
              imgAsset: 'lib/img/pizza4.png',
              labels: ["lib/img/peper.png"],
              allergens: ["A", "D"],
              category: Category(
                name: CategoryEnum.pizza.label,
                categoryImg: "lib/img/pizza_category_icon.png",
              ),
            ),
          ],
        ),
        orderStatus: OrderStatusEnum.recieved,
      ),
    ];

    final List<Order> dummyOrdersProgress = [];
    final List<Order> dummyOrdersOnWay = [];
    final List<Order> dummyOrdersDelivered = [];
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
            orderProgressTitle("NEU", dummyOrdersNew.length),
            listView(dummyOrdersNew, "Neue Aufträge hier!"),

            //Progress Orders (KÜCHE)
            orderProgressTitle("KÜCHE", dummyOrdersProgress.length),
            listView(
              dummyOrdersProgress,
              "Hier werden die Gerichte von der Bestellung zubereitet.",
            ),

            //OnWay Orders
            orderProgressTitle("UNTERWEGS", dummyOrdersOnWay.length),
            listView(dummyOrdersOnWay, "Die Bestellungen sind hier Unterwegs."),

            //Delivered Orders
            orderProgressTitle("GELIEFERT", dummyOrdersDelivered.length),
            listView(
              dummyOrdersDelivered,
              "Alle gelieferten Bestellungen befinden sich hier.",
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  ListView listView(List<Order> list, String dottedBoxText) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.isNotEmpty ? list.length : 1,
      itemBuilder: (context, index) {
        if (list.isEmpty) {
          return dottedBox(dottedBoxText);
        } else {
          final order = list[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: orderedItem(order, context),
          );
        }
      },
    );
  }

  Container orderedItem(Order order, BuildContext context) {
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
                repeat: true,
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
                timeRepo.dateDayMonthYearToString(order.selectedDate),
                SizedBox(width: 10),
                timeRepo.timeToString(order.selectedTime, context),
              ],
            ),
          ),

          Row(
            children: [
              Visibility(
                visible: true,
                child: arrowIconButton(() {
                  setState(() {
                    print("UP Button");
                  });
                }, Icons.arrow_drop_up_rounded),
              ),
              SizedBox(width: 30),
              Visibility(
                visible: true,
                child: arrowIconButton(() {
                  setState(() {
                    print("Down Button");
                  });
                }, Icons.arrow_drop_down_rounded),
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
