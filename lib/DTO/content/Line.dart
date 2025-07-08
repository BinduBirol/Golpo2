class Line {
  final String id;
  final String text;
  final String style;
  final String emotion;

  Line({required this.id, required this.text, required this.style, required this.emotion});

  factory Line.fromJson(Map<String, dynamic> json) => Line(
    id: json['id'],
    text: json['text'],
    style: json['style'],
    emotion: json['emotion'],
  );
}

class Paragraph {
  final int paragraphNumber;
  final List<Line> lines;

  Paragraph({required this.paragraphNumber, required this.lines});

  factory Paragraph.fromJson(Map<String, dynamic> json) => Paragraph(
    paragraphNumber: json['paragraphNumber'],
    lines: List<Line>.from(json['lines'].map((line) => Line.fromJson(line))),
  );
}

class Chapter {
  final int chapterNumber;
  final String title;
  final List<Paragraph> paragraphs;

  Chapter({required this.chapterNumber, required this.title, required this.paragraphs});

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    chapterNumber: json['chapterNumber'],
    title: json['title'],
    paragraphs: List<Paragraph>.from(json['paragraphs'].map((p) => Paragraph.fromJson(p))),
  );
}
