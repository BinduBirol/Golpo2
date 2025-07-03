import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:golpo/widgets/app_bar/my_app_bar.dart';
import '../DTO/User.dart';
import '../l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  final VoidCallback? onConnectWithGoogle;
  final VoidCallback? onGreenButtonPressed;
  final VoidCallback? onLogoutPressed;

  const ProfilePage({
    Key? key,
    required this.user,
    this.onConnectWithGoogle,
    this.onGreenButtonPressed,
    this.onLogoutPressed,
  }) : super(key: key);

  String getReadableGroup(String group) {
    switch (group) {
      case 'under_18':
        return 'Under 18';
      case '18_30':
        return '18 – 30';
      case 'over_30':
        return 'Over 30';
      default:
        return 'Unknown';
    }
  }

  String getReadableBool(bool? val) => (val ?? false) ? 'Yes' : 'No';

  Widget _buildGoogleButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onConnectWithGoogle,
      icon: FaIcon(FontAwesomeIcons.google, color: Colors.redAccent, size: 24),
      label: Text(
        'Connect with Google',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 3,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildGreenButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onGreenButtonPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Green Button',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onLogoutPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple.shade400),
            SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.deepPurple.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = user.preferences;
    final double spacing = 12;

    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context)!.profile),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar and user basic info
            CircleAvatar(
              radius: 52,
              backgroundColor: Colors.deepPurple.shade400,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              user.name,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade900,
              ),
            ),
            SizedBox(height: 6),
            Text(
              user.email,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),

            SizedBox(height: 24),

            // Google Connect Button
            SizedBox(height: 28),

            Row(
              children: [
                _buildGoogleButton(context),
                SizedBox(width: spacing),
                _buildGreenButton(context),
                SizedBox(width: spacing),
                _buildLogoutButton(context),
              ],
            ),

            SizedBox(height: 28),

            // User info rows (2 per row)
            Row(
              children: [
                _buildItem(Icons.perm_identity, 'User ID', user.id),
                SizedBox(width: spacing),
                _buildItem(
                  FontAwesomeIcons.coins,
                  'Wallet Coins',
                  user.walletCoin.toString(),
                ),
              ],
            ),
            Row(
              children: [
                _buildItem(
                  Icons.verified_user,
                  'Verified',
                  getReadableBool(user.isVerified),
                ),
                SizedBox(width: spacing),
                _buildItem(
                  Icons.people,
                  'Followers',
                  user.followers.toString(),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Preferences label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade800,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Preferences rows (2 per row)
            Row(
              children: [
                _buildItem(
                  Icons.brightness_6,
                  'Dark Mode',
                  prefs.isDarkMode == null
                      ? 'System'
                      : getReadableBool(prefs.isDarkMode!),
                ),
                SizedBox(width: spacing),
                _buildItem(
                  Icons.music_note,
                  'Music Enabled',
                  getReadableBool(prefs.musicEnabled),
                ),
              ],
            ),
            Row(
              children: [
                _buildItem(
                  Icons.surround_sound,
                  'SFX Enabled',
                  getReadableBool(prefs.sfxEnabled),
                ),
                SizedBox(width: spacing),
                _buildItem(
                  Icons.volume_up,
                  'Music Volume',
                  '${(prefs.musicVolume * 100).toInt()}%',
                ),
              ],
            ),
            Row(
              children: [
                _buildItem(
                  Icons.cake,
                  'Age Group',
                  getReadableGroup(prefs.ageGroup),
                ),
                SizedBox(width: spacing),
                _buildItem(
                  Icons.language,
                  'Language',
                  prefs.language.toUpperCase(),
                ),
              ],
            ),
            Row(
              children: [
                _buildItem(
                  Icons.wifi,
                  'Connected',
                  getReadableBool(prefs.isConnected),
                ),
                SizedBox(width: spacing),
                Expanded(child: Container()), // empty for alignment
              ],
            ),
          ],
        ),
      ),
    );
  }
}
