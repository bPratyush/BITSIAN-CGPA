import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CGPACalculator(),
  ));
}

class CGPACalculator extends StatefulWidget {
  @override
  _CGPACalculatorState createState() => _CGPACalculatorState();
}

class _CGPACalculatorState extends State<CGPACalculator> {
  final List<TextEditingController> _gradeControllers = [];
  final List<TextEditingController> _creditControllers = [];
  double _cgpa = 0.0;

  void _calculateCGPA() {
    double totalGradePoints = 0.0;
    double totalCredits = 0.0;
    for (int i = 0; i < _gradeControllers.length; i++) {
      double grade = double.parse(_gradeControllers[i].text);
      double credit = double.parse(_creditControllers[i].text);
      totalGradePoints += grade * credit;
      totalCredits += credit;
    }
    setState(() {
      _cgpa = totalGradePoints / totalCredits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CGPA Calculator'),
      ),
      body: ListView.builder(
        itemCount: _gradeControllers.length + 1,
        itemBuilder: (context, index) {
          if (index == _gradeControllers.length) {
            return ElevatedButton(
              child: Text('Calculate CGPA'),
              onPressed: _calculateCGPA,
            );
          }
          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _gradeControllers[index],
                  decoration: InputDecoration(hintText: 'Grade'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _creditControllers[index],
                  decoration: InputDecoration(hintText: 'Credit Hours'),
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    _gradeControllers.removeAt(index);
                    _creditControllers.removeAt(index);
                  });
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            _gradeControllers.add(TextEditingController());
            _creditControllers.add(TextEditingController());
          });
        },
      ),
    );
  }
}
