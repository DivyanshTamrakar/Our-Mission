import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/solution_detail_screen.dart';
import '../utils/HttpResponse.dart';
import '../utils/colors.dart';
import '../screens/homescreen.dart';

class SolutionScreen extends StatefulWidget {
  @override
  _SolutionScreenState createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen> {
  List<dynamic> solution = [];

  getSolutionData() async {
    var resp = await HttpResponse.getResponse(service: '/users/solution/all');
    print("\n\n$resp\n\n");

    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      solution = response['data'];

      print("solutions list");
      print(solution);
      print(solution.length);
    });
  }

  @override
  void initState() {
    super.initState();
    getSolutionData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HomeScreen.color,
        title: Text(
          "Solved Complaints",
          style: TextStyle(
            color: primary_text_color,
          ),
        ),
        centerTitle: true,
      ),
      body: (solution != null)
          ? (solution.length > 0)
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: solution.length,
                          itemBuilder: (context, i) {
                            return Container(
                              margin: EdgeInsets.all(5),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.grey[300], width: 1.0),
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(4.0),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                SoutionDetailScreen(
                                                    id: solution[i]['_id'])));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 15,
                                        bottom: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: width * 0.5,
                                              child: Text(
                                                solution[i]['title'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            // Spacer(),
                                            Text(
                                              "Complain Id:",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Container(
                                              width: width * 0.2,
                                              child: Text(
                                                solution[i]['_id'] == null
                                                    ? "123"
                                                    : solution[i]['_id'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(height: 20,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Divider(
                                            height: 1,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        Text(
                                          solution[i]['description'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                )
              : Center(
                  child: Text("No complaint Solution Found",
                      textAlign: TextAlign.center),
                )
          : Center(
              child: Text("No complaint Solution Found",
                  textAlign: TextAlign.center)),
    );
  }
}
