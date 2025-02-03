import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/adminPart/core/contant/appColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
                Text(
                  'UserList',
                  style: GoogleFonts.robotoSerif(
                    letterSpacing: 2,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Users Found"));
          }

          var users = snapshot.data!.docs;

          return Column(
            children: [
              // First Container: Show Total Users
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColor.theme.withOpacity(0.5), // App Theme Color
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    "Total Users: ${users.length}",
                    style: GoogleFonts.acme(
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),

              // ListView.builder for Users List
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    return Center(
                      // Ensure the container is centered
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.5, // Constrain width
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Index and Email
                              Text(
                                "${index + 1}. ${user['email']}",
                                style: GoogleFonts.acme(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),

                              // Payment Container
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(Icons.check,
                                    color: AppColor.theme, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
