// ignore_for_file: public_member_api_docs, sort_constructors_first
class DateBook {
  late DateTime? timeCheckin;
  late DateTime? timeCheckout;
  late String room;

  @override
  String toString() => room;

  int soNgayO() => timeCheckout!.difference(timeCheckin!).inDays + 1;
}
