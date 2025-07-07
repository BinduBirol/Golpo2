import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:golpo/l10n/app_localizations.dart';
import 'package:golpo/l10n/app_localizations_en.dart';
import 'package:golpo/utils/confirm_dialog.dart';
import 'package:golpo/widgets/app_bar/my_app_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../DTO/User.dart';
import '../DTO/UserPreferences.dart';
import '../service/UserService.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final loadedUser = await UserService.getUser();
    if (mounted) {
      setState(() => user = loadedUser);
    }
  }

  Future<void> _handleGoogleSignOut() async {
    final confirmed = showConfirmDialog(
      context: context,
      title: "Confirm Sign Out",
      content: "Are you sure you want to sign out?",
    );

    if (confirmed == true) {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await UserService.clearUser();
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final prefs = user!.preferences;
    final isOnline = prefs.isConnected;
    final theme = Theme.of(context);
    final Map<String, String> localizedMap = {
      'en': 'English',
      'bn': 'বাংলা',
      'hi': 'Hindi',
    };
    final label = localizedMap[prefs.language] ?? 'Unknown';
    return Scaffold(
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.profile,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Stack(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: theme.appBarTheme.backgroundColor,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT - Avatar with status dot
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor: Colors.deepPurple.shade100,
                              backgroundImage: user!.photoUrl != null
                                  ? NetworkImage(
                                      'https://images.weserv.nl/?url=${Uri.encodeComponent(user!.photoUrl!)}',
                                    )
                                  : null,
                              child: user!.photoUrl == null
                                  ? Icon(
                                      Icons.person,
                                      size: 70,
                                      color: Colors.deepPurple.shade600,
                                    )
                                  : null,
                            ),
                          ],
                        ),

                        const SizedBox(width: 16),

                        // RIGHT - Info & badges
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      user!.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (user!.isVerified)
                                    const SizedBox(width: 6),
                                  if (user!.isVerified)
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.verified,
                                        size: 14,
                                        color: Colors.green,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                user!.email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueAccent,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              if (user!.googleId != null &&
                                  user!.googleId!.isNotEmpty)
                                Text(
                                  'Google ID: ${user!.googleId}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              Text(
                                'User ID: ${user!.id}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),

                              // Quick Info Icons
                              Wrap(
                                spacing: 14,
                                runSpacing: 8,
                                children: [
                                  _iconValueCard(
                                    icon: FontAwesomeIcons.coins,
                                    label: "${user!.walletCoin}",
                                    iconColor: Colors.amberAccent,
                                    labelColor: Colors.amberAccent,
                                  ),
                                  _iconValueCard(
                                    icon: Icons.group,
                                    label: "${user!.followers}",
                                    iconColor: Colors.blueAccent,
                                    labelColor: Colors.blueAccent,
                                  ),
                                  _iconValueCard(
                                    icon: Icons.wifi,
                                    label: isOnline ? "Online" : "Offline",
                                    iconColor: isOnline
                                        ? Colors.greenAccent
                                        : Colors.grey,
                                    labelColor: isOnline
                                        ? Colors.greenAccent
                                        : Colors.grey,
                                  ),
                                  _iconValueCard(
                                    icon: Icons.language,
                                    label: label ?? "Not set",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Positioned Buttons (top-right)
                Positioned(
                  top: 8,
                  right: 12,
                  child: Row(
                    children: [

                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        tooltip: 'Change name',
                        onPressed: () {

                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        tooltip: 'Settings',
                        onPressed: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        tooltip: 'Sign Out',
                        onPressed: _handleGoogleSignOut,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconValueCard({
    required IconData icon,
    required String label,
    Color iconColor = Colors.white,
    Color labelColor = Colors.white,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}
