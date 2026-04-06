// ============================================================
// ملف: article_model.dart
// الوصف: نموذج بيانات المقال الصحي التوعوي في تطبيق طبيبي
// يُمثّل المقالات الصحية والتوعوية التي تُنشر في التطبيق
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── فئة المقال الصحي ────────────────────────────────────────
enum ArticleCategory {
  general,        // صحة عامة
  nutrition,      // تغذية وغذاء
  mentalHealth,   // الصحة النفسية
  pediatrics,     // صحة الطفل
  womensHealth,   // صحة المرأة
  chronic,        // الأمراض المزمنة
  firstAid,       // الإسعافات الأولية
  fitness,        // اللياقة البدنية
  prevention,     // الوقاية والتحصين
}

// ─── النموذج الرئيسي للمقال الصحي ───────────────────────────
class ArticleModel {
  final String id;                  // معرّف المقال الفريد
  final String title;               // عنوان المقال
  final String content;             // محتوى المقال الكامل (نص HTML أو Markdown)
  final String summary;             // ملخص قصير للعرض في الصفحة الرئيسية
  final String coverImageUrl;       // رابط صورة الغلاف
  final ArticleCategory category;   // فئة المقال
  final List<String> tags;          // الوسوم للبحث والتصفية
  final String authorId;            // معرّف الطبيب أو المحرر الذي كتبه
  final String authorName;          // اسم الكاتب للعرض
  final int viewsCount;             // عدد مرات المشاهدة
  final int likesCount;             // عدد الإعجابات
  final bool isPublished;           // هل نُشر للعموم؟
  final DateTime publishedAt;       // تاريخ النشر
  final DateTime createdAt;         // تاريخ الإنشاء
  final DateTime updatedAt;         // تاريخ آخر تحديث

  const ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.coverImageUrl,
    required this.category,
    this.tags = const [],
    required this.authorId,
    required this.authorName,
    this.viewsCount = 0,
    this.likesCount = 0,
    this.isPublished = false,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'cover_image_url': coverImageUrl,
      'category': category.name,
      'tags': tags,
      'author_id': authorId,
      'author_name': authorName,
      'views_count': viewsCount,
      'likes_count': likesCount,
      'is_published': isPublished,
      'published_at': Timestamp.fromDate(publishedAt),
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArticleModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      summary: data['summary'] ?? '',
      coverImageUrl: data['cover_image_url'] ?? '',
      category: ArticleCategory.values.firstWhere(
        (c) => c.name == data['category'],
        orElse: () => ArticleCategory.general,
      ),
      tags: List<String>.from(data['tags'] ?? []),
      authorId: data['author_id'] ?? '',
      authorName: data['author_name'] ?? '',
      viewsCount: data['views_count'] ?? 0,
      likesCount: data['likes_count'] ?? 0,
      isPublished: data['is_published'] ?? false,
      publishedAt: (data['published_at'] as Timestamp).toDate(),
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() => 'ArticleModel(id: $id, title: $title, views: $viewsCount)';
}
