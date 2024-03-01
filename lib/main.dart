import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CGPACalculator(),
    theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0, // Remove appbar elevation
      ),
    ),
  ));
}

class Course {
  String name;
  String grade;
  double credits;

  Course({required this.name, required this.grade, required this.credits});
}

class CGPACalculator extends StatefulWidget {
  @override
  _CGPACalculatorState createState() => _CGPACalculatorState();
}

class _CGPACalculatorState extends State<CGPACalculator> {
  List<List<Course>> _semesterCourses = List.generate(
    8, // Number of semesters
        (index) => [], // Initialize each semester with an empty list of courses
  );
  List<String> _semesters = List.generate(
    8,
        (index) => 'Semester ${index + 1}',
  ); // Define semesters
  String _selectedSemester = 'Semester 1'; // Initially selected semester
  double _sgpa = 0.0; // Variable to store SGPA
  double _cgpa = 0.0; // Variable to store CGPA

  // Mapping of grades to grade points
  Map<String, double> _gradePointMap = {
    'A': 10.0,
    'A-': 9.0,
    'B': 8.0,
    'B-': 7.0,
    'C': 6.0,
    'C-': 5.0,
    'D': 4.0,
    'D-': 3.0,
    'E': 2.0,
    'F': 1.0,
    'NC':0,
    'CLR':0
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BITSIAN CGPA'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedSemester,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSemester = newValue!;
                });
              },
              items: _semesters.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Semester',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
              _semesterCourses[_semesters.indexOf(_selectedSemester)]
                  .length,
              itemBuilder: (context, index) {
                Course course = _semesterCourses[_semesters.indexOf(
                    _selectedSemester)][index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Course ${index + 1}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          initialValue: course.name,
                          decoration: InputDecoration(
                            labelText: 'Course Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              course.name = value;
                            });
                          },
                        ),
                        SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: course.grade,
                          onChanged: (value) {
                            setState(() {
                              course.grade = value!;
                            });
                          },
                          items: _gradePointMap.keys.map<
                              DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Grade',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 8),
                        DropdownButtonFormField<double>(
                          value: course.credits,
                          onChanged: (value) {
                            setState(() {
                              course.credits = value!;
                            });
                          },
                          items: [1, 2, 3, 4].map<DropdownMenuItem<double>>(
                                (int value) {
                              return DropdownMenuItem<double>(
                                value: value.toDouble(),
                                child: Text(value.toString()),
                              );
                            },
                          ).toList(),
                          decoration: InputDecoration(
                            labelText: 'Credits',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _calculateSGPA(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Calculate SGPA'),
                ),
                ElevatedButton(
                  onPressed: () => _calculateCGPA(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Calculate CGPA'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'SGPA: ${_sgpa.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.black87),
                ),
                Text(
                  'CGPA: ${_cgpa.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Semester Credits: ${_getTotalSemesterCredits().toStringAsFixed(2)}',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            _semesterCourses[_semesters.indexOf(_selectedSemester)].add(
                Course(name: '', grade: 'A', credits: 1.0));
            // Initialize the new course with default values
          });
        },
      ),
    );
  }

  void _calculateSGPA() {
    List<Course> courses = _semesterCourses[
    _semesters.indexOf(_selectedSemester)];
    double totalGradePoints = 0.0;
    double totalCredits = 0.0;

    // Calculate total grade points and credits
    for (var course in courses) {
      if (course.credits > 0) {
        double gradePoint = _gradePointMap[course.grade] ?? 0.0;
        totalGradePoints += gradePoint * course.credits;
        totalCredits += course.credits;
      }
    }

    // Calculate SGPA only if total credits are greater than zero
    if (totalCredits > 0) {
      setState(() {
        _sgpa = totalGradePoints / totalCredits;
      });
      print('SGPA for $_selectedSemester: $_sgpa');
    } else {
      print('No courses found for $_selectedSemester');
    }
  }

  void _calculateCGPA() {
    double totalGradePoints = 0.0;
    double totalCredits = 0.0;

    // Iterate through all semesters and their courses
    for (var semesterCourses in _semesterCourses) {
      for (var course in semesterCourses) {
        if (course.credits > 0) {
          double gradePoint = _gradePointMap[course.grade] ?? 0.0;
          totalGradePoints += gradePoint * course.credits;
          totalCredits += course.credits;
        }
      }
    }

    // Calculate CGPA only if total credits are greater than zero
    if (totalCredits > 0) {
      setState(() {
        _cgpa = totalGradePoints / totalCredits;
      });
      print('CGPA: $_cgpa');
    } else {
      print('No courses found for calculating CGPA');
    }
  }

  double _getTotalSemesterCredits() {
    double totalCredits = 0.0;
    List<Course> courses =
    _semesterCourses[_semesters.indexOf(_selectedSemester)];

    // Calculate total credits for the selected semester
    for (var course in courses) {
      totalCredits += course.credits;
    }

    return totalCredits;
  }
}
