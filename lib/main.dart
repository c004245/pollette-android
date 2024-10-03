import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
void main() {
  runApp(GameWidget(game: GameScene()));
}

class GameScene extends FlameGame with TapDetector {
  late SpriteComponent imageNode;
  late SpriteComponent leftNode;
  late SpriteComponent rightNode;
  late TextComponent numberNode;
  late TextComponent ballLabel;
  late RectangleComponent playButton;
  int numberOfPlayer = 2;


  int planetIdx = 0;

  final List<String> planetTypes = ['earth.png', 'moon.png', 'mars.png', 'uranus.png']; // 행성 이미지 파일 이름 리스트

  final List<Color> balls = [Colors.red, Colors.orange];
  final List<Color> colorSet = [
    Colors.green,
    Colors.purple,
    Colors.yellow,
    Colors.pink,
    Colors.lightGreen,
    Colors.blue
  ];


  @override
  Future<void> onLoad() async {
    super.onLoad();




    imageNode = SpriteComponent()
      ..sprite = await loadSprite(planetTypes[planetIdx])
      ..size = Vector2(96, 96)
      ..position = Vector2((size.x / 2) - (96 / 2), size.y / 4); // 이미지 너비의 절반을 뺌
    add(imageNode);


    // Gravity Label
    final gravityLabel = TextComponent(
      text: "Gravity",
      textRenderer: TextPaint(style: const TextStyle(fontSize: 24, fontFamily: "Galmuri11", fontWeight: FontWeight.bold)),
      position: Vector2((size.x / 2) - (7 * 12 / 2), imageNode.y - 50),

    );
    add(gravityLabel);

  // 초기 행성 노드 생성
  //   final earthNode = SpriteComponent()
  //     ..sprite = await loadSprite(planetTypes[planetIdx]) // 첫 번째 행성 로드
  //     ..size = Vector2(120, 120)
  //     ..position = Vector2(imageNode.position.x - 60, imageNode.position.y - 60);
  //   add(earthNode);

    // Left Arrow Button
    leftNode = SpriteComponent()
      ..sprite = await loadSprite('left.png') // Chevron 이미지 사용
      ..size = Vector2(50, 50)
      ..position = Vector2(10, imageNode.position.y + (imageNode.size.y / 2) - (50 / 2)); // 좌측 마진 10, imageNode의 세로 가운데에 맞춤
    add(leftNode);

    // Right Arrow Button
    rightNode = SpriteComponent()
      ..sprite = await loadSprite('right.png') // Chevron 이미지 사용
      ..size = Vector2(50, 50)
      ..position = Vector2(size.x - 60, imageNode.position.y + (imageNode.size.y / 2) - (50 / 2)); // 우측 마진 10, imageNode의 세로 가운데
    add(rightNode);

    // // 플레이어 수 표시 노드
    // numberNode = TextComponent(
    //   text: numberOfPlayer.toString(),
    //   textRenderer: TextPaint(style: const TextStyle(fontSize: 48)),
    //   position: Vector2(imageNode.position.x, imageNode.position.y - 300),
    // );
    // add(numberNode);
    //
    // // Players Label
    // final playerLabel = TextComponent(
    //   text: "Players",
    //   textRenderer: TextPaint(style: const TextStyle(fontSize: 48, fontFamily: "Galmuri11", fontWeight: FontWeight.bold)),
    //   position: Vector2(numberNode.position.x, numberNode.position.y + 100),
    // );
    // add(playerLabel);
    //
    // // Minus Button
    // final decreaseNode = SpriteComponent()
    //   ..sprite = await loadSprite('minus.png')
    //   ..size = Vector2(50, 50)
    //   ..position = Vector2(numberNode.position.x - 200, imageNode.position.y - 300);
    // add(decreaseNode);
    //
    // // Plus Button
    // final increaseNode = SpriteComponent()
    //   ..sprite = await loadSprite('plus.png')
    //   ..size = Vector2(50, 50)
    //   ..position = Vector2(numberNode.position.x + 200, imageNode.position.y - 300);
    // add(increaseNode);
    //
    // // 공 표시 노드
    // ballLabel = TextComponent();
    // updateBalls();
    // ballLabel.position = Vector2(numberNode.position.x - 24, numberNode.position.y - 100);
    // add(ballLabel);
    //
    // // Start 버튼
    // playButton = RectangleComponent(
    //   size: Vector2(450, 96),
    //   position: Vector2(ballLabel.position.x - 225, ballLabel.position.y - 300),
    //   paint: Paint()..color = Colors.green,
    // );
    // add(playButton);
    //
    // final playLabel = TextComponent(
    //   text: "START",
    //   textRenderer: TextPaint(style: const TextStyle(fontSize: 48, fontFamily: "Galmuri11-Bold")),
    //   position: Vector2(playButton.position.x + 225, playButton.position.y + 48),
    // );
    // playButton.add(playLabel);
  }

  void updateBalls() {
    ballLabel.text = '';
    for (int i = 0; i < balls.length; i++) {
      ballLabel.text += '⚽ '; // 임시 공 아이콘
    }
  }


  void increasePlayers() {
    if (numberOfPlayer < 9) {
      numberOfPlayer += 1;
      numberNode.text = numberOfPlayer.toString();
      addBall();
    }
  }


  void decreasePlayers() {
    if (numberOfPlayer > 2) {
      numberOfPlayer -= -1;
      numberNode.text = numberOfPlayer.toString();
      removeBall();
    }
  }
  void addBall() {
    balls.add(colorSet[numberOfPlayer -3]);
    updateBalls();
  }

  void removeBall() {
    balls.removeLast();
    updateBalls();
  }


  //오른쪽 버튼 액션 (행성)
  void rightButtonAction() {
    planetIdx +=1;
    planetIdx =  planetIdx % planetTypes.length;
    updatePlanet();
  }

  //왼쪽 버튼 액션 (행성)
  void leftButtonAction() {
    planetIdx -= 1;
    if (planetIdx < 0) {
      planetIdx = planetTypes.length -1;
    }
    updatePlanet();
  }


  //행성 업데이트 메소드
  void updatePlanet() async {
    remove(imageNode);
    imageNode = SpriteComponent()
      ..sprite = await loadSprite(planetTypes[planetIdx]) // 새로운 행성 로드
      ..size = Vector2(96, 96) // 행성 크기 설정
      ..position = Vector2((size.x / 2) - (96 / 2), size.y / 4); // 이미지 너비의 절반을 뺌


    add(imageNode);
  }

  @override
  void onTapDown(TapDownInfo info) {
    final touchPosition = info.raw.globalPosition.toVector2(); // 터치 위치를 Vector2로 변환

    // leftNode가 터치된 경우 확인
    if (leftNode.containsPoint(touchPosition)) {
      print("left click");
      leftButtonAction(); // leftNode가 터치되었을 때 실행할 메소드
    } else if (rightNode.containsPoint(touchPosition)) {
      print("right click");
      rightButtonAction();
    }


  }



}

