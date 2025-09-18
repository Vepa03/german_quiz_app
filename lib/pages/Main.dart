import 'package:flutter/material.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final images = [
    "assets/images/bg2.jpg",
    "assets/images/bg3.jpg",
    "assets/images/bg2.jpg"
  ];

  int _index = 0;

  late final PageController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  void _prev() {
    if (_index > 0){
      _controller.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  void _next() {
    if (_index < images.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AspectRatio(aspectRatio: 16/9,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: images.length,
                    onPageChanged: (i) => setState(() {
                      _index = i;
                    }),
                    itemBuilder: (_,i) => Image.asset(
                      images[i], fit: BoxFit.cover,
                    )
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 0, bottom: 0,
                  child: _CircleButton_left(
                    icon: Icons.chevron_left,
                    onTap: _prev,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 0, bottom: 0,
                  child: _CircleButton_right(
                    icon: Icons.chevron_right,
                    onTap: _next,
                  ),
                ),
              ],
            ),),
          )
        ],
      )
    );
  }
}


class _CircleButton_right extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton_right({required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 38, height: 38,
          child: Center(
            child: Icon(Icons.chevron_right, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
class _CircleButton_left extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton_left({required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 38, height: 38,
          child: Center(
            child: Icon(Icons.chevron_left, color: Colors.white),
          ),
        ),
      ),
    );
  }
}