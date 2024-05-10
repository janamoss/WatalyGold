
import 'package:flutter/material.dart';
import 'package:watalyGold/models/category.dart';
import 'CategoryCard.dart';

class Homebox extends StatefulWidget {
  const Homebox({super.key});

  @override
  State<Homebox> createState() => _HomeboxState();
}

class _HomeboxState extends State<Homebox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
            shrinkWrap: true,
            itemCount: categoryList.length,
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
            ),
            itemBuilder: (context, index) {
              return CategoryCard(
                category: categoryList[index],
              );
            })
      ],
    );
  }
}