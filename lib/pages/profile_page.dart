import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:golpo/l10n/app_localizations.dart';
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
    if (mounted) setState(() => user = loadedUser);
  }

  Future<void> _handleGoogleSignOut() async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: "Confirm Sign Out",
      content: "Are you sure you want to sign out?",
    );

    if (confirmed == true) {
      await GoogleSignIn().signOut();
      await UserService.clearUser();
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final prefs = user!.preferences;
    final isOnline = prefs.isConnected;
    final loc = AppLocalizations.of(context)!;
    final languageLabel = {
      'en': 'English',
      'bn': 'বাংলা',
      'hi': 'Hindi',
    }[prefs.language] ?? 'Unknown';

    return Scaffold(
      appBar: MyAppBar(
        title: loc.profile,
        backgroundColor: theme.primaryColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  color: theme.appBarTheme.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.deepPurple.shade100,
                              backgroundImage: user!.photoUrl != null
                                  ? NetworkImage('https://images.weserv.nl/?url=${Uri.encodeComponent(user!.photoUrl!)}')
                                  : null,
                              child: user!.photoUrl == null
                                  ? Icon(Icons.person, size: 50, color: Colors.deepPurple.shade600)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          user!.name,
                                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (user!.isVerified)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 4),
                                          child: Icon(Icons.verified, size: 18, color: Colors.green),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(user!.email, style: theme.textTheme.bodySmall?.copyWith(color: Colors.blue)),
                                  const SizedBox(height: 4),
                                  if (user!.googleId != null)
                                    Text("Google ID: ${user!.googleId}", style: theme.textTheme.bodySmall),
                                  Text("User ID: ${user!.id}", style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _expandedInfoBox(FontAwesomeIcons.coins, "${user!.walletCoin}", Colors.amberAccent),
                            _expandedInfoBox(Icons.group, "${user!.followers}", Colors.blueAccent),
                            _expandedInfoBox(
                              Icons.wifi,
                              isOnline ? "Online" : "Offline",
                              isOnline ? Colors.greenAccent : Colors.grey,
                            ),
                            _expandedInfoBox(Icons.language, languageLabel, Colors.white),
                          ],
                        ),


                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit Name',
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              tooltip: 'Settings',
                              onPressed: () {
                                Navigator.pushNamed(context, '/settings');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout),
                              tooltip: 'Sign Out',
                              onPressed: _handleGoogleSignOut,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _expandedInfoBox(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
