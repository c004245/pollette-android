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
    gravity: 20.81,
    duration: 1.0,
    caption: "창백한 푸른 점.",
  );

  static PlanetType moon = PlanetType(
    gravity: 1.62,
    duration: 2.5,
    caption: "FLY ME TO THE MOON.",
  );

  static PlanetType mustafar = PlanetType(
    gravity: 0.4,
    duration: 3.0,
    caption: "IT'S OVER ANAKIN.",
  );

  static PlanetType uranus = PlanetType(
    gravity: 8.69,
    duration: 1.5,
    caption: "천왕성, 얼음 거인.",
  );
}
