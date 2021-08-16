// ignore: slash_for_doc_comments
/**
 * Model for Onboarding data
 */

class Onboarding {
  String? image;
  String? headline;

  Onboarding({this.image, this.headline});

  static List<Onboarding> all = [
    Onboarding(
      headline:
          "Shop best quality African fashion and beauty products from trusted brands",
      image: "assets/images/Splash Image 1@3x.png",
    ),
    Onboarding(
      headline: "Affordable prices and fast delivery",
      image: "assets/images/Splash Image 2@3x.png",
    ),
    Onboarding(
      headline: "Enjoy a seamless shopping experience",
      image: "assets/images/Splash Image 3@3x.png",
    ),
  ];
}
