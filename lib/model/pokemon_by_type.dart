class PokemonBerdasarkanTipe {
  final List<EntryNamaPokemon> daftarPokemon;

  PokemonBerdasarkanTipe({required this.daftarPokemon});

  factory PokemonBerdasarkanTipe.fromJson(Map<String, dynamic> json) {
    final List<dynamic> daftarPokemonJson = json['pokemon'];
    return PokemonBerdasarkanTipe(
      daftarPokemon: daftarPokemonJson
          .map((item) => EntryNamaPokemon.fromJson(item['pokemon']))
          .toList(),
    );
  }
}

class EntryNamaPokemon {
  final String name;

  EntryNamaPokemon({required this.name});

  factory EntryNamaPokemon.fromJson(Map<String, dynamic> json) {
    return EntryNamaPokemon(name: json['name']);
  }
}