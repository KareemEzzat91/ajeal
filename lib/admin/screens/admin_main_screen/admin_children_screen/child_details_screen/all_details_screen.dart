import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../../core/models/child_model/child_model.dart';
import '../../../../../helpers/generated/l10n.dart';

class AllDetailsScreen extends StatelessWidget {
  final Child child;

  const AllDetailsScreen(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.childDetails,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChildHeader(context, S.of(context)),
              const SizedBox(height: 16),

              _buildSection(
                context,
                s.basicInformation,
                [
                  _buildDetailItem(s.childName, child.name),
                  _buildDetailItem(s.age, child.age),
                  _buildDetailItem(
                      s.dateOfBirth, _formatDate(child.dateOfBirth)),
                  _buildDetailItem(s.startDate, _formatDate(child.startDate)),
                  _buildDetailItem(s.endDate, _formatDate(child.endDate)),
                  _buildDetailItem(s.period, child.period),
                  _buildDetailItem(s.gender, child.gender),
                  _buildDetailItem(s.school, child.school),
                  _buildDetailItem(s.residence, child.residence),
                  _buildDetailItem(s.parentPhone, child.parentPhoneNumber),
                  _buildDetailItem(s.notes, child.notes),
                ],
              ),

              _buildSection(
                context,
                s.familyInformation,
                [
                  _buildDetailItem(s.fatherOccupation, child.fatherOccupation),
                  _buildDetailItem(s.motherOccupation, child.motherOccupation),
                  _buildDetailItem(s.familyMembers, child.familyMembers),
                  _buildDetailItem(
                      s.siblingsInfluence, child.siblingsInfluence),
                  _buildDetailItem(s.siblingCloseness, child.siblingCloseness),
                  _buildDetailItem(s.motherAge, child.motherAge),
                  _buildDetailItem(
                      s.parentsRelationship, child.parentsRelationship),
                  _buildDetailItem(
                      s.familyRelationship, child.familyRelationship),
                  _buildDetailItem(s.motherNature, child.motherNature),
                ],
              ),

              _buildSection(
                context,
                s.pregnancyPhase,
                [
                  _buildDetailItem(s.pregnancyNature, child.pregnancyNature),
                  _buildDetailItem(s.motherDiseasesDuringPregnancy,
                      child.motherDiseasesDuringPregnancy),
                  _buildDetailItem(
                      s.pregnancyComplications, child.pregnancyComplications),
                  _buildDetailItem(s.motherStressDuringPregnancy,
                      child.motherStressDuringPregnancy),
                ],
              ),

              _buildSection(
                context,
                s.birthPhase,
                [
                  _buildDetailItem(s.birthType, child.birthType),
                  _buildDetailItem(
                      s.birthComplications, child.birthComplications),
                  _buildDetailItem(s.birthTiming, child.birthTiming),
                ],
              ),

              _buildSection(
                context,
                s.postBirth,
                [
                  _buildDetailItem(s.incubator, child.incubator),
                  _buildDetailItem(s.incubatorPeriod, child.incubatorPeriod),
                  _buildDetailItem(s.jaundice, child.jaundice),
                  _buildDetailItem(s.jaundiceRate, child.jaundiceRate),
                ],
              ),

              _buildSection(
                context,
                s.healthHistory,
                [
                  _buildDetailItem(s.vaccinations, child.vaccinations),
                  _buildDetailItem(s.measles, child.measles),
                  _buildDetailItem(s.smallpox, child.smallpox),
                  _buildDetailItem(s.medications, child.medications),
                ],
              ),

              _buildSection(
                context,
                s.firstYearGrowth,
                [
                  _buildDetailItem(s.teething, child.teething),
                  _buildDetailItem(s.babbling, child.babbling),
                  _buildDetailItem(s.mothersStressDuringPregnancy,
                      child.motherVoiceAttention),
                  _buildDetailItem(s.sittingAlone, child.sittingAlone),
                  _buildDetailItem(s.crawling, child.crawling),
                  _buildDetailItem(s.walking, child.walking),
                  _buildDetailItem(s.handPointing, child.handPointing),
                ],
              ),

              _buildSection(
                context,
                s.psychologicalHistory,
                [
                  _buildDetailItem(
                      s.familyDisabilities, child.familyDisabilities),
                ],
              ),

              _buildSection(
                context,
                s.socialHistory,
                [
                  _buildDetailItem(
                      s.socialInteraction, child.socialInteraction),
                  _buildDetailItem(s.parentAbsence, child.parentAbsence),
                ],
              ),

              _buildSection(
                context,
                s.medicalExaminations,
                [
                  _buildDetailItem(s.hearing, child.hearing),
                  _buildDetailItem(s.vision, child.vision),
                  _buildDetailItem(s.respiratory, child.respiratory),
                  _buildDetailItem(s.digestive, child.digestive),
                  _buildDetailItem(s.neurology, child.neurology),
                  _buildDetailItem(s.circulatory, child.circulatory),
                  _buildDetailItem(s.vocal, child.vocal),
                  _buildDetailItem(s.head, child.head),
                  _buildDetailItem(s.speech, child.speech),
                  _buildDetailItem(s.lips, child.lips),
                  _buildDetailItem(s.teeth, child.teeth),
                  _buildDetailItem(s.palate, child.palate),
                  _buildDetailItem(s.tongue, child.tongue),
                  _buildDetailItem(s.upperJaw, child.upperJaw),
                  _buildDetailItem(s.lowerJaw, child.lowerJaw),
                  _buildDetailItem(s.pharynx, child.pharynx),
                  _buildDetailItem(s.throat, child.throat),
                ],
              ),

              _buildSection(
                context,
                s.diagnosis,
                [
                  _buildDetailItem(s.diagnosisDetails, child.diagnosis),
                ],
              ),

              _buildSection(
                context,
                s.doctorInformation,
                [
                  _buildDetailItem(s.doctorName, child.doctorName),
                  _buildDetailItem(s.doctorPhone, child.doctorPhone),
                ],
              ),

              const SizedBox(height: 24),

              // Print Report Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _printChildReport(context);
                  },
                  icon: const Icon(Icons.print),
                  label: Text(s.printReport),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildHeader(
    BuildContext context,
    s,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Theme.of(context).cardColor : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar and name section
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  child: Text(
                    child.name.isNotEmpty ? child.name[0] : "?",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${s.age}: ${child.age}",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Key information row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeaderInfoItem(context, Icons.calendar_today, s.startDate,
                    _formatDate(child.startDate), textColor),
                _buildHeaderInfoItem(context, Icons.calendar_month, s.endDate,
                    _formatDate(child.endDate), textColor),
                _buildHeaderInfoItem(
                    context, Icons.school, s.school, child.school, textColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfoItem(BuildContext context, IconData icon, String label,
      String value, Color textColor) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value.isNotEmpty ? value : "-",
            style: TextStyle(
              fontSize: 12,
              color: textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final headerColor = isDarkMode
        ? Theme.of(context).primaryColor
        : Theme.of(context).primaryColor;
    final cardColor = isDarkMode ? Theme.of(context).cardColor : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            width: double.infinity,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl, // Force RTL for Arabic support
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : "-",
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _printChildReport(BuildContext context) async {
    final s = S.of(context);

    // Create a PDF document
    final pdf = pw.Document();

    // Load a font that supports Arabic
    final fontData =
        await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    // Define the styles
    final headerStyle =
        pw.TextStyle(font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold);
    final sectionStyle =
        pw.TextStyle(font: ttf, fontSize: 14, fontWeight: pw.FontWeight.bold);
    final labelStyle =
        pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.bold);
    final valueStyle = pw.TextStyle(font: ttf, fontSize: 12);

    // Define the page theme with right-to-left support
    final theme = pw.ThemeData.withFont(
      base: ttf,
    );

    // A function to build section content
    pw.Padding buildSection(String title, List<Map<String, String>> items) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 10),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              color: PdfColors.blue100,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(title,
                  style: sectionStyle, textDirection: pw.TextDirection.rtl),
            ),
            pw.SizedBox(height: 5),
            ...items.map((item) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          "${item['label']}:",
                          style: labelStyle,
                          textDirection: pw.TextDirection.rtl,
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          item['value'] ?? "-",
                          style: valueStyle,
                          textDirection: pw.TextDirection.rtl,
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );
    }

