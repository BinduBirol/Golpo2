import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Golpo'**
  String get appTitle;

  /// No description provided for @tapToContinue.
  ///
  /// In en, this message translates to:
  /// **'Tap to continue'**
  String get tapToContinue;

  /// No description provided for @welcomeText.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Story App'**
  String get welcomeText;

  /// No description provided for @enterApp.
  ///
  /// In en, this message translates to:
  /// **'Enter App'**
  String get enterApp;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Music & Sound Effects (SFX)'**
  String get soundEffects;

  /// No description provided for @ageGroupSelect.
  ///
  /// In en, this message translates to:
  /// **'Please select your age group'**
  String get ageGroupSelect;

  /// No description provided for @ageGroup.
  ///
  /// In en, this message translates to:
  /// **'Age Group'**
  String get ageGroup;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @ageGroup18to30.
  ///
  /// In en, this message translates to:
  /// **'18 – 30'**
  String get ageGroup18to30;

  /// No description provided for @under18.
  ///
  /// In en, this message translates to:
  /// **'Under 18'**
  String get under18;

  /// No description provided for @over30.
  ///
  /// In en, this message translates to:
  /// **'Over 30'**
  String get over30;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @storyIntro.
  ///
  /// In en, this message translates to:
  /// **'This is where your interactive story will begin!'**
  String get storyIntro;

  /// No description provided for @musicVolume.
  ///
  /// In en, this message translates to:
  /// **'Music Volume'**
  String get musicVolume;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @loadingData.
  ///
  /// In en, this message translates to:
  /// **'Data is loading'**
  String get loadingData;

  /// No description provided for @searchBoxText.
  ///
  /// In en, this message translates to:
  /// **'Search books..'**
  String get searchBoxText;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @tapToValidateData.
  ///
  /// In en, this message translates to:
  /// **'Tap to validate data'**
  String get tapToValidateData;

  /// No description provided for @coinStore.
  ///
  /// In en, this message translates to:
  /// **'Coin store'**
  String get coinStore;

  /// No description provided for @confirmRedemption.
  ///
  /// In en, this message translates to:
  /// **'Confirm Redemption'**
  String get confirmRedemption;

  /// No description provided for @sureRedemption.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to redeem this book?'**
  String get sureRedemption;

  /// No description provided for @redeemedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Redeemed successfully!'**
  String get redeemedSuccessfully;

  /// No description provided for @notEnoughCoin.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins to redeem. Want to get coins now?'**
  String get notEnoughCoin;

  /// No description provided for @oops.
  ///
  /// In en, this message translates to:
  /// **'Oopss...'**
  String get oops;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading...'**
  String get continueReading;

  /// No description provided for @readAlittle.
  ///
  /// In en, this message translates to:
  /// **'Read a little'**
  String get readAlittle;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMore;

  /// No description provided for @seeLess.
  ///
  /// In en, this message translates to:
  /// **'See less'**
  String get seeLess;

  /// No description provided for @offlineData.
  ///
  /// In en, this message translates to:
  /// **'Offline data'**
  String get offlineData;

  /// No description provided for @checkingSession.
  ///
  /// In en, this message translates to:
  /// **'Checking previous session...'**
  String get checkingSession;

  /// No description provided for @checkingInternet.
  ///
  /// In en, this message translates to:
  /// **'Checking internet connection...'**
  String get checkingInternet;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection - offline mode.'**
  String get noInternet;

  /// No description provided for @internetConnected.
  ///
  /// In en, this message translates to:
  /// **'Internet connection established.'**
  String get internetConnected;

  /// No description provided for @updatingUser.
  ///
  /// In en, this message translates to:
  /// **'Updating user data...'**
  String get updatingUser;

  /// No description provided for @userUpdated.
  ///
  /// In en, this message translates to:
  /// **'User data updated.'**
  String get userUpdated;

  /// No description provided for @copyingAssets.
  ///
  /// In en, this message translates to:
  /// **'Copying assets to local storage...'**
  String get copyingAssets;

  /// No description provided for @copySuccess.
  ///
  /// In en, this message translates to:
  /// **'Assets copy successful.'**
  String get copySuccess;

  /// No description provided for @copyFailed.
  ///
  /// In en, this message translates to:
  /// **'Assets copy failed.'**
  String get copyFailed;

  /// No description provided for @verifyingBooks.
  ///
  /// In en, this message translates to:
  /// **'Verifying offline book data...'**
  String get verifyingBooks;

  /// No description provided for @cachingCovers.
  ///
  /// In en, this message translates to:
  /// **'Caching book covers...'**
  String get cachingCovers;

  /// No description provided for @finalizing.
  ///
  /// In en, this message translates to:
  /// **'Finalizing...'**
  String get finalizing;

  /// No description provided for @readyToLaunch.
  ///
  /// In en, this message translates to:
  /// **'Ready to launch.'**
  String get readyToLaunch;

  /// No description provided for @genreStory.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get genreStory;

  /// No description provided for @genreShortStory.
  ///
  /// In en, this message translates to:
  /// **'Short Story'**
  String get genreShortStory;

  /// No description provided for @genreNovel.
  ///
  /// In en, this message translates to:
  /// **'Novel'**
  String get genreNovel;

  /// No description provided for @genrePoem.
  ///
  /// In en, this message translates to:
  /// **'Poem'**
  String get genrePoem;

  /// No description provided for @genreDrama.
  ///
  /// In en, this message translates to:
  /// **'Drama'**
  String get genreDrama;

  /// No description provided for @genreEssay.
  ///
  /// In en, this message translates to:
  /// **'Essay'**
  String get genreEssay;

  /// No description provided for @genreFable.
  ///
  /// In en, this message translates to:
  /// **'Fable'**
  String get genreFable;

  /// No description provided for @genreFolktale.
  ///
  /// In en, this message translates to:
  /// **'Folktale'**
  String get genreFolktale;

  /// No description provided for @genreFantasy.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get genreFantasy;

  /// No description provided for @genreScienceFiction.
  ///
  /// In en, this message translates to:
  /// **'Science Fiction'**
  String get genreScienceFiction;

  /// No description provided for @genreMystery.
  ///
  /// In en, this message translates to:
  /// **'Mystery'**
  String get genreMystery;

  /// No description provided for @genreRomance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get genreRomance;

  /// No description provided for @genreHistorical.
  ///
  /// In en, this message translates to:
  /// **'Historical'**
  String get genreHistorical;

  /// No description provided for @categoryFiction.
  ///
  /// In en, this message translates to:
  /// **'Fiction'**
  String get categoryFiction;

  /// No description provided for @subcategoryHistoricalFiction.
  ///
  /// In en, this message translates to:
  /// **'Historical Fiction'**
  String get subcategoryHistoricalFiction;

  /// No description provided for @subcategoryScienceFiction.
  ///
  /// In en, this message translates to:
  /// **'Science Fiction'**
  String get subcategoryScienceFiction;

  /// No description provided for @subcategoryFantasy.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get subcategoryFantasy;

  /// No description provided for @subcategoryMystery.
  ///
  /// In en, this message translates to:
  /// **'Mystery'**
  String get subcategoryMystery;

  /// No description provided for @subcategoryThriller.
  ///
  /// In en, this message translates to:
  /// **'Thriller'**
  String get subcategoryThriller;

  /// No description provided for @subcategoryRomance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get subcategoryRomance;

  /// No description provided for @subcategoryDrama.
  ///
  /// In en, this message translates to:
  /// **'Drama'**
  String get subcategoryDrama;

  /// No description provided for @subcategoryHorror.
  ///
  /// In en, this message translates to:
  /// **'Horror'**
  String get subcategoryHorror;

  /// No description provided for @subcategoryAdventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get subcategoryAdventure;

  /// No description provided for @categoryNonFiction.
  ///
  /// In en, this message translates to:
  /// **'Non-Fiction'**
  String get categoryNonFiction;

  /// No description provided for @subcategoryBiography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get subcategoryBiography;

  /// No description provided for @subcategoryMemoir.
  ///
  /// In en, this message translates to:
  /// **'Memoir'**
  String get subcategoryMemoir;

  /// No description provided for @subcategorySelfHelp.
  ///
  /// In en, this message translates to:
  /// **'Self-Help'**
  String get subcategorySelfHelp;

  /// No description provided for @subcategoryHealthWellness.
  ///
  /// In en, this message translates to:
  /// **'Health & Wellness'**
  String get subcategoryHealthWellness;

  /// No description provided for @subcategoryBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get subcategoryBusiness;

  /// No description provided for @subcategoryHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get subcategoryHistory;

  /// No description provided for @subcategoryScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get subcategoryScience;

  /// No description provided for @subcategoryPhilosophy.
  ///
  /// In en, this message translates to:
  /// **'Philosophy'**
  String get subcategoryPhilosophy;

  /// No description provided for @subcategoryPolitics.
  ///
  /// In en, this message translates to:
  /// **'Politics'**
  String get subcategoryPolitics;

  /// No description provided for @categoryChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get categoryChildren;

  /// No description provided for @subcategoryPictureBooks.
  ///
  /// In en, this message translates to:
  /// **'Picture Books'**
  String get subcategoryPictureBooks;

  /// No description provided for @subcategoryEarlyReaders.
  ///
  /// In en, this message translates to:
  /// **'Early Readers'**
  String get subcategoryEarlyReaders;

  /// No description provided for @subcategoryMiddleGrade.
  ///
  /// In en, this message translates to:
  /// **'Middle Grade'**
  String get subcategoryMiddleGrade;

  /// No description provided for @subcategoryYoungAdult.
  ///
  /// In en, this message translates to:
  /// **'Young Adult'**
  String get subcategoryYoungAdult;

  /// No description provided for @subcategoryEducational.
  ///
  /// In en, this message translates to:
  /// **'Educational'**
  String get subcategoryEducational;

  /// No description provided for @categoryComics.
  ///
  /// In en, this message translates to:
  /// **'Comics & Graphic Novels'**
  String get categoryComics;

  /// No description provided for @subcategoryManga.
  ///
  /// In en, this message translates to:
  /// **'Manga'**
  String get subcategoryManga;

  /// No description provided for @subcategorySuperhero.
  ///
  /// In en, this message translates to:
  /// **'Superhero'**
  String get subcategorySuperhero;

  /// No description provided for @subcategorySliceOfLife.
  ///
  /// In en, this message translates to:
  /// **'Slice of Life'**
  String get subcategorySliceOfLife;

  /// No description provided for @categoryReligion.
  ///
  /// In en, this message translates to:
  /// **'Religion & Spirituality'**
  String get categoryReligion;

  /// No description provided for @subcategoryChristianity.
  ///
  /// In en, this message translates to:
  /// **'Christianity'**
  String get subcategoryChristianity;

  /// No description provided for @subcategoryIslam.
  ///
  /// In en, this message translates to:
  /// **'Islam'**
  String get subcategoryIslam;

  /// No description provided for @subcategoryHinduism.
  ///
  /// In en, this message translates to:
  /// **'Hinduism'**
  String get subcategoryHinduism;

  /// No description provided for @subcategoryBuddhism.
  ///
  /// In en, this message translates to:
  /// **'Buddhism'**
  String get subcategoryBuddhism;

  /// No description provided for @subcategorySpiritualGrowth.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Growth'**
  String get subcategorySpiritualGrowth;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education & Reference'**
  String get categoryEducation;

  /// No description provided for @subcategoryTextbooks.
  ///
  /// In en, this message translates to:
  /// **'Textbooks'**
  String get subcategoryTextbooks;

  /// No description provided for @subcategoryStudyGuides.
  ///
  /// In en, this message translates to:
  /// **'Study Guides'**
  String get subcategoryStudyGuides;

  /// No description provided for @subcategoryDictionaries.
  ///
  /// In en, this message translates to:
  /// **'Dictionaries'**
  String get subcategoryDictionaries;

  /// No description provided for @subcategoryLanguageLearning.
  ///
  /// In en, this message translates to:
  /// **'Language Learning'**
  String get subcategoryLanguageLearning;

  /// No description provided for @subcategoryTestPreparation.
  ///
  /// In en, this message translates to:
  /// **'Test Preparation'**
  String get subcategoryTestPreparation;

  /// No description provided for @categoryArt.
  ///
  /// In en, this message translates to:
  /// **'Art & Photography'**
  String get categoryArt;

  /// No description provided for @subcategoryArtHistory.
  ///
  /// In en, this message translates to:
  /// **'Art History'**
  String get subcategoryArtHistory;

  /// No description provided for @subcategoryPhotography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get subcategoryPhotography;

  /// No description provided for @subcategoryDesign.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get subcategoryDesign;

  /// No description provided for @subcategoryPainting.
  ///
  /// In en, this message translates to:
  /// **'Painting'**
  String get subcategoryPainting;

  /// No description provided for @subcategoryArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get subcategoryArchitecture;

  /// No description provided for @selectGenre.
  ///
  /// In en, this message translates to:
  /// **'Select Genre:'**
  String get selectGenre;

  /// No description provided for @chooseGenre.
  ///
  /// In en, this message translates to:
  /// **'Choose Genre'**
  String get chooseGenre;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category:'**
  String get selectCategory;

  /// No description provided for @chooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose Category'**
  String get chooseCategory;

  /// No description provided for @selectSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Select Subcategory:'**
  String get selectSubcategory;

  /// No description provided for @chooseSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Choose Subcategory'**
  String get chooseSubcategory;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters:'**
  String get filters;

  /// No description provided for @genre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genre;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @subcategory.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get subcategory;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
