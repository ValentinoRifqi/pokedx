import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/pokeapi_constants.dart';
import '../model/pokemon.dart';
import '../model/pokemon_by_type.dart';
import '../model/evolution_chain.dart';

class PokemonService {
  Future<Pokemon> cariPokemon(String namaAtauId) async {
    final url = Uri.parse('${KonstantaApiPoke.baseUrl}/$namaAtauId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return pokemonDariJson(response.body);
    } else {
      throw Exception('Pokemon tidak ditemukan');
    }
  }

  Future<PokemonBerdasarkanTipe> getPokemonByType(String tipe) async {
    final url = Uri.parse('${KonstantaApiPoke.baseUrlTipe}/$tipe');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PokemonBerdasarkanTipe.fromJson(data);
    } else {
      throw Exception('Tipe tidak ditemukan');
    }
  }

  Future<EvolutionChain> getEvolutionChain(String namaAtauId) async {
    final urlPokemon = Uri.parse('${KonstantaApiPoke.baseUrl}/$namaAtauId');
    final resPokemon = await http.get(urlPokemon);
    final dataPokemon = jsonDecode(resPokemon.body);

    final urlSpecies = dataPokemon['species']['url'];
    final resSpecies = await http.get(Uri.parse(urlSpecies));
    final dataSpecies = jsonDecode(resSpecies.body);

    final urlEvolusi = dataSpecies['evolution_chain']['url'];
    final resEvolusi = await http.get(Uri.parse(urlEvolusi));

    return evolutionChainFromJson(resEvolusi.body);
  }

  Future<List<String>> getSemuaNamaPokemon() async {
    final url = Uri.parse('${KonstantaApiPoke.baseUrl}?limit=100000');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((item) => item['name'] as String).toList();
    } else {
      throw Exception('Gagal ambil daftar nama pokemon');
    }
  }

  Future<List<String>> getDaftarTipe() async {
    final url = Uri.parse(KonstantaApiPoke.baseUrlTipe);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];

      const dibuang = ['unknown', 'stellar', 'shadow'];

      return results
          .map((item) => item['name'] as String)
          .where((nama) => !dibuang.contains(nama))
          .toList();
    } else {
      throw Exception('Gagal ambil daftar tipe');
    }
  }
}
