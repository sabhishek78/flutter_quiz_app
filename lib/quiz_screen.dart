import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({Key key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map questions = new Map();
  List sortedQuestions =[];
  int questionIndex = 0;
  bool isLoading = false;
  int score = 0;
  int _radioValue = -1;

  @override
  void initState() {
    fetchQuestions();
    super.initState();
    isLoading = true;
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  fetchQuestions() async {
    var response = await http.post("https://opentdb.com/api.php?amount=20");
    questions = jsonDecode(response.body);
    // print(questions["results"]);
    for(int i=0;i<questions["results"].length;i++){
      if (questions["results"][i]
      ["incorrect_answers"].length==3){
       sortedQuestions.add(questions["results"][i]);
      }
    }
    print(sortedQuestions.length);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "QUESTIONS",
        ),
        elevation: 0.0,
        actions: <Widget>[],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.cyan,
                  strokeWidth: 5,
                ),
              )
            : Center(
                child: Container(
                  child: questionIndex < 10
                      ? Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Question",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              sortedQuestions[questionIndex]["question"],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Radio(
                                  value: 0,
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text(
                                  sortedQuestions[questionIndex]
                                      ["correct_answer"],
                                  style: new TextStyle(fontSize: 16.0),
                                ),

                                  new Radio(
                                    value: 1,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text(
                                    sortedQuestions[questionIndex]
                                    ["incorrect_answers"][0],
                                    style: new TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),

                                new Radio(
                                  value: 2,
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text(
                                  sortedQuestions[questionIndex]
                                      ["incorrect_answers"][1],
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                                new Radio(
                                  value: 3,
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text(
                                  sortedQuestions[questionIndex]
                                      ["incorrect_answers"][2],
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            RaisedButton(
                              child: Text(
                                "SUBMIT ANSWER",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                print("radioValue=" + _radioValue.toString());

                                if (_radioValue == 0) {
                                  score++;
                                  questionIndex++;

                                  _radioValue = -1;
                                  setState(() {});
                                } else {
                                  questionIndex++;
                                  _radioValue = -1;
                                  setState(() {});
                                }
                              },
                              color: Theme.of(context).accentColor,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              "Score= " + score.toString() + "/10",
                              style: new TextStyle(fontSize: 16.0),
                            ),
                          ],
                        )
                      : Column(children: [
                          Text(
                            "SCORE",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "Score= " + score.toString() + "/10",
                            style: new TextStyle(fontSize: 16.0),
                          ),
                          RaisedButton(
                            child: Text(
                              "RESTART",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return QuizScreen();
                                  },
                                ),
                              );
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ]),
                ),
              ),
      ),
    );
  }
}
