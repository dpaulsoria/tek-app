# Peluquería Anita - App Flutter

Cliente móvil Flutter para gestionar autenticación y creación de citas.

---

## 📁 Estructura del proyecto Flutter

```
lib/
├─ main.dart             # Entry point de la app
├─ models/
│  ├─ user.dart          # Modelo User (login + clientes)
│  └─ cita.dart          # Modelo Cita
├─ services/
│  └─ api_service.dart   # Llamadas HTTP al backend
└─ screens/
   ├─ login_screen.dart  # Pantalla de login
   └─ home_screen.dart   # Formulario de cita + logout
```

---

## 🚀 Requisitos

* Flutter SDK (>=3.0)
* Dispositivo Android o emulador

---

## 🔧 Configuración

1. **Modificar `baseUrl`** en `lib/services/api_service.dart`:

   ```dart
   static const String _baseUrl =
     // Emulador Android:
     'http://10.0.2.2:10000/api';
     // Dispositivo real: 'http://<TU_IP>:10000/api';
   ```

2. **Permiso de Internet**:
   En `android/app/src/main/AndroidManifest.xml`, sección `main`:

   ```xml
   <manifest xmlns:android="http://schemas.android.com/apk/res/android">
     <uses-permission android:name="android.permission.INTERNET"/>
     <application
       android:usesCleartextTraffic="true"
       ...>
       ...
     </application>
   </manifest>
   ```

3. **Dependencias**:

   ```bash
   flutter pub get
   ```

---

## 🏃‍♂️ Uso

1. `flutter run` para iniciar la app.
2. **Login**: Ingresa correo y contraseña.
3. **HomeScreen**:

   * Lista de clientes en un dropdown.
   * Selector de fecha y hora (nativo).
   * Campos de "Cantidad atención", "Total servicio" y "Status".
   * Botón **Crear Cita** envía al backend.
   * Botón logout en AppBar vuelve a login.

---

## 📦 Modelos

### User

```dart
class User {
  final int id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String token;
  // campos opcionales para cliente: document, phone, address...
}
```

### Cita

```dart
class Cita {
  final int id;
  final DateTime date;
  final String timeArrival; // format HH:MM:00
  final int clienteId;
  final int? amountAttention;
  final double? totalService;
  final String status;
}
```

---

## ⚙️ Servicio API

Ubicado en `lib/services/api_service.dart`, expone métodos:

* `login(email, password)` → `User`
* `getClients(token)` → `List<User>`
* `createAppointment(...)` → `Cita`
* `logout(token)` → `void`

---

## 📋 Pantallas

* **login\_screen.dart**: captura credenciales y redirige a Home.
* **home\_screen.dart**: carga clientes, muestra form de cita, selectors nativos y logout.

---

¡Listo para gestionar citas desde Flutter! Si necesitas personalizaciones adicionales, modifica los widgets o el `ApiService` según tu backend.
