import 'package:canteen_app/Authentications/dashboard.dart';
import 'package:canteen_app/CommonScreens/all.dart';
import 'package:canteen_app/CommonScreens/homeView.dart';
import 'package:canteen_app/CommonScreens/notifications.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:canteen_app/Services/signin.dart';
import 'package:canteen_app/Users/addFeedback.dart';
import 'package:canteen_app/Users/cart.dart';
import 'package:canteen_app/Users/myOrders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  var selectedItem = -1;
  List<String> username = new List();
  AuthService _auth = new AuthService();
  int counter=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username=name.split(' ');
    counter=0;
    checkForCart();
  }
  
  Future<void> checkForCart() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('cart')
        .snapshots()
        .listen((event) {
      setState(() {
        counter = event.docs.length;
      });
    });
  }


  Widget getDrawerItem(IconData icon, String name, int pos,{var tags,ind}) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          selectedItem = pos;
        });
        if(tags!=null){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => tags));
        } else if(ind == "log"){
          showDialog(context: context,
            builder: (context)=>AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Confirmation", style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold)),
              content: Text(
                "Are you sure you want to logout?",
                style: TextStyle(color:Colors.black),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    "Yes",
                    style: TextStyle(color:Colors.blue,),
                  ),
                  onPressed: () async{
                    phn=null;
                    await _auth.signOutGoogle();
                    await _auth.signOut();
                    await _auth.signOutFB();
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Dashboard();
                          },
                        ), (route) => false);
                  },
                ),
                FlatButton(
                  child: Text("No", style: TextStyle(color:Colors.blue,)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if(ind =="home"){
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(
                builder: (context) {
                  return HomeView();
                },
              ), (route) => false);
        }
      },
      child: Container(
        color: selectedItem == pos ? Color(0XFFF2ECFD) : Colors.white,
        padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(
          children: <Widget>[
            Icon(icon,size: 20,),
            //SvgPicture.asset(icon, width: 20, height: 20),
            SizedBox(width: 20),
            text2(name,
                textColor:
                selectedItem == pos ? Color(0XFF5959fc) : Color(0XFF212121),
                fontSize: 18.0,
                fontFamily: 'Medium')
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        elevation: 8,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 30, right: 10),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 40, 20, 40),
                      decoration: new BoxDecoration(
                          color: Color(0XFF5959fc),
                          borderRadius: new BorderRadius.only(
                              bottomRight: const Radius.circular(24.0),
                              topRight: const Radius.circular(24.0))),
                      /*User Profile*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                              backgroundImage: NetworkImage(profileimg),
                              radius: 40),
                          SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: text1(name,
                                        textColor: Colors.white,
                                        fontFamily: 'Medium',
                                        fontSize: 20.0),
                                  ),
                                  SizedBox(height: 8),
                                  text(phn.toString(),
                                      textColor: Colors.white,
                                      fontSize: 14.0),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(height: 30),
                getDrawerItem( Icons.dashboard,"Home", 1,ind: "home"),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem( Icons.shopping_cart,"Your Cart", 2,tags: Cart(length: counter,)),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.food_bank_sharp, "All Categories", 3,tags: AllCat()),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.dinner_dining, "My Orders", 4,tags: MyordersScreen()),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                //getDrawerItem(Icons.history, "History", 4),
                getDrawerItem(Icons.notifications_active, "Notifications", 5,tags: Notifications()),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.feedback, "Feedback", 6,tags: AddFeedback()),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.logout, "Logout", 7,ind: "log"),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                SizedBox(height: 30),
                //Divider(color: Color(0XFFDADADA), height: 1),
                SizedBox(height: 30),
                // getDrawerItem(t2_share, t2_lbl_share_and_invite, 6),
                // getDrawerItem(t2_help, t2_lbl_help_and_feedback, 7),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
