import 'dart:convert';

EvolutionChain evolutionChainFromJson(String str) =>
    EvolutionChain.fromJson(json.decode(str));

class EvolutionChain {
  final int id;
  final Chain chain;

  EvolutionChain({required this.id, required this.chain});

  factory EvolutionChain.fromJson(Map<String, dynamic> json) => EvolutionChain(
        id: json["id"],
        chain: Chain.fromJson(json["chain"]),
      );
}

class Chain {
  final bool isBaby;
  final Species species;
  final List<Chain> evolvesTo;

  Chain({
    required this.isBaby,
    required this.species,
    required this.evolvesTo,
  });

  factory Chain.fromJson(Map<String, dynamic> json) => Chain(
        isBaby: json["is_baby"],
        species: Species.fromJson(json["species"]),
        evolvesTo: List<Chain>.from(json["evolves_to"].map((x) => Chain.fromJson(x))),
      );

  String get pokemonId {
    final parts = species.url.split('/').where((p) => p.isNotEmpty).toList();
    return parts.last;
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';
}

class Species {
  final String name;
  final String url;

  Species({required this.name, required this.url});

  factory Species.fromJson(Map<String, dynamic> json) => Species(
        name: json["name"],
        url: json["url"],
      );
}