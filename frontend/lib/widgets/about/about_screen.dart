import 'package:flutter/material.dart';
import 'package:frontend/widgets/styling/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            colors: [brightGold, Color.fromARGB(255, 250, 255, 148)],
          ),
        ),
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 55, bottom: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Image
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 175,
                ),
              ),
              const SizedBox(height: 15),
              // App Description
              const Text(
                'About Our App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                textAlign: TextAlign.center,
                'KnightVenture is a virtual geocaching app designed specifically for students to explore and get to know their campus in a fun and interactive way. With features like real-time location tracking, cache collecting, and achievements, you can discover new places, meet new friends, and make the most out of your campus experience.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/group.png',
                  height: 200,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'The team completing their first GeoCache',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Text(
                'Our Inspiration',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                textAlign: TextAlign.center,
                'As seniors, we realized that despite spending years on campus, there were still many hidden gems and interesting places we had yet to discover. Our enormous campus has so much to offer, and we wanted to create a fun and interactive way for students to explore and get to know their surroundings better. This inspired us to develop KnightVenture, a virtual geocaching app that encourages students to embark on adventures, uncover hidden spots, and make lasting memories.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              // Team Members
              const Text(
                'Meet the Team',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage:
                        AssetImage('assets/team_pictures/thai.webp'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hung Tran - Project Manager',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Experienced leader with a knack for project management and ensuring timely delivery of high-quality software solutions.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage:
                        AssetImage('assets/team_pictures/omar.webp'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Omar Alshafei - Main Backend Developer',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Expert in backend development, ensuring robust and scalable server-side applications for seamless user experiences',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage:
                        AssetImage('assets/team_pictures/nawfal.webp'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nawfal Cherkaoui Elmalki - Backend/Frontend Developer',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Dedicated developer focused on creating efficient and reliable backend systems to support frontend functionalities.',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage:
                        AssetImage('assets/team_pictures/amy.webp'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hong T Nguyen - Backend/Frontend Developer',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Versatile developer skilled in both backend and frontend technologies, ensuring cohesive and functional applications.',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage:
                        AssetImage('assets/team_pictures/eddy.webp'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Eduardo Vila - UX/UI Designer',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Creative designer focused on crafting intuitive and engaging user interfaces with a user-centered design approach.',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
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
