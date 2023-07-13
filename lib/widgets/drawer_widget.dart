import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_noteapp/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String? photoUrl;
  String email = '';
  String name = '';

  @override
  void initState() {
    loadString();
    super.initState();
  }

  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Perform any additional operations after logout

      // Navigate to the login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } catch (e) {
      print('Logout Error: $e');
    }
  }

  void loadString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myString = prefs.getString('photo')!;
    String myGmail = prefs.getString('gmail')!;
    String myName = prefs.getString('displayName')!;
    print(name);

    // Use the loaded string
    setState(() {
      photoUrl = myString;
      email = myGmail;
      name = myName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: NetworkImage(photoUrl != null
                                ? photoUrl!
                                : "https://img.freepik.com/premium-vector/portrait-beautiful-young-woman_478440-398.jpg?size=626&ext=jpg"))),
                  ),
                ),
                Text(name,
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                Text(email,
                    style: GoogleFonts.poppins(
                        fontSize: 10, fontWeight: FontWeight.w400)),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                    onTap: () {
                      logout(context);
                    },
                    child: Container(
                      height: 30,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.deepPurple.shade300),
                      child: Center(
                        child: Text(
                          'Logout',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
