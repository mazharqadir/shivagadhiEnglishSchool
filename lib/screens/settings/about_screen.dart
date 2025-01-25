// lib/screens/settings/about_screen.dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('Shivagadhi English School is a well known academic institution serving learners in our community. The changing nature of the education system has made good communication essential in the perspective of teachers, students and their parents. As a result, we have a unique opportunity to improve this by developing a comprehensive app for the school. In our current era, where the digital platform is becoming a more integral part in our daily life, Shivagadhi English School understands the importance of showing presence in this digital platform. We acknowledge that, to serve schools’ stakeholders, holistic development is necessary to adapt to the digital age. The current situation lets us know how important it is for your school to have a user-friendly platform to update and exchange information for proper communication. Due to the absence of a app, the effectiveness to connect our school in the community is lacking, which we want to overcome with. By developing a dedicated app, we can establish a central point for information sharing, communicating, with proper security of your information. By using the power of digital technology, our goal at Shivagadhi English School is to improve communication, teamwork and accessibility.')),);
  }
}