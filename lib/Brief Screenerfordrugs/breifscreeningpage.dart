import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.red,
      title: 'Dynamic Quiz App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: const QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  Map<int, dynamic> answers = {};
  TextEditingController textController = TextEditingController();
  List<String> selectedOptionsQ4 = [];
  List<String> selectedOptionsQ5 = [];
  int dynamicQuestionIndex = 0;
  List<Map<String, dynamic>> dynamicQuestions = [];

  final List<Map<String, dynamic>> questions = [
    {
      'id': 1,
      'type': 'text',
      'text':
          'In the PAST YEAR, on how many days did you smoke cigarettes or use other tobacco products',
    },
    {
      'id': 2,
      'type': 'text',
      'text':
          'In the PAST YEAR, on how many days did you have more than a few sips of beer, wine, or any drink containing alcohol?',
    },
    {
      'id': 3,
      'type': 'text',
      'text':
          'In the PAST YEAR, on how many days did you use marijuana (weed; blunts)?',
    },
    {
      'id': 4,
      'type': 'multiple',
      'text': 'Select all that apply:',
      'options': [
        'cocaine or crack',
        'heroin',
        'amphetamines or methamphetamines (non-medication)',
        'hallucinogen (e.g., magic mushrooms, lsd, etc.)',
        'inhalants (e.g., huffing gasoline, glue, nitrous oxide, etc.)',
        'None of the above'
      ],
    },
    {
      'id': 5,
      'type': 'multiple',
      'text': 'Select all that apply:',
      'options': [
        'prescription pain relievers (e.g., morphine, percocet, vicodin, oxycontin, dilaudid, methadone, buprenorphine, etc.)',
        'prescription sedatives (e.g., valium, xanax, klonopin, ativan, etc.)',
        'prescription stimulants (e.g., adderall, ritalin, etc.)',
        'over-the-counter medications (e.g., nyquil, benadryl, cough medicine, sleeping pills)',
        'None of the above'
      ],
    },
  ];
  void handleTextInput(String value) {
    // Check if the current question is one of the first three
    if (currentQuestion < 3) {
      setState(() {
        answers[currentQuestion] = value.trim();
        currentQuestion++;
      });
      textController.clear();

      // Check if all three questions are answered
      if (currentQuestion == 3) {
        bool allFirstThreeAnswered = true;
        for (int i = 0; i < 1; i++) {
          if (answers[i] == null || answers[i]!.isEmpty) {
            allFirstThreeAnswered = false;
            break;
          }
        }

        if (!allFirstThreeAnswered) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Quiz Ended"),
                content: Text(
                    "You must answer all the first three questions to proceed."),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pop(); // End the quiz and go back
                    },
                  ),
                ],
              );
            },
          );
          return;
        }
      }
      return;
    }

    if (currentQuestion >= 5) {
      setState(() {
        answers[dynamicQuestionIndex] = value.trim();
        dynamicQuestionIndex++;

        if (dynamicQuestionIndex >= dynamicQuestions.length) {
          assessRiskLevel();
        }
      });
      textController.clear();
      return;
    }
  }

  void handleMultipleSelect(String option, int questionId) {
    setState(() {
      if (questionId == 4) {
        if (option == 'None of the above') {
          selectedOptionsQ4 = ['None of the above'];
        } else {
          selectedOptionsQ4.remove('None of the above');
          if (selectedOptionsQ4.contains(option)) {
            selectedOptionsQ4.remove(option);
          } else {
            selectedOptionsQ4.add(option);
          }
        }
      } else if (questionId == 5) {
        if (option == 'None of the above') {
          selectedOptionsQ5 = ['None of the above'];
        } else {
          selectedOptionsQ5.remove('None of the above');
          if (selectedOptionsQ5.contains(option)) {
            selectedOptionsQ5.remove(option);
          } else {
            selectedOptionsQ5.add(option);
          }
        }
      }
    });
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

  void moveToNextQuestion() {
    setState(() {
      if (currentQuestion == 3) {
        answers[3] = selectedOptionsQ4;
        currentQuestion++;
      } else if (currentQuestion == 4) {
        answers[4] = selectedOptionsQ5;
        generateDynamicQuestions();
        currentQuestion++;
      }
    });
  }

  void generateDynamicQuestions() {
    dynamicQuestions.clear();

    for (String option in selectedOptionsQ4) {
      if (option != 'None of the above') {
        dynamicQuestions.add({
          'id': dynamicQuestions.length + 6,
          'type': 'text',
          'text': 'How many days do you use $option?',
        });
      }
    }
    for (String option in selectedOptionsQ5) {
      if (option != 'None of the above') {
        dynamicQuestions.add({
          'id': dynamicQuestions.length + 6,
          'type': 'text',
          'text': 'How many days do you use $option?',
        });
      }
    }
  }

  void assessRiskLevel() {
    String riskLevel = "";
    String message = "";
    String riskDetails = "";

    bool answeredFirstThree = false;
    int maxDaysFirstThree = 0;

    for (int i = 0; i <= 2; i++) {
      if (answers.containsKey(i) && answers[i]!.isNotEmpty) {
        answeredFirstThree = true;
        try {
          int days = int.parse(answers[i]!);
          if (days > maxDaysFirstThree) {
            maxDaysFirstThree = days;
          }
        } catch (e) {}
      }
    }

    bool bothNoneOfAbove = selectedOptionsQ4.contains('None of the above') &&
        selectedOptionsQ5.contains('None of the above');

    int maxDaysDynamic = 0;
    for (int i = 0; i < dynamicQuestions.length; i++) {
      if (answers.containsKey(i)) {
        try {
          int days = int.parse(answers[i]!);
          if (days > maxDaysDynamic) {
            maxDaysDynamic = days;
          }
        } catch (e) {}
      }
    }

    if (!answeredFirstThree && bothNoneOfAbove) {
      riskLevel = "No Risk Level";
      message = "You did not provide any substance use information.";
    } else if (maxDaysFirstThree > 50 && bothNoneOfAbove) {
      riskLevel = "Lower Risk";
      message = "Based on your responses, you have a lower risk level.";
    } else if (!bothNoneOfAbove && maxDaysDynamic > 50) {
      riskLevel = "High Risk";
      message = "Based on your responses, you have a high risk level.";
    } else {
      riskLevel = "Moderate Risk";
      message = "Based on your responses, you have a moderate risk level.";
    }

    _showRiskLevelBottomSheet(riskLevel, message, riskDetails);
  }

  void _showRiskLevelBottomSheet(
      String riskLevel, String message, String riskDetails) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  riskLevel,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                FadeIn(
                  duration: Duration(milliseconds: 700),
                  child: Text(
                    riskLevel,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
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
                SizedBox(height: 10),
                FadeIn(
                  duration: Duration(milliseconds: 1000),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => generatePDF(riskLevel, riskDetails),
                    icon: Icon(Icons.download),
                    label: Text("Download PDF"),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const QuizScreen(),
                        ),
                      );
                    },
                    child: const Text('Start Over',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? currentQ;

    // Check if the quiz is complete
    bool isQuizComplete = currentQuestion >= questions.length &&
        dynamicQuestionIndex >= dynamicQuestions.length;

    if (isQuizComplete) {
      // Quiz is complete, show a completion message or navigate to results
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
                child: Text(
                  'Substance Use Quiz',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Quiz Complete!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to results or restart the quiz
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const QuizScreen(),
                    ),
                  );
                },
                child: const Text('Restart Quiz'),
              ),
            ],
          ),
        ),
      );
    }

    // Assign the current question
    if (currentQuestion < questions.length) {
      currentQ = questions[currentQuestion];
    } else if (dynamicQuestionIndex < dynamicQuestions.length) {
      currentQ = dynamicQuestions[dynamicQuestionIndex];
    }

    // If no valid question is found, return an empty container (should not happen)
    if (currentQ == null) {
      return Container();
    }

    // Render the quiz UI
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'images/llogo.png',
                height: 40,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Risk Assessment Quiz',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
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
              const SizedBox(height: 5),

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
                  child: Text(
                    'Question ${currentQ['id']}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 6),

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
                      currentQ['text'],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
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
                    child: Column(
                      children: [
                        if (currentQ['type'] == 'text') ...[
                          TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                              hintText: 'Type your answer',
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            keyboardType: TextInputType.number,
                            onSubmitted: handleTextInput,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                handleTextInput(textController.text),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Next'),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ] else if (currentQ['type'] == 'multiple') ...[
                          ...currentQ['options'].map<Widget>((option) {
                            bool isSelected = currentQ?['id'] == 4
                                ? selectedOptionsQ4.contains(option)
                                : selectedOptionsQ5.contains(option);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade100,
                                    foregroundColor: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: isSelected ? 4 : 1,
                                  ),
                                  onPressed: () => handleMultipleSelect(
                                      option, currentQ!['id']),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(Icons.check_circle),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 9),
                          if ((currentQ['id'] == 4 &&
                                  selectedOptionsQ4.isNotEmpty) ||
                              (currentQ['id'] == 5 &&
                                  selectedOptionsQ5.isNotEmpty))
                            ElevatedButton(
                              onPressed: moveToNextQuestion,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('Next'),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(
                  begin: 0,
                  end: (currentQ['id'] /
                      (questions.length + dynamicQuestions.length)),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
