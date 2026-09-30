import 'dart:convert';

SpesiesPokemon spesiesPokemonDariJson(String str) =>
    SpesiesPokemon.fromJson(json.decode(str));

class SpesiesPokemon {
    final int id;
    final String name;
    final ResourceApiBernama? berasalDariEvolusi;
    final ReferensiRantaiEvolusi rantaiEvolusi;

    SpesiesPokemon({
        required this.id,
        required this.name,
        this.berasalDariEvolusi,
        required this.rantaiEvolusi,
    });

    factory SpesiesPokemon.fromJson(Map<String, dynamic> json) => SpesiesPokemon(
        id: json["id"],
        name: json["name"],
        berasalDariEvolusi: json["evolves_from_species"] == null
            ? null
            : ResourceApiBernama.fromJson(json["evolves_from_species"]),
        rantaiEvolusi: ReferensiRantaiEvolusi.fromJson(json["evolution_chain"]),
    );
}

class ResourceApiBernama {
    final String name;
    final String url;

    ResourceApiBernama({required this.name, required this.url});

    factory ResourceApiBernama.fromJson(Map<String, dynamic> json) => ResourceApiBernama(
        name: json["name"],
        url: json["url"],
    );
}

class ReferensiRantaiEvolusi {
    final String url;

    ReferensiRantaiEvolusi({required this.url});

    factory ReferensiRantaiEvolusi.fromJson(Map<String, dynamic> json) => ReferensiRantaiEvolusi(
        url: json["url"],
    );
}