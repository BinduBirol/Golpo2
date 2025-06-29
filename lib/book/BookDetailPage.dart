import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../DTO/Book.dart';
import '../DTO/User.dart';
import '../l10n/app_localizations.dart';
import '../service/UserService.dart';
import '../utils/confirm_dialog.dart';
import '../widgets/animated_coin.dart';
import '../widgets/my_app_bar.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool _isExpanded = false;
  bool _isFavorite = false;
  bool _isRedeemed = false; // Assume false by default
  int _userCoins = 0; // Demo user coin balance
  final GlobalKey _redeemButtonKey = GlobalKey(); // to track button position
  OverlayEntry? _overlayEntry;                    // for animation overlay


  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    _showToast(_isFavorite ? 'Added to favorites' : 'Removed from favorites');
  }

  void _showCoinAnimation() {
    final renderBox = _redeemButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final startOffset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: startOffset.dx + renderBox.size.width / 2 - 12,
          top: startOffset.dy,
          child: AnimatedCoin(
            onEnd: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }


  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _onRedeem() async {
    User user = await UserService.getUser();
    _userCoins = user.walletCoin;

    if (_userCoins < widget.book.price) {

      final confirmBuy = await showConfirmDialog(
        context: context,
        //title: "Confirm Redemption",
        content:
        "Not enough coins to redeem. Want to get coins now?", title: 'Opps..!',
      );

      if (confirmBuy == true) {
        Navigator.pushNamed(context, '/buy');
      }

      return;
    }

    final confirm = await showConfirmDialog(
      context: context,
      title: "Confirm Redemption",
      content:
      "Are you sure you want to redeem this book for ${widget.book.price} coins?",
    );

    if (confirm == true) {
      _showCoinAnimation();
      await UserService.deductCoins(widget.book.price); // Wait for deduction
      User updatedUser = await UserService.getUser(); // Fetch updated coins

      setState(() {
        _userCoins = updatedUser.walletCoin;
        _isRedeemed = true;
      });

      _showToast('Redeemed successfully! Remaining: $_userCoins coins');
    }
  }


  Widget _buildActionButton() {
    if (widget.book.price == 0 || _isRedeemed) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        icon: const Icon(Icons.menu_book),
        label: Text(AppLocalizations.of(context)!.read),
        onPressed: () => _showToast('Reading: ${widget.book.title}'),
      );
    } else {
      return ElevatedButton.icon(
        key: _redeemButtonKey,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        icon: const Icon(FontAwesomeIcons.coins),
        label: Text(
          'Redeem with ${widget.book.price} coins',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: _onRedeem,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: MyAppBar(title: book.title),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            book.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder:
                (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.yellow,
                    width: double.infinity,
                    height: double.infinity,
                    child: const Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ), // padding from top
                        child: Align(
                          alignment:
                              Alignment.topCenter, // top horizontal center
                          child: CircularProgressIndicator(
                            color: Colors.deepOrange, // sets spinner color to red
                          ),
                        ),
                      ),
                    ),
                  );
                },
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
              child: Container(
                width: double.infinity,
                // Optional: set height if needed, e.g. height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  // padding from top
                  child: Align(
                    alignment: Alignment.topCenter, // top horizontal center
                    child: const Icon(
                      Icons.broken_image,
                      size: 300,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: SafeArea(
              bottom: true,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 60),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildActionButton(),
                        const SizedBox(height: 12),
                        _isExpanded
                            ? _buildScrollableInfo(book)
                            : _buildCollapsedInfo(book),
                        const SizedBox(height: 20),
                        _buildStatsRow(book),
                        const SizedBox(height: 12),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedInfo(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${book.author} • ${book.genre} • ${book.publishedYear}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildDescription(book.description),
      ],
    );
  }

  Widget _buildScrollableInfo(Book book) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${book.author} • ${book.genre} • ${book.publishedYear}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildDescription(book.description),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    if (_isExpanded || description.length <= 100) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          if (description.length > 100)
            GestureDetector(
              onTap: () => setState(() => _isExpanded = false),
              child: const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Show Less',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                ),
              ),
            ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${description.substring(0, 100)}...',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = true),
            child: const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'See More',
                style: TextStyle(color: Colors.blueAccent, fontSize: 12),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildStatsRow(Book book) {
    return Row(
      children: [
        const Icon(Icons.menu_book, color: Colors.white70, size: 20),
        const SizedBox(width: 4),
        Text(
          book.viewCount,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        const Icon(Icons.star, color: Colors.yellowAccent, size: 18),
        const SizedBox(width: 4),
        Text(
          book.rating.toString(),
          style: const TextStyle(
            color: Colors.yellowAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        ElevatedButton.icon(
          onPressed: () => _showToast('Opening preview...'),
          icon: const Icon(Icons.auto_stories),
          label: const Text('Read a Little'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
        ),
        ElevatedButton(
          onPressed: () => _showToast('Loading comments...'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
          child: const Icon(Icons.comment),
        ),
        ElevatedButton(
          onPressed: _toggleFavorite,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isFavorite ? Colors.red : Colors.grey,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
          child: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
        ),
      ],
    );
  }
}
