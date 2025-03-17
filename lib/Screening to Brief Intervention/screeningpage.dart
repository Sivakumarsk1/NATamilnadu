import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<String> questions = [
    "In the PAST YEAR, how many times have you used tobacco?",
    "In the PAST YEAR, how many times have you used alcohol?",
    "In the PAST YEAR, how many times have you used marijuana?",
    "In the PAST YEAR, how many times have you used prescription drugs?",
    "In the PAST YEAR, how many times have you used illegal drugs?",
    "In the PAST YEAR, how many times have you used inhalants?",
    "In the PAST YEAR, how many times have you used synthetic drugs?",
  ];

  final List<String> options = [
    "Weekly Or More",
    "Monthly",
    "Once or Twice",
    "Never"
  ];

  Map<int, String> userResponses = {};
  int currentQuestionIndex = 0;
  int neverCount = 0;

  double getCompletionPercentage() {
    return ((currentQuestionIndex + 1) / questions.length) * 100;
  }

  void nextQuestion(String response) {
    setState(() {
      userResponses[currentQuestionIndex] = response;

      if (currentQuestionIndex < 3 && response == "Never") {
        neverCount++;
      }

      if (currentQuestionIndex == 2 && neverCount == 3) {
        showResult(
            "No Reported Use", "You have reported no use of major substances.");
        return;
      }

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        evaluateRisk();
      }
    });
  }

  void previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  void nextQuestion1() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex++;
      }
    });
  }

  void evaluateRisk() {
    int highRiskCount = 0;
    int lowerRiskCount = 0;

    for (int i = 0; i < questions.length; i++) {
      String? response = userResponses[i];

      if (response == "Weekly Or More" || response == "Monthly") {
        highRiskCount++;
      } else if (response == "Once or Twice") {
        lowerRiskCount++;
      }
    }

    String riskLevel;
    String riskDetails;

    if (highRiskCount > 0) {
      riskLevel = "Higher Risk Level";
      riskDetails =
          "You may be at risk for Substance Use Disorder. Consider professional advice\nDrug Identified:Synthetic Cannabinoids, Tobacco, Alcohol, Marijuana, Prescription Drugs, Inhalants.";
    } else if (lowerRiskCount > 0) {
      riskLevel = "Lower Risk Level";
      riskDetails = "Your substance use is low, but avoid future risks.";
    } else {
      riskLevel = "No Reported Use";
      riskDetails = "You have reported no use of major substances.";
    }

    showResult(riskLevel, riskDetails);
  }

  void showResult(String riskLevel, String riskDetails) {
    Color riskColor;

    if (riskLevel == "Higher Risk Level") {
      riskColor = Colors.red;
    } else if (riskLevel == "Lower Risk Level") {
      riskColor = Colors.green;
    } else {
      riskColor = Colors.yellow;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BounceInUp(
          duration: Duration(milliseconds: 500),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeIn(
                  duration: Duration(milliseconds: 600),
                  child: Text(
                    "Assessment Result",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                SizedBox(height: 15),
                FadeIn(
                  duration: Duration(milliseconds: 700),
                  child: Text(
                    riskLevel,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: riskColor, // Color changes dynamically
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FadeIn(
                  duration: Duration(milliseconds: 800),
                  child: Text(
                    riskDetails,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                FadeIn(
                  duration: Duration(milliseconds: 900),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  ),
                ),
                SizedBox(height: 10),
                FadeIn(
                  duration: Duration(milliseconds: 1000),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => generatePDF(riskLevel, riskDetails),
                    icon: Icon(Icons.download),
                    label: Text("Download PDF"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> generatePDF(String riskLevel, String riskDetails) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text("Assessment Result",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text(riskLevel,
                  style: pw.TextStyle(fontSize: 18, color: PdfColors.red)),
              pw.SizedBox(height: 10),
              pw.Text(riskDetails, textAlign: pw.TextAlign.center),
            ],
          ),
        ),
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/Assessment_Result.pdf");
    await file.writeAsBytes(await pdf.save());

    final xFile = XFile(file.path);

    Share.shareXFiles([xFile], text: "Download your assessment result.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hides the back arrow
        backgroundColor: Colors.purple,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'images/llogo.png',
                height: 40,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Text(
                  'Substance Use Quiz',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'images/llogo.png',
                height: 40,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),

              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 400),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Question ${currentQuestionIndex + 1}',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Question text with animation
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 400),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      questions[currentQuestionIndex],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Options with animation
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 400),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 1,
                            vertical: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.white70,
                          foregroundColor: Colors.black87,
                          elevation: 2,
                        ),
                        onPressed: () => nextQuestion(option),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              option,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(
                  begin: 0,
                  end: getCompletionPercentage() / 100,
                ),
                builder: (context, value, _) => Column(
                  children: [
                    LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(value * 100).toInt()}% Complete',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: previousQuestion,
                    child: const Text('Previous'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (currentQuestionIndex < questions.length - 1) {
                        setState(() {
                          currentQuestionIndex++;
                        });
                      } else {
                        evaluateRisk();
                      }
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
