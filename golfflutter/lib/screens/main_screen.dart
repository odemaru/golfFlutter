import 'package:flutter/material.dart';
import '../models/hole.dart';
import '../models/green.dart';
import '../models/shot.dart';
import '../utils/gir_calculator.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _parController = TextEditingController();
  final _frontXController = TextEditingController();
  final _frontYController = TextEditingController();
  final _middleXController = TextEditingController();
  final _middleYController = TextEditingController();
  final _backXController = TextEditingController();
  final _backYController = TextEditingController();
  
  List<Map<String, TextEditingController>> shots = [];
  String? result;

  @override
  void initState() {
    super.initState();
    addShot();
  }

  void addShot() {
    setState(() {
      shots.add({
        'x': TextEditingController(),
        'y': TextEditingController(),
      });
    });
  }

  void removeShot(int index) {
    if (shots.length > 1) {
      setState(() {
        shots[index]['x']?.dispose();
        shots[index]['y']?.dispose();
        shots.removeAt(index);
      });
    }
  }

  void checkGir() {
    if (_parController.text.isEmpty ||
        _frontXController.text.isEmpty || _frontYController.text.isEmpty ||
        _middleXController.text.isEmpty || _middleYController.text.isEmpty ||
        _backXController.text.isEmpty || _backYController.text.isEmpty) {
      setState(() {
        result = 'Please fill all fields';
      });
      return;
    }

    for (var shot in shots) {
      if (shot['x']!.text.isEmpty || shot['y']!.text.isEmpty) {
        setState(() {
          result = 'Please fill all shot coordinates';
        });
        return;
      }
    }

    try {
      int par = int.parse(_parController.text);
      
      Green green = Green(
        front: Shot(
          x: int.parse(_frontXController.text),
          y: int.parse(_frontYController.text),
        ),
        middle: Shot(
          x: int.parse(_middleXController.text),
          y: int.parse(_middleYController.text),
        ),
        back: Shot(
          x: int.parse(_backXController.text),
          y: int.parse(_backYController.text),
        ),
      );
      
      List<Shot> shotsList = shots.map((s) {
        return Shot(
          x: int.parse(s['x']!.text),
          y: int.parse(s['y']!.text),
        );
      }).toList();
      
      Hole hole = Hole(par: par, green: green, shots: shotsList);
      bool gir = GirCalculator.checkGIR(hole);
      
      setState(() {
        result = gir ? 'GIR Achieved!' : 'GIR Not Achieved';
      });
    } catch (e) {
      setState(() {
        result = 'Error: Invalid input';
      });
    }
  }

  Widget _buildCoordInput(TextEditingController controller, String label, {bool isDark = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.black54 : Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.black26 : Color(0xFFD9D9D9))
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black)
        ),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('GIR Calculator', style: TextStyle(color: Colors.black)),
          backgroundColor: Color(0xFFD9D9D9),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoordInput(_parController, 'Par'),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Green Coordinates:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildCoordInput(_frontXController, 'Front X', isDark: true)),
                        SizedBox(width: 10),
                        Expanded(child: _buildCoordInput(_frontYController, 'Front Y', isDark: true)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildCoordInput(_middleXController, 'Middle X', isDark: true)),
                        SizedBox(width: 10),
                        Expanded(child: _buildCoordInput(_middleYController, 'Middle Y', isDark: true)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildCoordInput(_backXController, 'Back X', isDark: true)),
                        SizedBox(width: 10),
                        Expanded(child: _buildCoordInput(_backYController, 'Back Y', isDark: true)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shots:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  ElevatedButton(
                    onPressed: addShot,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD9D9D9),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                      overlayColor: Colors.black.withOpacity(0.1),
                    ),
                    child: Text('Add Shot'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ...List.generate(shots.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(child: _buildCoordInput(shots[index]['x']!, 'Shot ${index + 1} X')),
                      SizedBox(width: 10),
                      Expanded(child: _buildCoordInput(shots[index]['y']!, 'Shot ${index + 1} Y')),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.black54),
                        onPressed: () => removeShot(index),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: checkGir,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD9D9D9),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    elevation: 0,
                    overlayColor: Colors.black.withOpacity(0.1),
                  ),
                  child: Text('Check GIR', style: TextStyle(fontSize: 16)),
                ),
              ),
              if (result != null) ...[
                SizedBox(height: 20),
                Center(
                  child: Text(
                    result!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _parController.dispose();
    _frontXController.dispose();
    _frontYController.dispose();
    _middleXController.dispose();
    _middleYController.dispose();
    _backXController.dispose();
    _backYController.dispose();
    for (var shot in shots) {
      shot['x']?.dispose();
      shot['y']?.dispose();
    }
    super.dispose();
  }
}
