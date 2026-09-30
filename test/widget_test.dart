// Smoke test sederhana untuk aplikasi Pokedex.
//
// Memastikan MyApp bisa di-build dan elemen dasar UI muncul.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spotify/main.dart';

void main() {
  testWidgets('App Pokedex tampil dengan benar', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Judul AppBar muncul.
    expect(find.text('Pokedex'), findsOneWidget);

    // Ketiga tab navigasi bawah muncul.
    expect(find.text('Cari'), findsOneWidget);
    expect(find.text('Tipe'), findsOneWidget);
    expect(find.text('Favorit'), findsOneWidget);

    // Kolom pencarian tampil di tab utama.
    expect(find.byType(TextField), findsOneWidget);
  });
}
