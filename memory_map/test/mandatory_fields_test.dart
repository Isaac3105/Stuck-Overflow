import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_map/features/trips/presentation/plan/create_trip_page.dart';
import 'package:memory_map/features/trips/presentation/plan/activity_block_form.dart';

void main() {
  testWidgets('CreateTripPage shows red asterisks for mandatory fields', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CreateTripPage(),
        ),
      ),
    );

    // Find "Trip name *" with red color
    final nameLabel = find.byWidgetPredicate(
      (widget) => widget is RichText && widget.text.toPlainText() == 'Trip name *',
    );
    expect(nameLabel, findsOneWidget);

    // Verify asterisk is red
    final richText = tester.widget<RichText>(nameLabel);
    final textSpan = richText.text as TextSpan;
    final asteriskSpan = textSpan.children![1] as TextSpan;
    expect(asteriskSpan.style!.color, Colors.red);

    // Find "Dates *"
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText() == 'Dates *'), findsOneWidget);

    // Find "Countries *" (via CountryPickerField)
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText() == 'Countries *'), findsOneWidget);
  });

  testWidgets('ActivityBlockForm shows red asterisk for Title', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ActivityBlockForm(dayId: 'test-day'),
          ),
        ),
      ),
    );

    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText() == 'Title *'), findsOneWidget);
  });
}