    // Add pages to the PDF
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          theme: theme,
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
        ),
        header: (context) => pw.Center(
          child: pw.Column(
            children: [
              pw.Text(s.childDetails,
                  style: headerStyle, textDirection: pw.TextDirection.rtl),
              pw.SizedBox(height: 5),
              pw.Divider(),
            ],
          ),
        ),
        footer: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(DateTime.now().toString().split(' ')[0]),
            pw.Text('${context.pageNumber}/${context.pagesCount}'),
          ],
        ),
        build: (context) => [
          // Child name and basic info at the top
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 1, color: PdfColors.grey300),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
            ),
            child: pw.Row(
              children: [
                pw.Container(
                  width: 60,
                  height: 60,
                  decoration: const pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    color: PdfColors.blue100,
                  ),
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    child.name.isNotEmpty ? child.name[0] : "?",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(child.name,
                          style: pw.TextStyle(
                              font: ttf,
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold),
                          textDirection: pw.TextDirection.rtl),
                      pw.Text("${s.age}: ${child.age}",
                          style: pw.TextStyle(font: ttf, fontSize: 12),
                          textDirection: pw.TextDirection.rtl),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Basic information section
          buildSection(s.basicInformation, [
            {'label': s.childName, 'value': child.name},
            {'label': s.age, 'value': child.age},
            {'label': s.dateOfBirth, 'value': _formatDate(child.dateOfBirth)},
            {'label': s.startDate, 'value': _formatDate(child.startDate)},
            {'label': s.endDate, 'value': _formatDate(child.endDate)},
            {'label': s.period, 'value': child.period},
            {'label': s.gender, 'value': child.gender},
            {'label': s.school, 'value': child.school},
            {'label': s.residence, 'value': child.residence},
            {'label': s.parentPhone, 'value': child.parentPhoneNumber},
            {'label': s.notes, 'value': child.notes},
          ]),

          // Family information section
          buildSection(s.familyInformation, [
            {'label': s.fatherOccupation, 'value': child.fatherOccupation},
            {'label': s.motherOccupation, 'value': child.motherOccupation},
            {'label': s.familyMembers, 'value': child.familyMembers},
            {'label': s.siblingsInfluence, 'value': child.siblingsInfluence},
            {'label': s.siblingCloseness, 'value': child.siblingCloseness},
            {'label': s.motherAge, 'value': child.motherAge},
            {
              'label': s.parentsRelationship,
              'value': child.parentsRelationship
            },
            {'label': s.familyRelationship, 'value': child.familyRelationship},
            {'label': s.motherNature, 'value': child.motherNature},
          ]),

          // Pregnancy phase section
          buildSection(s.pregnancyPhase, [
            {'label': s.pregnancyNature, 'value': child.pregnancyNature},
            {
              'label': s.motherDiseasesDuringPregnancy,
              'value': child.motherDiseasesDuringPregnancy
            },
            {
              'label': s.pregnancyComplications,
              'value': child.pregnancyComplications
            },
            {
              'label': s.motherStressDuringPregnancy,
              'value': child.motherStressDuringPregnancy
            },
          ]),

          // Birth phase section
          buildSection(s.birthPhase, [
            {'label': s.birthType, 'value': child.birthType},
            {'label': s.birthComplications, 'value': child.birthComplications},
            {'label': s.birthTiming, 'value': child.birthTiming},
          ]),

          // Post-birth section
          buildSection(s.postBirth, [
            {'label': s.incubator, 'value': child.incubator},
            {'label': s.incubatorPeriod, 'value': child.incubatorPeriod},
            {'label': s.jaundice, 'value': child.jaundice},
            {'label': s.jaundiceRate, 'value': child.jaundiceRate},
          ]),

          // Health history section
          buildSection(s.healthHistory, [
            {'label': s.vaccinations, 'value': child.vaccinations},
            {'label': s.measles, 'value': child.measles},
            {'label': s.smallpox, 'value': child.smallpox},
            {'label': s.medications, 'value': child.medications},
          ]),

          // First year growth section
          buildSection(s.firstYearGrowth, [
            {'label': s.teething, 'value': child.teething},
            {'label': s.babbling, 'value': child.babbling},
            {
              'label': "motherVoiceAttention",
              'value': child.motherVoiceAttention
            },
            {'label': s.sittingAlone, 'value': child.sittingAlone},
            {'label': s.crawling, 'value': child.crawling},
            {'label': s.walking, 'value': child.walking},
            {'label': s.handPointing, 'value': child.handPointing},
          ]),

          // Psychological history section
          buildSection(s.psychologicalHistory, [
            {'label': s.familyDisabilities, 'value': child.familyDisabilities},
          ]),

          // Social history section
          buildSection(s.socialHistory, [
            {'label': s.socialInteraction, 'value': child.socialInteraction},
            {'label': s.parentAbsence, 'value': child.parentAbsence},
          ]),

          // Medical examinations section
          buildSection(s.medicalExaminations, [
            {'label': s.hearing, 'value': child.hearing},
            {'label': s.vision, 'value': child.vision},
            {'label': s.respiratory, 'value': child.respiratory},
            {'label': s.digestive, 'value': child.digestive},
            {'label': s.neurology, 'value': child.neurology},
            {'label': s.circulatory, 'value': child.circulatory},
            {'label': s.vocal, 'value': child.vocal},
            {'label': s.head, 'value': child.head},
            {'label': s.speech, 'value': child.speech},
            {'label': s.lips, 'value': child.lips},
            {'label': s.teeth, 'value': child.teeth},
            {'label': s.palate, 'value': child.palate},
            {'label': s.tongue, 'value': child.tongue},
            {'label': s.upperJaw, 'value': child.upperJaw},
            {'label': s.lowerJaw, 'value': child.lowerJaw},
            {'label': s.pharynx, 'value': child.pharynx},
            {'label': s.throat, 'value': child.throat},
          ]),

          // Diagnosis section
          buildSection(s.diagnosis, [
            {'label': s.diagnosisDetails, 'value': child.diagnosis},
          ]),

          // Doctor information section
          buildSection(s.doctorInformation, [
            {'label': s.doctorName, 'value': child.doctorName},
            {'label': s.doctorPhone, 'value': child.doctorPhone},
          ]),
        ],
      ),
    );

    // Show print dialog
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${child.name}_${DateTime.now().toString().split(' ')[0]}',
    );
  }
}
