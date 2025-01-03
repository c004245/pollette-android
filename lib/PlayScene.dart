import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart' as flame;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flame_forge2d/flame_forge2d.dart' as forge2d;
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pollette/BlackholeComponent.dart';
import 'package:pollette/PlanetType.dart';
import 'package:pollette/SpinnerComponent.dart';
import 'package:pollette/WallComponent.dart';

import 'BallComponent.dart';
import 'BoxComponent.dart';

class PlayScene extends forge2d.Forge2DGame with forge2d.ContactCallbacks {
  late flame.CameraComponent cameraComponent;
  late flame.World cameraWorld;


  final int numberOfBalls; // 생성할 공의 수
  final PlanetType planet; // 중력 값

  PlayScene({required this.numberOfBalls, required this.planet})
      : super(gravity: Vector2(0, planet.gravity));

  List<Ballcomponent> balls = [];


  final List<Color> ballColors = [
    Colors.red,
    Colors.orange,
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
    // 화면의 크기 가져오기

    final screenWidth = size.x;
    final screenHeight = size.y;

    cameraWorld = flame.World();
    add(cameraWorld);

    // 카메라 설정
    cameraComponent = flame.CameraComponent(world: cameraWorld); // 카메라 생성
    Vector2(screenWidth / 2, screenHeight / 2); // 중앙 위치 설정
    add(cameraComponent); // 카메라 추
    cameraComponent.viewfinder.zoom = 1.0; // 가

    // 왼쪽 및 오른쪽 벽(경계) 추가
    addLeftGround(screenWidth, screenHeight, this);
    addRightGround(screenWidth, screenHeight, this);
    createCaption(screenWidth, screenHeight);
    addBoxes(this, screenWidth, screenHeight);
    addSpinner(this, screenWidth, screenHeight, pi / 3);
    addBlackhole(screenWidth, screenHeight);

    //공들 생성
    createBalls(screenWidth, screenHeight);
    addPlanetImage(screenWidth, screenHeight);


  }

  void addPlanetImage(double screenWidth, double screenHeight) async {
    // PlanetType의 imageFilename을 사용하여 이미지 로드
    final planetImage = await loadSprite(planet.imageFilename);

    // 이미지 크기 설정 (원하는 크기로 조정)
    final planetSize = Vector2(64, 64);  // 예시로 64x64 크기 설정

    // 오른쪽 상단에 배치 (화면의 오른쪽 너비에서 이미지 너비만큼 뺌)
    final planetPosition = Vector2(screenWidth - planetSize.x - 20, 40);  // 오른쪽 여백 20, 상단 여백 20

    // SpriteComponent로 이미지 생성
    final planetImageComponent = SpriteComponent(
      sprite: planetImage,
      size: planetSize,
      position: planetPosition,
    );

    add(planetImageComponent);  // 게임에 이미지 컴포넌트 추가
  }


  void createBalls(double screenWidth, double screenHeight) {
    const double offset = 4; // 각 공 사이의 간격을 좁힘
    final double startX = screenWidth / 2; // 화면 중앙을 기준으로 시작

    for (int i = 0; i < numberOfBalls; i++) {
      // 공의 x 좌표를 중앙에서 좌우 대칭으로 설정
      final double xPos = startX + (i - (numberOfBalls - 1) / 2) * offset;

      final ball = Ballcomponent(
        position: Vector2(xPos, screenHeight * 0.1),
        color: ballColors[i],
        gameRef: this,
      );
      add(ball);
      balls.add(ball);
    }
  }


  void addBlackhole(double screenWidth, double screenHeight) {
    final blackholePosition = Vector2(screenWidth / 2,
        screenHeight - 24);
    final blackhole = BlackholeComponent(position: blackholePosition);
    add(blackhole);
  }

  void addBoxes(Forge2DGame game, double screenWidth, double screenHeight) {
    final boxSize = screenWidth / 24;
    const double ballOffset = 4; // 공 간격
    final double ballTotalWidth = (numberOfBalls - 1) * ballOffset;
    // final double ballStartX = (screenWidth / 2) - (ballTotalWidth / 2);
    final double ballStartX = screenWidth / 2; // 화면
    // 첫 번째 상자 그룹 추가
    for (int i = -5; i < 6; i++) {
      final position = Vector2(
          screenWidth / 2 - i * boxSize * 1.95, screenHeight * 0.6);
      final rotation = Random().nextDouble() * pi * 2 - pi; // 랜덤 회전
      final box = BoxComponent(
        size: Vector2(boxSize, boxSize),
        position: position,
        rotation: rotation,
        isDynamic: true, // 회전은 가능하지만 위치는 고정
      );

      game.add(box);
    }

    // 두 번째 상자 그룹 추가
    for (int i = -4; i < 5; i++) {
      final position = Vector2(
          screenWidth / 2 - i * boxSize * 1.9, screenHeight * 0.5);
      final rotation = Random().nextDouble() * pi * 2 - pi;
      final box = BoxComponent(
        size: Vector2(boxSize, boxSize),
        position: position,
        rotation: rotation,
        isDynamic: true, // 회전은 가능하지만 위치는 고정
      );

      game.add(box);
    }


    for (int i = 0; i < 11; i++) {
      final double xPos = ballStartX +
          (i - (numberOfBalls - 1) / 2) * ballOffset;
      final ball = Ballcomponent(
        // 공의 위치를 중앙에서 좌우로 퍼지도록 설정
        position: Vector2(xPos, screenHeight * 0.25),
        color: Color(0xFFFFFF.toInt()).withOpacity(1.0), // 공의 색상
        gameRef: this,
      );

      game.add(ball); // BallComponent를 게임에 추가
    }
  }

  void createCaption(double screenWidth, double screenHeight) {
    final captionText = planet.caption;
    final textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 24,
        fontFamily: "Galmuri11",
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
    final caption = TextComponent(
      text: captionText,
      textRenderer: textPaint,
      position: Vector2(screenWidth / 2, screenHeight * 0.3),
      anchor: Anchor.center, // 중앙 기준 배치
    );

    add(caption); // 게임 씬에 텍스트
  }

  @override
  void onBallRemoved(Ballcomponent ball) {
    balls.remove(ball); // 공을 리스트에서 제거
    print('Ball removed. Remaining balls: ${balls.length}');
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 공이 하나 남았을 때 줌 인 애니메이션
    if (balls.length == 1) {
      print("ball only 1");
      final remainingBall = balls.first;

      // 중력 제거
      remainingBall.body.gravityScale = Vector2(0, 0); // 중력 제거

      // // 카메라 줌 적용
      // cameraComponent.viewfinder.zoom = cameraComponent.viewfinder.zoom +
      //     (0.3 - cameraComponent.viewfinder.zoom) * 0.1 * dt;
      //
      // // 카메라가 남은 공의 위치로 이동
      // cameraComponent.viewfinder.position = cameraComponent.viewfinder.position +
      //     (remainingBall.body.position - cameraComponent.viewfinder.position) * 0.1 * dt;

      print("reom -> ${remainingBall}");
      showBallOverlay(remainingBall);

    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    // if (balls.length == 1) {
    //   removeAllChildren(); // 자식 노드 모두 제거
    //   removeFromParent(); // 부모에서 씬 제거
    //   removeAllActions(); // 모든 액션 제거
    // }
  }

  void showBallOverlay(Ballcomponent remainingBall) {
    overlays.add('BallOverlay'); // 오버레이 추가
    // remainingBall 정보를 전달하는 다른 방법을 고려할 수 있습니다.
  }
}
