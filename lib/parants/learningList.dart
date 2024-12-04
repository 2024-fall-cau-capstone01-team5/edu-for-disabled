import 'package:flutter/material.dart';
import '../metadata.dart'; // imageUrl, images, labels, category 데이터를 포함한 파일
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckboxList extends StatefulWidget {
  final String userId;
  final String profile;
  final Function(String) onProfileChange;

  CheckboxList({required this.userId, required this.profile, required this.onProfileChange});

  @override
  _CheckboxListState createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CheckboxList> {
  List<List<bool>> isChecked = [];

  @override
  void initState() {
    super.initState();
    fetchLearningList();
  }

  @override
  void didUpdateWidget(covariant CheckboxList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      fetchLearningList();
    }
  }

  Future<void> fetchLearningList() async {
    try {
      final response = await http.post(
        Uri.parse('http://20.9.151.223:8080/learning_list/scenarios'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "user_id": widget.userId,
          "profile_name": widget.profile,
        }),
      );

      if (response.statusCode == 200) {
        final List<String> savedTitles = List<String>.from(
          json.decode(utf8.decode(response.bodyBytes))['titles'] as List<dynamic>,
        );

        setState(() {
          isChecked = List.generate(
            labels.length,
                (i) => List.generate(
              labels[i].length,
                  (j) => savedTitles.contains(labels[i][j]),
            ),
          );
        });
      }
    } catch (e) {
      print('Error fetching learning list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 디버깅 로그 추가
    print("Labels: $labels");
    print("isChecked: $isChecked");

    if (labels.isEmpty || isChecked.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: labels.length,
      itemBuilder: (context, i) {
        if (i >= labels.length) {
          print("Index $i out of bounds for labels with length ${labels.length}");
          return SizedBox.shrink(); // 안전한 기본값 반환
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category[i],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...List.generate(labels[i].length, (j) {
              if (j >= labels[i].length) {
                print("Index $j out of bounds for labels[$i] with length ${labels[i].length}");
                return SizedBox.shrink();
              }

              return ListTile(
                leading: Image.asset(images[i][j], width: 50, height: 50),
                title: Text(labels[i][j]),
                trailing: Checkbox(
                  value: isChecked[i][j],
                  onChanged: (bool? value) async {
                    setState(() {
                      isChecked[i][j] = value ?? false;
                    });

                    final url = value == true
                        ? 'http://20.9.151.223:8080/learning_list/add'
                        : 'http://20.9.151.223:8080/learning_list/remove';

                    await http.post(
                      Uri.parse(url),
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode({
                        "user_id": widget.userId,
                        "profile_name": widget.profile,
                        "title": labels[i][j],
                      }),
                    );
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
