import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:pollette/PlayScene.dart';

import 'PlanetType.dart';

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
void main() {
  runApp(GameWidget(game: PlayScene(gravity: -PlanetType.earth.gravity)));
}

class GameScene extends FlameGame with TapDetector {
  late SpriteComponent imageNode;
  late SpriteComponent leftNode;
  late SpriteComponent rightNode;
  late SpriteComponent decreaseNode;
  late SpriteComponent increaseNode;
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

    // Players Label
    final playerLabel = TextComponent(
      text: "Players",
      textRenderer: TextPaint(style: const TextStyle(fontSize: 24, fontFamily: "Galmuri11", fontWeight: FontWeight.bold)),
      position: Vector2((size.x / 2) - (7 * 12 / 2),
        imageNode.position.y + imageNode.size.y + 50,  // imageNode의 하단에서 50px 아래
      ),    );
    add(playerLabel);

    numberNode = TextComponent(
      text: numberOfPlayer.toString(),
      textRenderer: TextPaint(style: const TextStyle(fontSize: 30)),
      // 좌우 정중앙에 배치되도록 수정 (텍스트 값을 바로 사용하여 길이를 계산)
      position: Vector2(
        (size.x / 2) - ((numberOfPlayer.toString().length * 24) / 2), // 텍스트 길이를 기준으로 정중앙에 맞춤
        playerLabel.y + 50,
      ),
    );
    add(numberNode);

    // Minus Button
    decreaseNode = SpriteComponent()
      ..sprite = await loadSprite('left.png')
      ..size = Vector2(50, 50)
      ..position = Vector2(10, numberNode.position.y + (numberNode.size.y / 2) - (50 / 2)); // 좌측 마진 10, imageNode의 세로 가운데에 맞춤
    add(decreaseNode);
    //
    // Plus Button
    increaseNode = SpriteComponent()
      ..sprite = await loadSprite('right.png')
      ..size = Vector2(50, 50)
      ..position = Vector2(size.x - 60,  numberNode.position.y + (numberNode.size.y / 2) - (50 / 2)); // 우측 마진 10, imageNode의 세로 가운데
    add(increaseNode);

    // 공 표시 노드
    ballLabel = TextComponent();

    updateBalls();

    add(ballLabel);

    // Start 버튼
    playButton = RectangleComponent(
      size: Vector2(250, 60), // 버튼 크기 설정
      position: Vector2(
          (size.x / 2) - (250 / 2), // 수평 정중앙에 맞추기
          size.y - 96 - 50 // 하단 마진 50 적용, 버튼 높이 고려
      ),
      paint: Paint()..color = Colors.green,
    );
    add(playButton);

    final playLabel = TextComponent(
      text: "START",
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 30,
          fontFamily: "Galmuri11-Bold",
        ),
      ),
      // playButton의 정중앙에 맞추기
      position: Vector2(
        playButton.position.x + (playButton.size.x / 2) - (6 * 24 / 2), // 'START' 텍스트 길이를 고려한 중앙 배치
        playButton.position.y + (playButton.size.y / 2) - (48 / 2), // 버튼 높이 기준 중앙에 텍스트 맞춤
      ),
    );
    add(playLabel);
  }

  void updateBalls() {
    // 기존의 공 제거
    children.whereType<CircleComponent>().forEach(remove);

    // 공들의 총 너비 계산 (각 공이 36px 간격으로 배치됨, 공의 크기가 작아짐)
    final ballRadius = 8.0; // 공의 반지름을 작게 설정 (기존보다 작음)
    final ballSpacing = 36.0; // 공 사이의 간격을 36px로 좁힘
    final totalWidth = (balls.length - 1) * ballSpacing + ballRadius * 2; // 각 공 간격과 마지막 공의 위치 포함

    // 공을 새로 추가
    for (var i = 0; i < balls.length; i++) {
      final ball = CircleComponent(
        radius: ballRadius, // 공의 반지름 설정
        paint: Paint()..color = balls[i], // 색상 설정
        position: Vector2(
          // numberNode의 중앙에서 공들의 총 너비의 절반만큼 왼쪽으로 이동한 위치에서 시작
          (numberNode.position.x + (numberNode.size.x / 2)) - (totalWidth / 2) + (i * ballSpacing),
          numberNode.position.y + 100, // numberNode의 아래쪽에 배치 (100px 아래)
        ),
      );
      add(ball); // 공 추가
    }
  }




  void increasePlayers() {
    if (numberOfPlayer < 8) {
      numberOfPlayer += 1;
      numberNode.text = numberOfPlayer.toString();
      addBall();
    }
  }


  void decreasePlayers() {
    print("decrease -> ${numberOfPlayer} -- ");
    if (numberOfPlayer > 2) {
      numberOfPlayer -= 1;
      numberNode.text = numberOfPlayer.toString();
      removeBall();
    }
  }
  void addBall() {
    balls.add(colorSet[numberOfPlayer -3]);
    updateBalls();
  }

  void removeBall() {
    print("balls -> ${balls.length}");
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
    } else if (decreaseNode.containsPoint(touchPosition)) {
      print("decrease");
      decreasePlayers();
    } else if (increaseNode.containsPoint(touchPosition)) {
      print("increase");
      increasePlayers();
    } else if (playButton.containsPoint(touchPosition)) {
      print("click play");
    }


  }



}

