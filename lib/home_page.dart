import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake/food_pixel.dart';
import 'package:snake/snake_pixel.dart';

import 'blank_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //grid dimnesions
  int rowSize = 10;
  int totalnumberofSquares = 100;
  //score
  int currentScore = 0;
  //snake
  List<int> snakePos = [
    0,
    1,
    2,
  ];
  bool gameHasStarted = false;
  //snake direction is right

  var currentDirection = snake_Direction.RIGHT;
  //fod position
  int foodPos = 55;
  void eatFood() {
    currentScore++;
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalnumberofSquares);
    }
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 400), (timer) {
      setState(() {
        moveSnake();
        //add a new head
        //add head
        //snake is eating food

        if (gameOver()) {
          timer.cancel();
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Game Over'),
                  content: Column(
                    children: [
                      Text('Your score is' + currentScore.toString()),
                      TextField(
                        decoration:
                            InputDecoration(hintText: 'Enter player name'),
                      )
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        submitScore();
                        newGame();
                      },
                      child: Text('Submit Score'),
                      color: Colors.yellow,
                    )
                  ],
                );
              });
        }
      });
    });
  }

  void submitScore() {
    //
  }
  void newGame() {
    setState(() {
      snakePos = [
        0,
        1,
        2,
      ];
      foodPos = 55;
      currentDirection = snake_Direction.RIGHT;
      gameHasStarted = false;
      currentScore = 0;  
    });
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          //if snake is at right wall,need to re adjust
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
          //add head

          //remove the tail
        }
        break;
      case snake_Direction.LEFT:
        {
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
          //remove the tail
        }
        break;
      case snake_Direction.UP:
        {
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalnumberofSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }

          //remove the tail
        }
        break;
      case snake_Direction.DOWN:
        {
          if (snakePos.last + rowSize > totalnumberofSquares) {
            snakePos.add(snakePos.last + rowSize - totalnumberofSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }

          //remove the tail
        }
        break;
      default:
    }
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  bool gameOver() {
    //when snake bit itself(dupicate numeber)
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);
    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            //high score
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Current Score'),
                //user cureent score
                Text(
                  currentScore.toString(),
                  style: TextStyle(fontSize: 25),
                ),

                //highscores
                Text('HIGHSCORES...')
              ],
            )),
            Expanded(
                flex: 4,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy < 0 &&
                        currentDirection != snake_Direction.DOWN) {
                      currentDirection = snake_Direction.UP;
                      print('move up');
                    } else if (details.delta.dy > 0 &&
                        currentDirection != snake_Direction.UP) {
                      currentDirection = snake_Direction.DOWN;
                      print('move down');
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0 &&
                        currentDirection != snake_Direction.LEFT) {
                      currentDirection = snake_Direction.RIGHT;
                      print('move right');
                    } else if (details.delta.dx < 0 &&
                        currentDirection != snake_Direction.RIGHT) {
                      currentDirection = snake_Direction.LEFT;
                      print('move left');
                    }
                  },
                  child: GridView.builder(
                      itemCount: totalnumberofSquares,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: rowSize),
                      itemBuilder: (context, index) {
                        if (snakePos.contains(index)) {
                          return const SnakePixel();
                        } else if (foodPos == index) {
                          return const FoodPixel();
                        } else {
                          return const BlankPixel();
                        }
                      }),
                )),
            Expanded(
                child: Container(
              child: Center(
                child: MaterialButton(
                  child: Text('Play'),
                  color: gameHasStarted ? Colors.grey : Colors.red,
                  onPressed: gameHasStarted ? () {} : startGame,
                ),
              ),
            )),

            //game grid

            //play button
          ],
        ));
  }
}
