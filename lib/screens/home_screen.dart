// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({required this.token, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = ApiService();

  // datos del dropdown
  List<User> _clients = [];
  User? _selectedClient;

  // campos del formulario
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _amountCtrl = TextEditingController();
  final _totalCtrl  = TextEditingController();
  String _status    = 'pendiente';

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final list = await _api.getClients(widget.token);
      setState(() {
        _clients = list;
        if (list.isNotEmpty) _selectedClient = list.first;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando clientes: $e')),
      );
    }
  }

  Future<void> _onLogout() async {
    await _api.logout(widget.token);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> _onSubmit() async {
    if (_selectedDate == null || _selectedTime == null || _selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona fecha, hora y cliente')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      // formatea HH:MM
      final hour   = _selectedTime!.hour.toString().padLeft(2, '0');
      final minute = _selectedTime!.minute.toString().padLeft(2, '0');
      final timeArrival = '$hour:$minute:00';
      final cita = await _api.createAppointment(
        token: widget.token,
        date: _selectedDate!,
        timeArrival: timeArrival,
        clienteId: _selectedClient!.id,
        amountAttention: int.tryParse(_amountCtrl.text),
        totalService: double.tryParse(_totalCtrl.text),
        status: _status,
      );
      setState(() {
        _selectedDate  = null;
        _selectedTime  = null;
        _amountCtrl.clear();
        _totalCtrl.clear();
        _status        = 'pendiente';
        // Opcional: reset al primer cliente
        if (_clients.isNotEmpty) _selectedClient = _clients.first;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cita creada (ID ${cita.id})')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creando cita: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cita'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _onLogout,
          )
        ],
      ),
      body: _clients.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown de clientes
            DropdownButton<User>(
              isExpanded: true,
              value: _selectedClient,
              items: _clients.map((u) {
                return DropdownMenuItem(
                  value: u,
                  child: Text('${u.firstName} ${u.lastName}'),
                );
              }).toList(),
              onChanged: (u) => setState(() => _selectedClient = u),
            ),
            const SizedBox(height: 16),

            // Selector de fecha
            ListTile(
              title: Text(
                _selectedDate == null
                    ? 'Selecciona fecha'
                    : _selectedDate!.toLocal().toString().split(' ')[0],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (d != null) setState(() => _selectedDate = d);
              },
            ),
            const SizedBox(height: 16),

            // Selector de hora
            ListTile(
              title: Text(
                _selectedTime == null
                    ? 'Selecciona hora'
                    : _selectedTime!.format(context),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final t = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (t != null) setState(() {
                  _selectedTime = t;
                });
              },
            ),
            const SizedBox(height: 16),

            // Cantidad atención
            TextField(
              controller: _amountCtrl,
              decoration: const InputDecoration(
                labelText: 'Cantidad atención',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Total servicio
            TextField(
              controller: _totalCtrl,
              decoration: const InputDecoration(
                labelText: 'Total servicio',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Status
            DropdownButton<String>(
              value: _status,
              items: ['pendiente', 'confirmada', 'cancelada']
                  .map((s) => DropdownMenuItem(
                value: s,
                child: Text(s.capitalize()),
              ))
                  .toList(),
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 24),

            // Botón Crear Cita
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _onSubmit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Crear Cita'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// extensión para capitalizar
extension on String {
  String capitalize() =>
      isEmpty ? this : this[0].toUpperCase() + substring(1);
}
