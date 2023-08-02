import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BikesList extends StatefulWidget {
  const BikesList({super.key});

  @override
  State<BikesList> createState() => _BikesListState();
}

class _BikesListState extends State<BikesList> {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  DateFormat format = DateFormat.y();

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Text("tesbdyfvbs"),
    // );
    return StreamBuilder(
      stream: firestoreInstance.collection("bikedetails").snapshots(),
      builder: (context, snapshot) {
        // return Container(
        //   child: Text("tesbdyfvbs"),
        // );
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final bikeDocs = snapshot.data!.docs;
        print(bikeDocs);
        return ListView.builder(
          itemCount: bikeDocs.length,
          // itemCount: 2,
          itemBuilder: (context, index) {
            final bikeData = bikeDocs[index].data();
            final name = bikeData['name'];
            final mileage = bikeData['milleage'];
            final company = bikeData['company'];
            final m_year = bikeData['years'];
            Timestamp myear = bikeData['m_year'];
            DateTime year1 = myear.toDate();
            final year = year1.year.toString();
            final condition = (mileage > 15 && m_year < 5)
                ? "Good"
                : (mileage <= 15 && m_year <= 5)
                    ? "Moderate"
                    : "Bad";
            return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                // color: Colors.amber,
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              child: Column(
                children: [
                  // Container(
                  //   height: 50,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //       // image: DecorationImage(
                  //       //   image: NetworkImage(
                  //       //     bikeData['image'],
                  //       //   ),
                  //       // ),
                  //       ),
                  // ),
                  Stack(
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // color: Colors.amber,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              bikeData['image'],
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                              color: (condition == "Good")
                                  ? Colors.green
                                  : (condition == "Moderate")
                                      ? Colors.amber
                                      : Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          child: Text(
                            condition,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    // height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        company + " " + name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      subtitle: Text('Mileage: $mileage km/ltr'),
                      trailing: Text(
                        'Year: $year',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );

            // return ListTile(
            //   title: Text(name),
            //   subtitle: Text('Mileage: $mileage km/l'),
            //   trailing: Text('Year: $manufacturingYear'),
            // );
          },
        );
      },
    );
  }
}
