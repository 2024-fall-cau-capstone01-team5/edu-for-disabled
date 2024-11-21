import 'package:flutter/material.dart';
import 'character_customizing.dart';   // 캐릭터 커스터마이징 페이지
import 'scenario.dart';     // 시나리오 컨텐츠 페이지
import 'multiProfiles.dart';

class ContentsBar extends StatefulWidget {
  final String token;
  final String userId;
  final String username;
  final String profile;

  ContentsBar({required this.token, required this.userId, required this.username, required this.profile});

  @override
  _ContentsBarState createState() => _ContentsBarState();
}

class _ContentsBarState extends State<ContentsBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.profile}님을 위한 교육 컨텐츠"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CharacterCustom(userId: widget.userId, profile: widget.profile)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.output),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiProfilesScreen(
                    token: widget.token,
                    userId: widget.userId,
                    username: widget.username,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) => _iconButton(index)),
          ),
          Expanded(
              child: MainScroll(selectedIndex: selectedIndex, userId: widget.userId, profile: widget.profile)
          ),
        ],
      ),
    );
  }

  Widget _iconButton(int index) {
    String assetPath;

    // 아이콘 경로 설정
    if (index == 0) {
      assetPath = selectedIndex == index
          ? "assets/category_icons/outside_on.png"
          : "assets/category_icons/outside_off.png";
    } else if (index == 1) {
      assetPath = selectedIndex == index
          ? "assets/category_icons/home_on.png"
          : "assets/category_icons/home_off.png";
    } else {
      assetPath = selectedIndex == index
          ? "assets/category_icons/help_on.png"
          : "assets/category_icons/help_off.png";
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Image.asset(
        assetPath,
        width: 120,
        height: 50,
      ),
    );
  }
}

class MainScroll extends StatelessWidget {
  int selectedIndex = 0;
  final String userId;
  final String profile;
  MainScroll({required this.selectedIndex, required this.userId, required this.profile});

  final List<List<String>> images = [
    ['assets/thumbnails/store.webp', 'assets/thumbnails/park.webp', 'assets/thumbnails/disability_center.webp'],
    ['assets/thumbnails/toilet.webp', 'assets/thumbnails/terras.webp', 'assets/thumbnails/kitchen.webp'],
    ['assets/thumbnails/bad_attraction.webp', 'assets/thumbnails/missing.webp', 'assets/thumbnails/earthquake.webp']
  ];

  final List<List<String>> labels = [['편의점', '공원', '복지관'], ['화장실', '베란다', '주방'], ['낯선 사람', '길을 잃었을 때', '땅이 흔들릴 때']];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(images[selectedIndex].length, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Scenario(label: labels[selectedIndex][index], user_id: userId, profile_name: profile)), // Assuming 'Scenario' is defined elsewhere
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Image.asset(images[selectedIndex][index], fit: BoxFit.cover, width: 500.0),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          labels[selectedIndex][index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}