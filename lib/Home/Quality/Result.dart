import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  final List predictions;
  const Result({Key? key, required this.predictions}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ResultsPage extends StatelessWidget {
  final List predictions;

  const ResultsPage({Key? key, required this.predictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: ListView.builder(
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                '$predictions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${(predictions[index]['confidence'] * 100).toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
