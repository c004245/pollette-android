import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
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
  late SpriteComponent planetNode;
  late TextComponent numberNode;
  late TextComponent ballLabel;

  int numberOfPlayers = 2;

  int planetIdx = 0;

  final List<String> planetTypes = ['images/earth.png', 'images/moon.png', 'images/mars.png', 'images/uranus.png']; // 행성 이미지 파일 이름 리스트

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


    // 초기 행성 노드 생성
    planetNode = SpriteComponent()
      ..sprite = await loadSprite(planetTypes[planetIdx]) // 첫 번째 행성 로드
      ..size = Vector2(120, 120)
      ..position = Vector2(size.x / 2, size.y / 4);

    add(planetNode);

    // 플레이어 수 표시 노드
    numberNode = TextComponent(
      text: numberOfPlayers.toString(),
      textRenderer: TextPaint(style: const TextStyle(fontSize: 48)),
    )
      ..position = Vector2(size.x / 2, size.y / 2);
    add(numberNode);

    //볼 레이블
    ballLabel = TextComponent();
    updateBalls();
    add(ballLabel);
  }

  void updateBalls() {
    ballLabel.text = '';
    for (int i = 0; i < balls.length; i++) {
      ballLabel.text += '⚽ '; // 임시 공 아이콘
    }
  }


  void increasePlayers() {
    if (numberOfPlayers < 9) {
      numberOfPlayers += 1;
      numberNode.text = numberOfPlayers.toString();
      addBall();
    }
  }


  void decreasePlayers() {
    if (numberOfPlayers > 2) {
      numberOfPlayers -= -1;
      numberNode.text = numberOfPlayers.toString();
      removeBall();
    }
  }
  void addBall() {
    balls.add(colorSet[numberOfPlayers -3]);
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
    remove(planetNode);
    planetNode = SpriteComponent()
      ..sprite = await loadSprite(planetTypes[planetIdx]) // 새로운 행성 로드
      ..size = Vector2(120, 120) // 행성 크기 설정
      ..position = Vector2(size.x / 2, size.y / 4); // 행성 위치 설정

    add(planetNode);
  }

  @override
  void onTapDown(TapDownInfo info) {
    final touchPosition = info.raw.globalPosition;

    if (rightButton.containsPoint(touchPosition.toVector2())) {
      rightButtonAction();
    } else if (leftButton.containsPoint(touchPosition.toVector2())) {
      leftButtonAction();
    }
  }



}

