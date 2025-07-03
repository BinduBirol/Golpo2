import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:golpo/widgets/number_formatter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../DTO/Book.dart';
import '../DTO/User.dart';
import '../DTO/UserPreferences.dart';
import '../l10n/app_localizations.dart';
import '../service/BookService.dart';
import '../service/UserService.dart';
import '../utils/background_audio.dart';
import '../utils/confirm_dialog.dart';
import '../widgets/ScrollableCategoryList.dart';
import '../widgets/animated_coin.dart';
import '../widgets/app_bar/book_app_bar.dart';
import '../widgets/button/button_decorators.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;



  // Pass the book.id as the key
  BookDetailPage({required this.book, Key? key})
    : super(key: ValueKey(book.id));

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool _isExpanded = false;
  bool _isFavorite = false;
  bool _isRedeemed = false;
  int _userCoins = 0;
  final GlobalKey _redeemButtonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  late String _localeCode;

  late UserPreferences prefs;

  @override
  void initState() {
    super.initState();
    UserService.getUser().then((user) {
      setState(() {
        prefs = user.preferences;
      });
    });

    _isFavorite = widget.book.userActivity.isMyFavorite;
    _isRedeemed = widget.book.userActivity.isUnlocked;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localeCode = Localizations.localeOf(context).languageCode;
  }

  Widget buildBookImage(BuildContext context, Book book) {
    final cachedPath = book.cachedImagePath;

    if (!kIsWeb && cachedPath != null && File(cachedPath).existsSync()) {
      return Image.file(
        File(cachedPath),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildErrorWidget(context),
      );
    }

    return Image.network(
      book.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            width: 150,
            child: Lottie.asset('assets/animations/image_loading.json'),
          ),
        );
      },
      errorBuilder: (_, __, ___) => _buildErrorWidget(context),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      child: const Padding(
        padding: EdgeInsets.only(top: 90),
        child: Align(
          alignment: Alignment.topCenter,
          child: Icon(Icons.broken_image, size: 300, color: Colors.grey),
        ),
      ),
    );
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.book.userActivity.isMyFavorite = _isFavorite;

    BookService.updateUserActivity(widget.book.id, widget.book.userActivity);

    _showToast(_isFavorite ? 'Added to favorites' : 'Removed from favorites');
  }

  void _showCoinAnimation() {
    final renderBox =
        _redeemButtonKey.currentContext?.findRenderObject() as RenderBox?;
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

  Future<void> _onRedeem() async {
    User user = await UserService.getUser();
    _userCoins = user.walletCoin;

    if (_userCoins < widget.book.price) {
      final confirmBuy = await showConfirmDialog(
        context: context,
        content: AppLocalizations.of(context)!.notEnoughCoin,
        title: AppLocalizations.of(context)!.oops,
      );

      if (confirmBuy == true) {
        Navigator.pushNamed(context, '/buy');
      }

      return;
    }

    final confirm = await showConfirmDialog(
      context: context,
      title: AppLocalizations.of(context)!.confirmRedemption,
      content: AppLocalizations.of(context)!.sureRedemption,
    );

    if (confirm == true) {
      _showCoinAnimation();
      await UserService.deductCoins(widget.book.price);
      User updatedUser = await UserService.getUser();

      setState(() {
        _userCoins = updatedUser.walletCoin;
        _isRedeemed = true;
        widget.book.userActivity.isUnlocked = true;
      });

      BookService.updateUserActivity(widget.book.id, widget.book.userActivity);
      _showToast(AppLocalizations.of(context)!.redeemedSuccessfully);
    }
  }

  Widget _buildActionButton() {
    if (widget.book.price == 0 || _isRedeemed) {
      return ButtonDecorators.defaultButton(
        key: const ValueKey('read_button'),
        context: context,
        icon: Icons.book,
        text: AppLocalizations.of(context)!.read,
        onPressed: () => _showToast('Reading: ${widget.book.title}'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      );
    } else {
      return ButtonDecorators.defaultButton(
        key: const ValueKey('redeem_button'),
        context: context,
        icon: FontAwesomeIcons.coins,
        iconIsFaIcon: true,
        text: 'Redeem with ${widget.book.price} coins',
        onPressed: _onRedeem,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        labelTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: BookAppBar(title: 'Book no ${book.id}'),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          buildBookImage(context, book),
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
                        _buildActionButtons(book),
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
        const SizedBox(height: 12),
        SizedBox(
          height: 30,
          child: ScrollableCategoryList(categories: book.category),
        ),
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
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
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
                  style: TextStyle(color: Colors.deepOrange, fontSize: 12),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Icon(Icons.menu_book, color: Colors.white70, size: 20),
          const SizedBox(width: 4),
          Text(
            NumberFormatter.formatCount(book.viewCount, _localeCode),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.star, color: Colors.yellowAccent, size: 20),
          const SizedBox(width: 4),
          Text(
            NumberFormat.decimalPattern(_localeCode).format(book.rating),
            style: const TextStyle(
              color: Colors.yellowAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.access_time, color: Colors.teal, size: 20),
          const SizedBox(width: 4),
          Text(
            NumberFormatter.formatDuration(book.storyTime as int, _localeCode),
            style: const TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Book book) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonDecorators.defaultButton(
            context: context,
            icon: Icons.auto_stories,
            text: AppLocalizations.of(context)!.readAlittle,
            onPressed: () {
              _showToast('Opening preview...');
            },
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),

          const SizedBox(width: 12),
          ButtonDecorators.defaultButton(
            context: context,
            icon: Icons.comment,
            text: NumberFormatter.formatCount(book.commentsCount, _localeCode),
            onPressed: () => _showToast('Loading comments...'),
            backgroundColor: Colors.cyan,
            foregroundColor: Colors.white,
          ),

          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _toggleFavorite,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: _isFavorite ? Colors.redAccent : Colors.grey.shade700,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
