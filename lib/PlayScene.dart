import 'dart:math';

import 'package:flame/components.dart' as flame;
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart' as forge2d;
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pollette/BlackholeComponent.dart';
import 'package:pollette/SpinnerComponent.dart';
import 'package:pollette/WallComponent.dart';
class PlayScene extends forge2d.Forge2DGame {
  late flame.CameraComponent cameraComponent;
  late flame.World cameraWorld;

  final double gravity; // 중력 값

  PlayScene({required this.gravity}) : super(gravity: Vector2(0, gravity));





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
    cameraComponent.viewfinder.position = Vector2(screenWidth / 2, screenHeight / 2); // 중앙 위치 설정
    add(cameraComponent); // 카메라 추가

    // 왼쪽 및 오른쪽 벽(경계) 추가
    addLeftGround(screenWidth, screenHeight, this);
    addRightGround(screenWidth, screenHeight, this);


    // worldComponent = World();
    // add(worldComponent);
    //
    //
    // cameraComponent = CameraComponent(world: worldComponent);
    // add(cameraComponent);
    // //바닥과 블랙홀 추가
    // addGround();

    addSpinner(this, screenWidth, screenHeight, pi);
    addBlackhole(screenWidth, screenHeight);

    //공들 생성
    // createBalls();
  }

  // void createBalls() {
  //   final screenWidth = size.x;
  //   final screenHeight = size.y;
  //   final ballColors = [
  //     Colors.red, Colors.orange, Colors.green, Colors.purple,
  //     Colors.yellow, Colors.cyan, Colors.lightGreen, Colors.blue,
  //   ];
  //
  //   for (int i = 0; i < numberOfBalls; i++) {
  //     final ball = Ballcomponent(
  //       position: Vector2(screenWidth / 2 + i.toDouble(), screenHeight * 0.9),
  //       color: ballColors[i % ballColors.length],
  //     );
  //     add(ball);
  //   }
  // }

  void addBlackhole(double screenWidth, double screenHeight) {
    // 블랙홀을 화면의 최하단 중앙에 배치
    final blackholePosition = Vector2(screenWidth / 2, screenHeight - 24); // 화면 하단 중앙 (블랙홀 높이 48의 절반인 24만큼 위로 올림)
    final blackhole = BlackholeComponent(position: blackholePosition);
    add(blackhole);
  }

  // void addRightGround(double screenWidth, double screenHeight) {
  //   // 기존 점들의 Y 좌표를 반전
  //   final points = [
  //     Vector2(0, -screenHeight), // 아래로 이동 (Y 좌표 반전)
  //     Vector2(0, -screenHeight * 0.2),
  //     Vector2(screenWidth * -0.2, -screenHeight * 0.1),
  //     Vector2(screenWidth * -0.35, -screenHeight * 0.08),
  //     Vector2(screenWidth * -0.46, -screenHeight * 0.06),
  //     Vector2(screenWidth * -0.46, screenHeight * 0.5), // 상단으로 이동
  //   ];
  //
  //   // WallComponent를 추가하여 경계를 화면 하단으로 배치
  //   final rightWall = WallComponent(points: points, position: Vector2(screenWidth, 0));
  //   add(rightWall);
  // }
  //
  // void addLeftGround(double screenWidth, double screenHeight) {
  //   // 기존 점들의 Y 좌표를 반전
  //   final points = [
  //     Vector2(0, -screenHeight), // 아래로 이동 (Y 좌표 반전)
  //     Vector2(0, -screenHeight * 0.2),
  //     Vector2(screenWidth * 0.2, -screenHeight * 0.1),
  //     Vector2(screenWidth * 0.35, -screenHeight * 0.08),
  //     Vector2(screenWidth * 0.46, -screenHeight * 0.06),
  //     Vector2(screenWidth * 0.46, screenHeight * 0.5), // 상단으로 이동
  //   ];
  //
  //   // WallComponent를 추가하여 경계를 화면 하단으로 배치
  //   final leftWall = WallComponent(points: points, position: Vector2(0, 0));
  //   add(leftWall);
  // }


  // void createCaption(double screenWidth, double screenHeight) {
  //   //텍스트 내용 설정
  //   final captionText = planet.caption;
  //
  //   //create text component
  //   final textPaint = TextPaint(
  //     style: const TextStyle(fontSize: 24, fontFamily: "Galmuri11", fontWeight: FontWeight.bold, color: Colors.white));
  //
  //   // 텍스트 컴포넌트 생성 및 위치 설정
  //   final caption = TextComponent(
  //   text: captionText,
  //   textRenderer: textPaint,
  //   position: Vector2(screenWidth / 2, screenHeight * 0.8),
  //   anchor: Anchor.center, // 중앙 기준 배치
  //   );
  //
  //   add(caption); // 게임 씬에 텍스트
  // }


  @override
  void update(double dt) {
    super.update(dt);

    // if (balls.length == 1) {
    //   final ball = balls.first;
    //
    //   cameraComponent.follow(ball);
    //
    //   cameraComponent.viewfinder.zoom *= 0.98;
    // }
  }

  @override
  void beginContact(Object other, Contact contact) {
    // final fixtureA = contact.fixtureA;
    // final fixtureB = contact.fixtureB;
    //
    // final bodyA = fixtureA.body.userData as Ballcomponent?;
    // final bodyB = fixtureB.body.userData as Blackholecomponent?;
    //
    // //충돌한 물체가 공이나 블랙홀인가?
    // if ((bodyA != null && bodyB != null)) {
    //   bodyB?.removeFromParent(); // 블랙홀 제거
    //   balls.remove(bodyB);  // 공 리스트에서 제거
    //
    //   // 남은 공이 하나인 경우
    //   if (balls.length == 1) {
    //     bodyA.removeFromParent(); // 남은 공 제거
    //     balls.first.body.setGravityScale(0.0);  // 마지막 남은 공은 중력 영향을 받지 않도록 설정
    //   }
    // }
  }
  @override
  void onTapUp(TapUpInfo info) {
    // if (balls.length == 1) {
    //   removeAllChildren(); // 자식 노드 모두 제거
    //   removeFromParent(); // 부모에서 씬 제거
    //   removeAllActions(); // 모든 액션 제거
    // }
  }
}



class PlanetType {
  final double gravity;
  final double duration;
  final String caption;

  PlanetType({
    required this.gravity,
    required this.duration,
    required this.caption,
  });

  static PlanetType earth = PlanetType(
    gravity: -9.81,
    duration: 1.0,
    caption: "창백한 푸른 점.",
  );

  static PlanetType moon = PlanetType(
    gravity: -1.62,
    duration: 2.5,
    caption: "FLY ME TO THE MOON.",
  );

  static PlanetType mustafar = PlanetType(
    gravity: -0.4,
    duration: 3.0,
    caption: "IT'S OVER ANAKIN.",
  );

  static PlanetType uranus = PlanetType(
    gravity: -8.69,
    duration: 1.5,
    caption: "천왕성, 얼음 거인.",
  );
}