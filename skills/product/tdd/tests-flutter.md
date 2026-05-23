# Flutter widget tests — seams and patterns

Use with **`/tdd`** bug-fix mode and **`/diagnose`** Phase 1.

## Choose the correct seam

| Bug report | Test harness | Avoid |
|------------|--------------|-------|
| Desktop side panel | `pumpMoneyAppDesktop` + `TransactionFormPresentation.panel` | Mobile `money_screen_test` |
| Mobile bottom sheet | `pumpMoneyApp` + sheet flow | Isolated widget without sheet focus chain |
| Pure keyboard mapping | Unit test on `handleAmountCalculatorKeyEvent` | Widget test alone |
| Focus / gesture / double-fire | Widget test at parent that owns `FocusNode` | Unit test on handler only |

**Rule:** same presentation mode as the user's report.

## Physical keyboard in widget tests

```dart
await tester.tap(find.byKey(const Key('expense_amount_field')));
await tester.pumpAndSettle();

await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
await tester.pump();

expect(find.text('1'), findsWidgets); // not '11' — duplicate handler bug
```

Focus the widget that owns `onKeyEvent` before `sendKeyEvent`. If flaky, use `pump()` instead of `pumpAndSettle()` after key events.

## Keypad pointer tests

Prefer tapping by stable keys (`calc_key_plus`, `calc_key_done`). Assert **observable UI** (panel visible, text on screen), not private state.

## Good vs bad (Flutter)

```dart
// GOOD — behavior through UI
testWidgets('done key closes calculator panel', (tester) async {
  await pumpPanel(tester);
  await tester.tap(find.byKey(const Key('expense_amount_field')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('calc_key_done')));
  await tester.pumpAndSettle();
  expect(find.byType(AmountCalculatorPanel), findsNothing);
});

// BAD — implementation detail
test('closeAmountCalculator sets flag false', () {
  expect(sheet._amountCalculatorOpen, isFalse); // private field
});
```

## Helpers

Reuse project test helpers (`test/test_helpers.dart`): `createTestContainer`, `pumpMoneyApp`, `pumpMoneyAppDesktop`, seed helpers.

## When widget tests won't stabilize

Document in `docs/adr/` or `docs/manual_qa_*.md`. Do not delete the test without a replacement loop.
