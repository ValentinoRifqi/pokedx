import 'package:flutter/material.dart';
import 'service/pokemon_service.dart';
import 'model/pokemon.dart';
import 'model/pokemon_by_type.dart';
import 'model/evolution_chain.dart';

void main() => runApp(MyApp());

final Map<String, Color> warnaTipe = {
  'normal': Color(0xFFA8A878),
  'fire': Color(0xFFF08030),
  'water': Color(0xFF6890F0),
  'electric': Color(0xFFF8D030),
  'grass': Color(0xFF78C850),
  'ice': Color(0xFF98D8D8),
  'fighting': Color(0xFFC03028),
  'poison': Color(0xFFA040A0),
  'ground': Color(0xFFE0C068),
  'flying': Color(0xFFA890F0),
  'psychic': Color(0xFFF85888),
  'bug': Color(0xFFA8B820),
  'rock': Color(0xFFB8A038),
  'ghost': Color(0xFF705898),
  'dragon': Color(0xFF7038F8),
  'dark': Color(0xFF705848),
  'steel': Color(0xFFB8B8D0),
  'fairy': Color(0xFFEE99AC),
};

Color ambilWarnaTipe(String tipe) => warnaTipe[tipe] ?? Colors.grey;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212),
      ),
      home: UtamaPage(),
    );
  }
}

class UtamaPage extends StatefulWidget {
  @override
  _UtamaPageState createState() => _UtamaPageState();
}

class _UtamaPageState extends State<UtamaPage> {
  int indeksTab = 0;
  final layanan = PokemonService();

  Pokemon? pokemonAktif;
  EvolutionChain? rantaiEvolusi;
  bool sedangMemuat = false;
  bool sedangMemuatEvolusi = false;

  List<EntryNamaPokemon> daftarByTipe = [];
  bool sedangMemuatTipe = false;
  String? tipeTerpilih;

  List<Pokemon> listFavorit = [];

  List<String> semuaNamaPokemon = [];
  List<String> hasilSaran = [];

  List<String> daftarTipe = [];
  bool sedangMemuatDaftarTipe = false;

  @override
  void initState() {
    super.initState();
    muatSemuaNama();
    muatDaftarTipe();
  }

  void muatDaftarTipe() async {
    setState(() => sedangMemuatDaftarTipe = true);
    try {
      final hasil = await layanan.getDaftarTipe();
      setState(() {
        daftarTipe = hasil;
        sedangMemuatDaftarTipe = false;
      });
    } catch (_) {
      setState(() => sedangMemuatDaftarTipe = false);
    }
  }

  void muatSemuaNama() async {
    try {
      final hasil = await layanan.getSemuaNamaPokemon();
      setState(() => semuaNamaPokemon = hasil);
    } catch (_) {}
  }

  void filterSaran(String query) {
    if (query.trim().isEmpty) {
      setState(() => hasilSaran = []);
      return;
    }
    setState(() {
      hasilSaran = semuaNamaPokemon
          .where((nama) => nama.startsWith(query.toLowerCase()))
          .take(8)
          .toList();
    });
  }

  void cari(String nama) async {
    if (nama.trim().isEmpty) return;
    setState(() {
      sedangMemuat = true;
      sedangMemuatEvolusi = true;
      hasilSaran = [];
      indeksTab = 0;
    });

    try {
      final hasilPokemon = await layanan.cariPokemon(nama.toLowerCase().trim());
      setState(() {
        pokemonAktif = hasilPokemon;
        sedangMemuat = false;
      });

      final hasilEvolusi = await layanan.getEvolutionChain(
        nama.toLowerCase().trim(),
      );
      setState(() {
        rantaiEvolusi = hasilEvolusi;
        sedangMemuatEvolusi = false;
      });
    } catch (e) {
      setState(() {
        sedangMemuat = false;
        sedangMemuatEvolusi = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pokemon tidak ditemukan')));
    }
  }

  void pilihTipe(String tipe) async {
    setState(() {
      sedangMemuatTipe = true;
      tipeTerpilih = tipe;
    });
    try {
      final hasil = await layanan.getPokemonByType(tipe);
      setState(() {
        daftarByTipe = hasil.daftarPokemon;
        sedangMemuatTipe = false;
      });
    } catch (e) {
      setState(() => sedangMemuatTipe = false);
    }
  }

  void toggleFavorit(Pokemon p) {
    setState(() {
      if (listFavorit.any((item) => item.id == p.id)) {
        listFavorit.removeWhere((item) => item.id == p.id);
      } else {
        listFavorit.add(p);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: IndexedStack(
        index: indeksTab,
        children: [_buildTabBeranda(), _buildTabTipe(), _buildTabFavorit()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: indeksTab,
        onDestinationSelected: (i) => setState(() {
          indeksTab = i;
          hasilSaran = [];
        }),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Cari'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'Tipe'),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Favorit',
          ),
        ],
      ),
    );
  }

  Widget _buildTabBeranda() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Ketik nama pokemon...',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.white.withOpacity(0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: filterSaran,
            onSubmitted: cari,
          ),

          if (hasilSaran.isNotEmpty)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: hasilSaran.map((nama) {
                  return ListTile(
                    dense: true,
                    leading: Icon(Icons.catching_pokemon, size: 18),
                    title: Text(nama),
                    onTap: () => cari(nama),
                  );
                }).toList(),
              ),
            ),

