// lib/models/cita.dart

class Cita {
  final int id;
  final DateTime date;
  final String timeArrival;
  final int clienteId;
  final int? amountAttention;
  final double? totalService;
  final String status;

  Cita({
    required this.id,
    required this.date,
    required this.timeArrival,
    required this.clienteId,
    this.amountAttention,
    this.totalService,
    required this.status,
  });

  factory Cita.fromJson(Map<String, dynamic> json) => Cita(
    id: json['id'] as int,
    date: DateTime.parse(json['date'] as String),
    timeArrival: json['time_arrival'] as String,
    clienteId: json['cliente_id'] as int,
    amountAttention: json['amount_attention'] != null
        ? json['amount_attention'] as int
        : null,
    totalService: json['total_service'] != null
        ? (json['total_service'] as num).toDouble()
        : null,
    status: json['status'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String().split('T').first,
    'time_arrival': timeArrival,
    'cliente_id': clienteId,
    if (amountAttention != null) 'amount_attention': amountAttention,
    if (totalService != null) 'total_service': totalService,
    'status': status,
  };
}
