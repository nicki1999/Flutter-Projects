import 'package:flutter/material.dart';
import 'dart:math';

class DiceRoller extends StatefulWidget {
 const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

class _DiceRollerState extends State<DiceRoller> {

  var currentDiceRoll = 2;

    void rollDice() {
      setState(() {
              currentDiceRoll = Random().nextInt(6) + 1;
      });
    }

  @override
  Widget build(context){
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/dice-$currentDiceRoll.png',
              width: 200,
            ),
            const SizedBox(height: 20),
            TextButton(
              child: const Text(
                'Roll Dice',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: rollDice,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 28),
              )
            ),
          ],
        );
  }
}