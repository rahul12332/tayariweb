import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/adminPart/view/User.dart';
import 'package:fast_quiz_tayari/adminPart/widgets/drawerContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/contant/appColor.dart';
import '../repo/adminRepo.dart';
import '../widgets/customContainer.dart';
import '../widgets/dailog.dart';
import '../widgets/updateFolder.dart';
import 'mock.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black.withOpacity(0.7),
        title: Row(
          children: [
            Text(
              'Fast Quiz App',
              style: GoogleFonts.robotoSerif(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 400,
            ),
            Expanded(
                child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'Home',
                    style: GoogleFonts.robotoSerif(
                        fontSize: 16, color: Colors.white, letterSpacing: 2),
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'Leaderboard',
                    style: GoogleFonts.robotoSerif(
                      letterSpacing: 2,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'Profile',
                    style: GoogleFonts.robotoSerif(
                        fontSize: 16, color: Colors.white, letterSpacing: 2),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
      body: SafeArea(
        child: Row(
          children: [
            // Left Column
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage("assets/dashboard.jpg"))),
              child: BlurryContainer(
                borderRadius: BorderRadius.circular(0),
                blur: 2,
                color: Colors.white.withOpacity(0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DrawerContainer(
                        name: "Users",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UsersScreen()));
                        }),
                    Spacer(),
                    DrawerContainer(
                      name: "Logout",
                      onTap: () async {
                        await FirebaseRepo.logout(context);
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Divider with custom color
            VerticalDivider(color: Colors.grey.shade100, thickness: 0.5),
            // Right Column
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('series').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No Folders Added'));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return Row(
                        mainAxisSize: MainAxisSize
                            .min, // Ensures it takes only needed space
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.4, // Fixed width
                            child: CustomContainer(
                              text: doc['name'],
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MockList(
                                      subjectName: doc['name'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // Button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      2), // Rounded border
                                ),
                              ),
                              onPressed: () => updateFolder(
                                  docId: doc.id,
                                  currentName: doc['name'],
                                  context: context),
                              child: Icon(Icons.edit,
                                  color:
                                      AppColor.theme), // Icon inside the button
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // Button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      2), // Rounded border
                                ),
                              ),
                              onPressed: () =>
                                  deleteFolder(docId: doc.id, context: context),
                              child: Icon(Icons.delete,
                                  color: AppColor
                                      .redColor), // Icon inside the button
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 100,
        child: FloatingActionButton(
          backgroundColor: AppColor.theme.withOpacity(0.8),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddSubjectDialog(
                onSubjectAdded: () {},
              ),
            );
          },
          child: Icon(Icons.category),
        ),
      ),
    );
  }
}
