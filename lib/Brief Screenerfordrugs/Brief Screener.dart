import 'package:flutter/material.dart';
import 'package:natamilnaduproject/Brief%20Screenerfordrugs/breifscreeningpage.dart';
import 'package:natamilnaduproject/Homescreen.dart';

class Briefscreenerdrugs extends StatefulWidget {
  const Briefscreenerdrugs({super.key});

  @override
  State<Briefscreenerdrugs> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Briefscreenerdrugs> {
  bool isExpanded = false;
  List<String?> answers = List.filled(10, null);

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("PATIENT"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  "This health survey will ask you questions about your use of substances, including tobacco, marijuana, and alcohol. "
                  "This information will help your health care provider make the best recommendations for your overall care. "
                  "Please consult your provider to discuss your responses.",
                ),
                SizedBox(height: 20),
                Text(
                  "Please ask your health care provider about any concerns you have regarding confidentiality before taking this survey.",
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Start",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuizScreen()), // Navigate to RegisterPage
                );
                print("Survey Started");
              },
            ),
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialogforclinic() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("CLINICIAN"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  "This health survey will ask you questions about your use of substances, including tobacco, marijuana, and alcohol. "
                  "This information will help your health care provider make the best recommendations for your overall care. "
                  "Please consult your provider to discuss your responses.",
                ),
                SizedBox(height: 20),
                Text(
                  "Please ask your health care provider about any concerns you have regarding confidentiality before taking this survey.",
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Start",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()),
                );
                print("Survey Started");
              },
            ),
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Brief Screener for Tobacco, Alcohol, and other Drugs"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Homescreen()),
              );
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Main Heading
              Text(
                "This screening tool consists of frequency of use questions to categorize substance use by\n adolescent patients into different risk categories. The accompanying resources assist \n clinicians in providing patient feedback and resources for follow-up.",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Dropdown Section
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Screening Tool Cutoffs and Scoring Thresholds",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal[800],
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Colors.teal[800],
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "S2BI asks a single frequency question for past year’s use of the three substances most commonly used by adolescents: tobacco, alcohol, and marijuana. An affirmative response prompts questions about additional types of substances used. For each substance, responses can be categorized into levels of risk. Each risk level maps onto suggested clinical actions summarized on the results screen.\n\n",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "S2BI Response / Risk Category\n"
                        "• Never: No Reported Use\n"
                        "• Once or twice: Lower Risk\n"
                        "• Monthly+: Higher Risk\n\n",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Tool Validation:\n"
                        "Psychometric properties for the S2BI tool were first described by Levy et al. in 2014. "
                        "S2BI was originally validated in a relatively small study in pediatric medical settings. "
                        "In a recent study (2023) by Levy and colleagues found a high agreement between S2BI screening results "
                        "and the criterion standard measure demonstrating additional psychometric validation. "
                        "The findings from this research are consistent with similar research in adults and support the principle "
                        "of frequency-based screening as a good mechanism for detecting adolescents that are at high risk for substance use disorders.\n\n",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Developer's JSON Application Programming Interface Available Here. For additional information on how to use this feed and example code, use this form to talk with our development team.",
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "References:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "1. Levy, S., Weiss, R., Sherritt, L., Ziemnik, R., Spalding, A., Van Hook, S., & Shrier, L. A. "
                        "(2014). An electronic screen for triaging adolescent substance use by risk levels. JAMA Pediatrics. "
                        "168(9), 822-828. [Link](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4270364/)\n\n",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "2. Levy S, Brogna M, Minegishi M, Subramaniam G, McCormack J, Kline M, Menzin E, "
                        "Allende-Richter S, Fuller A, Lewis M, Collins J, Hubbard Z, Mitchell SG, Weiss R, Weitzman E. "
                        "Assessment of Screening Tools to Identify Substance Use Disorders Among Adolescents. JAMA Netw Open. "
                        "2023 May 1;6(5):e2314422. doi: 10.1001/jamanetworkopen.2023.14422.\n\n",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

              // Row of Buttons
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showAlertDialog(); // Show the alert dialog
                    },
                    child: Text("I AM THE PATIENT"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Button color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showAlertDialogforclinic(); // Show the alert dialog
                    },
                    child: Text("I AM THE CLINICIAN"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Button color
                    ),
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