          SizedBox(height: 16),
          if (sedangMemuat)
            Expanded(child: Center(child: CircularProgressIndicator()))
          else if (pokemonAktif != null)
            Expanded(child: _buildDetailPokemon())
          else
            Expanded(
              child: Center(
                child: Text(
                  'Cari Pokemon favoritmu di atas!',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabTipe() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Bagian chip tipe (sekarang dari API) =====
          if (sedangMemuatDaftarTipe)
            SizedBox(
              height: 42,
              child: Center(child: LinearProgressIndicator()),
            )
          else if (daftarTipe.isEmpty)
            SizedBox(
              height: 42,
              child: Row(
                children: [
                  Text(
                    'Gagal memuat tipe',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: muatDaftarTipe,
                    child: Text('Coba lagi'),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: daftarTipe.map((tipe) {
                  final warna = ambilWarnaTipe(tipe);
                  final aktif = tipeTerpilih == tipe;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(
                        tipe.toUpperCase(),
                        style: TextStyle(
                          color: aktif ? Colors.white : warna,
                          fontWeight: aktif
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      backgroundColor: aktif ? warna : warna.withOpacity(0.15),
                      side: BorderSide(color: warna, width: aktif ? 0 : 1),
                      onPressed: () => pilihTipe(tipe),
                    ),
                  );
                }).toList(),
              ),
            ),

          SizedBox(height: 16),

          // ===== Bagian daftar Pokemon (tidak berubah) =====
          if (sedangMemuatTipe)
            Expanded(child: Center(child: CircularProgressIndicator()))
          else if (daftarByTipe.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: daftarByTipe.length,
                itemBuilder: (context, index) {
                  final item = daftarByTipe[index];
                  final warna = ambilWarnaTipe(tipeTerpilih ?? '');
                  return Card(
                    margin: EdgeInsets.only(bottom: 8),
                    color: Colors.white.withOpacity(0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: warna.withOpacity(0.3),
                        child: Icon(Icons.catching_pokemon, color: warna),
                      ),
                      title: Text(
                        item.name[0].toUpperCase() + item.name.substring(1),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => cari(item.name),
                    ),
                  );
                },
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  'Pilih tipe Pokemon di atas untuk melihat daftar',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabFavorit() {
    if (listFavorit.isEmpty) {
      return Center(
        child: Text(
          'Belum ada Pokemon favorit',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: listFavorit.length,
        itemBuilder: (context, index) {
          final item = listFavorit[index];
          final tipeUtama = item.types.first.type.name;
          final warna = ambilWarnaTipe(tipeUtama);

          return Card(
            margin: EdgeInsets.only(bottom: 8),
            color: Colors.white.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Image.network(
                item.sprites.gambarUtama,
                width: 40,
                height: 40,
              ),
              title: Text(
                item.name.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Tipe: $tipeUtama',
                style: TextStyle(color: warna),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => toggleFavorit(item),
              ),
              onTap: () {
                setState(() {
                  pokemonAktif = item;
                  indeksTab = 0;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailPokemon() {
    final tipeUtama = pokemonAktif!.types.first.type.name;
    final warnaUtama = ambilWarnaTipe(tipeUtama);
    final isFav = listFavorit.any((item) => item.id == pokemonAktif!.id);

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [warnaUtama.withOpacity(0.35), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.white,
                  size: 28,
                ),
                onPressed: () => toggleFavorit(pokemonAktif!),
              ),
            ),
            Image.network(pokemonAktif!.sprites.gambarUtama, height: 200),
            SizedBox(height: 8),
            Text(
              pokemonAktif!.name.toUpperCase(),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: pokemonAktif!.types.map((t) {
                final warna = ambilWarnaTipe(t.type.name);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: warna,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    t.type.name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8),
            Text(
              'Tinggi: ${pokemonAktif!.height / 10} m  •  Berat: ${pokemonAktif!.weight / 10} kg',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            _buildStatBar('HP', pokemonAktif!.ambilStatistik('hp'), warnaUtama),
            _buildStatBar(
              'Attack',
              pokemonAktif!.ambilStatistik('attack'),
              warnaUtama,
            ),
            _buildStatBar(
              'Defense',
              pokemonAktif!.ambilStatistik('defense'),
              warnaUtama,
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Rantai Evolusi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 12),
            if (sedangMemuatEvolusi)
              CircularProgressIndicator()
            else if (rantaiEvolusi != null)
              _buildEvolusiWidget(rantaiEvolusi!.chain)
            else
              Text(
                'Data evolusi tidak tersedia',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, int nilai, Color warna) {
    final persentase = (nilai / 150).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
              Text('$nilai', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: persentase,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(warna),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvolusiWidget(Chain rootChain) {
    List<Chain> listEvolusi = [];
    Chain? current = rootChain;

    while (current != null) {
      listEvolusi.add(current);
      current = current.evolvesTo.isNotEmpty ? current.evolvesTo.first : null;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: listEvolusi.map((item) {
          final isAktif =
              item.species.name.toLowerCase() ==
              pokemonAktif?.name.toLowerCase();
          return Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => cari(item.species.name),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isAktif ? Colors.amber : Colors.transparent,
                            width: 2,
                          ),
                          color: Colors.white.withOpacity(0.08),
                        ),
                        child: Image.network(
                          item.imageUrl,
                          width: 55,
                          height: 55,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.catching_pokemon, size: 40),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item.species.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isAktif
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isAktif ? Colors.amber : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (item != listEvolusi.last)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
