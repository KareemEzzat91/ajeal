
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AIResultsScreen extends StatelessWidget {
  final String analysis;
  final List<Map<String, dynamic>> sessionsData;
  final String childName ;

  const AIResultsScreen({
    super.key,
    required this.analysis,
    required this.sessionsData,
    required this.childName,
  });

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    // تحميل خط عربي
    final fontData = await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    // إزالة التنسيقات الغير مرغوبة مثل النجوم *
    String cleanText(String text) {
      return text.replaceAll(RegExp(r'\*+|#+'), '').trim();
    }

    // تقسيم النص إلى فقرات
    final paragraphs = analysis.split('\n\n').map(cleanText).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: ttf),
        build: (pw.Context context) => [
          // العنوان الرئيسي
          pw.Header(
            level: 0,
            child: pw.Text(
              "تحليل نتائج $childName",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              textDirection: pw.TextDirection.rtl,
            ),
          ),
          pw.SizedBox(height: 10),

          // عدد الجلسات
          pw.Text(
            "تم تحليل ${sessionsData.length} جلسات مكتملة",
            style: const pw.TextStyle(fontSize: 14),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(height: 20),

          // عنوان القسم
          pw.Text(
            "نتائج التحليل",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(height: 10),

          // النصوص مقسمة بشكل جيد
          pw.ListView(
            children: paragraphs.map((paragraph) =>
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Text(
                    paragraph,
                    style: const pw.TextStyle(fontSize: 14),
                    textDirection: pw.TextDirection.rtl,
                  ),
                ),
            ).toList(),
          ),
        ],

        // ترقيم الصفحات في الأسفل
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'صفحة ${context.pageNumber} من ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 12),
            textDirection: pw.TextDirection.rtl,
          ),
        ),
      ),
    );

    // عرض نافذة الطباعة أو الحفظ كـ PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${childName}_${DateTime.now().toString().split(' ')[0]}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تحليل النتائج"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.amber),
                        SizedBox(width: 8),
                        Text("تحليل ذكاء اصطناعي", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("تم تحليل ${sessionsData.length} جلسات مكتملة", style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                    const SizedBox(height: 16),
                    const Text("هذا التحليل يقدم نظرة عامة على التقدم والإنجازات والتوصيات بناءً على بيانات الجلسات المكتملة.", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("نتائج التحليل", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    MarkdownBody(
                      data: analysis,
                      styleSheet: MarkdownStyleSheet(
                        h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        h3: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        p: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => generatePdf(),
                    icon: const Icon(Icons.download),
                    label: const Text("تصدير التقرير"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}