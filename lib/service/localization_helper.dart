import '../l10n/app_localizations.dart';

class LocalizationHelper {
  static String genreKey(String genre) =>
      'genre${genre.replaceAll(RegExp(r'[\s&]'), '')}';

  static String categoryKey(String category) =>
      'category${category.replaceAll(RegExp(r'[\s&]'), '')}';

  static String subcategoryKey(String subcategory) =>
      'subcategory${subcategory.replaceAll(RegExp(r'[\s&]'), '')}';

  static String localizeGenre(AppLocalizations loc, String genre) {
    final map = {
      'genreStory': loc.genreStory,
      'genreShortStory': loc.genreShortStory,
      'genreNovel': loc.genreNovel,
      'genrePoem': loc.genrePoem,
      'genreDrama': loc.genreDrama,
      'genreEssay': loc.genreEssay,
      'genreFable': loc.genreFable,
      'genreFolktale': loc.genreFolktale,
      'genreFantasy': loc.genreFantasy,
      'genreScienceFiction': loc.genreScienceFiction,
      'genreMystery': loc.genreMystery,
      'genreRomance': loc.genreRomance,
      'genreHistorical': loc.genreHistorical,
    };
    return map[genreKey(genre)] ?? genre;
  }

  static String localizeCategory(AppLocalizations loc, String category) {
    final map = {
      'categoryFiction': loc.categoryFiction,
      'categoryNonFiction': loc.categoryNonFiction,
      'categoryChildren': loc.categoryChildren,
      'categoryComicsGraphicNovels': loc.categoryComics,
      'categoryReligionSpirituality': loc.categoryReligion,
      'categoryEducationReference': loc.categoryEducation,
      'categoryArtPhotography': loc.categoryArt,
    };
    return map[categoryKey(category)] ?? category;
  }

  static String localizeSubcategory(AppLocalizations loc, String subcategory) {
    final map = {
      'subcategoryHistoricalFiction': loc.subcategoryHistoricalFiction,
      'subcategoryScienceFiction': loc.subcategoryScienceFiction,
      'subcategoryFantasy': loc.subcategoryFantasy,
      'subcategoryMystery': loc.subcategoryMystery,
      'subcategoryThriller': loc.subcategoryThriller,
      'subcategoryRomance': loc.subcategoryRomance,
      'subcategoryDrama': loc.subcategoryDrama,
      'subcategoryHorror': loc.subcategoryHorror,
      'subcategoryAdventure': loc.subcategoryAdventure,
      'subcategoryBiography': loc.subcategoryBiography,
      'subcategoryMemoir': loc.subcategoryMemoir,
      'subcategorySelfHelp': loc.subcategorySelfHelp,
      'subcategoryHealthWellness': loc.subcategoryHealthWellness,
      'subcategoryBusiness': loc.subcategoryBusiness,
      'subcategoryHistory': loc.subcategoryHistory,
      'subcategoryScience': loc.subcategoryScience,
      'subcategoryPhilosophy': loc.subcategoryPhilosophy,
      'subcategoryPolitics': loc.subcategoryPolitics,
      'subcategoryPictureBooks': loc.subcategoryPictureBooks,
      'subcategoryEarlyReaders': loc.subcategoryEarlyReaders,
      'subcategoryMiddleGrade': loc.subcategoryMiddleGrade,
      'subcategoryYoungAdult': loc.subcategoryYoungAdult,
      'subcategoryEducational': loc.subcategoryEducational,
      'subcategoryManga': loc.subcategoryManga,
      'subcategorySuperhero': loc.subcategorySuperhero,
      'subcategorySliceOfLife': loc.subcategorySliceOfLife,
      'subcategoryChristianity': loc.subcategoryChristianity,
      'subcategoryIslam': loc.subcategoryIslam,
      'subcategoryHinduism': loc.subcategoryHinduism,
      'subcategoryBuddhism': loc.subcategoryBuddhism,
      'subcategorySpiritualGrowth': loc.subcategorySpiritualGrowth,
      'subcategoryTextbooks': loc.subcategoryTextbooks,
      'subcategoryStudyGuides': loc.subcategoryStudyGuides,
      'subcategoryDictionaries': loc.subcategoryDictionaries,
      'subcategoryLanguageLearning': loc.subcategoryLanguageLearning,
      'subcategoryTestPreparation': loc.subcategoryTestPreparation,
      'subcategoryArtHistory': loc.subcategoryArtHistory,
      'subcategoryPhotography': loc.subcategoryPhotography,
      'subcategoryDesign': loc.subcategoryDesign,
      'subcategoryPainting': loc.subcategoryPainting,
      'subcategoryArchitecture': loc.subcategoryArchitecture,
    };
    return map[subcategoryKey(subcategory)] ?? subcategory;
  }
}
