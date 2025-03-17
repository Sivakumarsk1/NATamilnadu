import 'package:flutter/material.dart';
import 'package:natamilnaduproject/Brief%20Screenerfordrugs/Brief%20Screener.dart';
import 'package:natamilnaduproject/Screening%20to%20Brief%20Intervention/Screening%20to%20Brief%20Intervention.dart';

void main() {
  runApp(Homescreen());
}

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with TickerProviderStateMixin {
  double _scale1 = 1.0;
  double _scale2 = 1.0;

  void _onTapDown1(TapDownDetails details) {
    setState(() {
      _scale1 = 0.95;
    });
  }

  void _onTapUp1(TapUpDetails details) {
    setState(() {
      _scale1 = 1.0;
    });
  }

  void _onTapDown2(TapDownDetails details) {
    setState(() {
      _scale2 = 0.95;
    });
  }

  void _onTapUp2(TapUpDetails details) {
    setState(() {
      _scale2 = 1.0;
    });
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
          title: Text(
            "Screening Tools for Adolescent Substance Use",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "NIDA Launches Two Brief Online Validated Adolescent Substance Use Screening Tools",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),

              Text(
                "NIDA has launched two brief online screening tools that providers can use to assess for substance use disorder (SUD) risk among adolescents 12-17 years old. With the American Academy of Pediatrics recommending universal screening in pediatric primary care settings, these tools help providers quickly and easily introduce brief, evidence-based screenings into their clinical practices.",
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 30),

              // Row for Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTapDown: _onTapDown2,
                      onTapUp: _onTapUp2,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Screeningbrief()),
                        );
                        print("Screening to Brief Intervention (S2BI) Pressed");
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        transform: Matrix4.identity()..scale(_scale2),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            shadowColor: Colors.purpleAccent.withOpacity(0.5),
                          ),
                          child: Text(
                            "Screening to Brief Intervention (S2BI) Pressed",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Screeningbrief()),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTapDown: _onTapDown2,
                      onTapUp: _onTapUp2,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Briefscreenerdrugs()),
                        );
                        print(
                            "Brief Screener For Tobacco, Alcohol, and other Drugs (BSTAD) Pressed");
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        transform: Matrix4.identity()..scale(_scale2),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            shadowColor: Colors.purpleAccent.withOpacity(0.5),
                          ),
                          child: Text(
                            "Brief Screener For\nTobacco, Alcohol, and other Drugs (BSTAD)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Briefscreenerdrugs()),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Empowering Providers with Evidence-Based Tools",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
