import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KnowledgeMain extends StatefulWidget {
  const KnowledgeMain({super.key});

  @override
  State<KnowledgeMain> createState() => _KnowledgeMainState();
}

class _KnowledgeMainState extends State<KnowledgeMain> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ),
    );
  }
}
