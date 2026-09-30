import 'dart:convert';

Pokemon pokemonDariJson(String str) => Pokemon.fromJson(json.decode(str));

class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<SlotTipe> types;
  final Gambar sprites;
  final List<Statistik> stats;

  Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.sprites,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
    id: json["id"],
    name: json["name"],
    height: json["height"],
    weight: json["weight"],
    types: List<SlotTipe>.from(json["types"].map((x) => SlotTipe.fromJson(x))),
    sprites: Gambar.fromJson(json["sprites"]),
    stats: List<Statistik>.from(json["stats"].map((x) => Statistik.fromJson(x))),
  );

  int ambilStatistik(String namaStat) {
    final stat = stats.firstWhere((s) => s.stat.name == namaStat);
    return stat.nilaiDasar;
  }
}

class SlotTipe {
  final ResourceBernama type;

  SlotTipe({required this.type});

  factory SlotTipe.fromJson(Map<String, dynamic> json) =>
      SlotTipe(type: ResourceBernama.fromJson(json["type"]));
}

class Gambar {
  final Lainnya? other;

  Gambar({this.other});

  factory Gambar.fromJson(Map<String, dynamic> json) => Gambar(
    other: json["other"] == null ? null : Lainnya.fromJson(json["other"]),
  );

  String get gambarUtama => other?.karyaSeniResmi.depanBawaan ?? '';
}

class Lainnya {
  final KaryaSeniResmi karyaSeniResmi;

  Lainnya({required this.karyaSeniResmi});

  factory Lainnya.fromJson(Map<String, dynamic> json) => Lainnya(
    karyaSeniResmi: KaryaSeniResmi.fromJson(json["official-artwork"]),
  );
}

class KaryaSeniResmi {
  final String depanBawaan;

  KaryaSeniResmi({required this.depanBawaan});

  factory KaryaSeniResmi.fromJson(Map<String, dynamic> json) =>
      KaryaSeniResmi(depanBawaan: json["front_default"] ?? '');
}

class Statistik {
  final int nilaiDasar;
  final ResourceBernama stat;

  Statistik({required this.nilaiDasar, required this.stat});

  factory Statistik.fromJson(Map<String, dynamic> json) => Statistik(
    nilaiDasar: json["base_stat"],
    stat: ResourceBernama.fromJson(json["stat"]),
  );
}

class ResourceBernama {
  final String name;

  ResourceBernama({required this.name});

  factory ResourceBernama.fromJson(Map<String, dynamic> json) =>
      ResourceBernama(name: json["name"]);
}
