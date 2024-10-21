class PlanetType {
  final double gravity; // 게임 내 중력 값
  final double duration; // 예: 게임 내 시간 비율 등
  final String caption; // 행성 설명
  final String imageFilename; // 행성 이미지 파일명

  const PlanetType({
    required this.gravity,
    required this.duration,
    required this.caption,
    required this.imageFilename,
  });

  static const double scalingFactor = 81.64; // 스케일링 팩터 (40.82 * 2)

  static const PlanetType earth = PlanetType(
    gravity: 9.81 * scalingFactor, // 9.81 * 81.64 ≈ 800
    duration: 1.0,
    caption: "창백한 푸른 점.",
    imageFilename: "earth.png",
  );

  static const PlanetType mars = PlanetType(
    gravity: 3.71 * scalingFactor, // 3.71 * 81.64 ≈ 302.68
    duration: 3.0,
    caption: "IT'S OVER ANAKIN.",
    imageFilename: "mars.png",
  );

  static const PlanetType moon = PlanetType(
    gravity: 1.62 * scalingFactor, // 1.62 * 81.64 ≈ 132.08
    duration: 2.5,
    caption: "FLY ME TO THE MOON.",
    imageFilename: "moon.png",
  );

  static const PlanetType uranus = PlanetType(
    gravity: 8.69 * scalingFactor, // 8.69 * 81.64 ≈ 708.72
    duration: 1.5,
    caption: "천왕성, 얼음 거인.",
    imageFilename: "uranus.png",
  );
}
