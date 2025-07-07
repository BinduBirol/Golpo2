import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../DTO/User.dart';
import '../DTO/UserPreferences.dart';
import '../pages/profile_page.dart';
import '../service/UserService.dart';
import '../service/google_auth_service.dart';

class DrawerHeaderWidget extends StatefulWidget {
  const DrawerHeaderWidget({Key? key}) : super(key: key);

  @override
  _DrawerHeaderWidgetState createState() => _DrawerHeaderWidgetState();
}

class _DrawerHeaderWidgetState extends State<DrawerHeaderWidget> {
  User? _appUser; // stores the logged-in user info
  bool _isLoading = false; // track loading state during sign in

  @override
  void initState() {
    super.initState();
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    print("[DrawerHeader] Loading user from local storage...");
    final user = await UserService.getUser();
    if (user != null && user.id.isNotEmpty) {
      print("[DrawerHeader] Loaded user: ${user.name}, id: ${user.id}");
    } else {
      print("[DrawerHeader] No user found in storage.");
    }
    setState(() {
      _appUser = user;
    });
  }

  Future<void> _handleGoogleSignIn() async {
    print("[DrawerHeader] Starting Google Sign-In...");
    setState(() {
      _isLoading = true;
    });

    try {
      final signedInUser = await GoogleAuthService().signInWithGoogle();
      if (signedInUser != null) {
        print(
          "[DrawerHeader] Google Sign-In success: ${signedInUser.displayName}",
        );

        final firebaseUser = FirebaseAuth.instance.currentUser!;
        final appUser = User(
          id: firebaseUser.uid,
          googleId: firebaseUser.providerData.isNotEmpty
              ? firebaseUser.providerData.first.uid
              : null,
          photoUrl: firebaseUser.photoURL,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          walletCoin: 0,
          isVerified: firebaseUser.emailVerified,
          followers: 0,
          preferences: UserPreferences.defaultValues(),
        );

        print("[DrawerHeader] Saving user to local storage...");
        await UserService.setUser(appUser);

        setState(() {
          _appUser = appUser;
          _isLoading = false;
        });
        print("[DrawerHeader] User state updated and UI refreshed.");
      } else {
        print("[DrawerHeader] Google Sign-In canceled or failed.");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("[DrawerHeader] Error during Google Sign-In: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appPrimaryColor = Theme.of(context).appBarTheme.backgroundColor;

    return DrawerHeader(
      decoration: BoxDecoration(color: appPrimaryColor),
      child: GestureDetector(
        onTap: () {
          if (_appUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },

        child: Row(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: (_appUser?.photoUrl != null)
                    ? NetworkImage(
                        'https://images.weserv.nl/?url=${Uri.encodeComponent(_appUser!.photoUrl!)}',
                      )
                    : null,
                child: (_appUser?.photoUrl == null)
                    ? Icon(Icons.person, size: 30, color: appPrimaryColor)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoading)
                    const CircularProgressIndicator(color: Colors.white)
                  else if (_appUser == null || _appUser!.googleId == null) ...[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.login),
                      label: const Text("Sign in with Google"),
                      onPressed: _handleGoogleSignIn,
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Text(
                          _appUser!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        if (_appUser!.isVerified) ...[
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.verified_user,
                            size: 16,
                            color: Colors.greenAccent,
                          ),
                        ],
                      ],
                    ),

                    Text(
                      _appUser!.googleId.toString(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
