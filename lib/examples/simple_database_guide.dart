// GUÍA PRÁCTICA: CÓMO USAR LA BASE DE DATOS EN UNIRIDE DRIVER

import 'package:flutter/material.dart';
import 'package:uniride_driver/core/di/injection_container.dart' as di;
import 'package:uniride_driver/features/auth/data/models/user_model.dart';
import 'package:uniride_driver/features/auth/domain/entities/role.dart';
import 'package:uniride_driver/features/auth/domain/entities/user_status.dart';
import 'package:uniride_driver/features/auth/domain/services/user_local_service.dart';

// ========================================
// 1. EJEMPLO SIMPLE: GUARDAR Y OBTENER USUARIO
// ========================================

class SimpleUserExample extends StatefulWidget {
  const SimpleUserExample({super.key});

  @override
  State<SimpleUserExample> createState() => _SimpleUserExampleState();
}

class _SimpleUserExampleState extends State<SimpleUserExample> {
  UserModel? currentUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // Cargar usuario desde la base de datos
  Future<void> _loadUser() async {
    setState(() => isLoading = true);
    
    try {
      final userService = di.sl<UserLocalService>();
      final user = await userService.getUser();
      
      setState(() {
        currentUser = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error cargando usuario: $e');
    }
  }

  // Guardar nuevo usuario
  Future<void> _saveUser() async {
    try {
      final userService = di.sl<UserLocalService>();
      
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: 'conductor@universidad.edu.co',
        status: UserStatus.verified,
        roles: [Role.driver],
      );
      
      await userService.saveUser(newUser);
      
      // Recargar la lista
      _loadUser();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario guardado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Eliminar usuario
  Future<void> _deleteUser() async {
    try {
      final userService = di.sl<UserLocalService>();
      await userService.deleteAllUsers();
      
      _loadUser();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario eliminado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo Base de Datos'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mostrar información del usuario
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usuario Actual',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else if (currentUser != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${currentUser!.id}'),
                          Text('Email: ${currentUser!.email}'),
                          Text('Estado: ${currentUser!.status.value}'),
                          Text('Rol: ${currentUser!.roles.first.value}'),
                        ],
                      )
                    else
                      const Text('No hay usuario guardado'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Botones de acción
            ElevatedButton(
              onPressed: _saveUser,
              child: const Text('Guardar Usuario'),
            ),
            
            const SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: _loadUser,
              child: const Text('Recargar Usuario'),
            ),
            
            const SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: _deleteUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Eliminar Usuario'),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================================
// 2. FUNCIONES ÚTILES PARA USAR EN CUALQUIER PARTE
// ========================================

class DatabaseUtils {
  
  // Verificar si hay un usuario logueado
  static Future<bool> isUserLoggedIn() async {
    try {
      final userService = di.sl<UserLocalService>();
      final user = await userService.getUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
  
  // Obtener información del usuario actual
  static Future<UserModel?> getCurrentUser() async {
    try {
      final userService = di.sl<UserLocalService>();
      return await userService.getUser();
    } catch (e) {
      print('Error obteniendo usuario: $e');
      return null;
    }
  }
  
  // Guardar usuario después del login
  static Future<bool> saveUserAfterLogin({
    required String id,
    required String email,
    required UserStatus status,
    required List<Role> roles,
  }) async {
    try {
      final userService = di.sl<UserLocalService>();
      
      final user = UserModel(
        id: id,
        email: email,
        status: status,
        roles: roles,
      );
      
      await userService.saveUser(user);
      return true;
    } catch (e) {
      print('Error guardando usuario: $e');
      return false;
    }
  }
  
  // Logout (eliminar usuario local)
  static Future<bool> logout() async {
    try {
      final userService = di.sl<UserLocalService>();
      await userService.deleteAllUsers();
      return true;
    } catch (e) {
      print('Error haciendo logout: $e');
      return false;
    }
  }
  
  // Verificar si el usuario es conductor
  static Future<bool> isDriver() async {
    try {
      final user = await getCurrentUser();
      return user?.roles.first == Role.driver;
    } catch (e) {
      return false;
    }
  }
  
  // Verificar si el usuario está verificado
  static Future<bool> isVerified() async {
    try {
      final user = await getCurrentUser();
      return user?.status == UserStatus.verified;
    } catch (e) {
      return false;
    }
  }
}

// ========================================
// 3. EJEMPLO DE USO EN UN WIDGET REAL
// ========================================

class UserAuthenticationWidget extends StatefulWidget {
  const UserAuthenticationWidget({super.key});

  @override
  State<UserAuthenticationWidget> createState() => _UserAuthenticationWidgetState();
}

class _UserAuthenticationWidgetState extends State<UserAuthenticationWidget> {
  bool isLoggedIn = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final loggedIn = await DatabaseUtils.isUserLoggedIn();
    final currentUser = await DatabaseUtils.getCurrentUser();
    
    setState(() {
      isLoggedIn = loggedIn;
      user = currentUser;
    });
  }

  Future<void> _simulateLogin() async {
    final success = await DatabaseUtils.saveUserAfterLogin(
      id: '12345',
      email: 'conductor@universidad.edu.co',
      status: UserStatus.verified,
      roles: [Role.driver],
    );
    
    if (success) {
      _checkAuthStatus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login exitoso')),
      );
    }
  }

  Future<void> _simulateLogout() async {
    final success = await DatabaseUtils.logout();
    
    if (success) {
      _checkAuthStatus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout exitoso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de Autenticación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      isLoggedIn ? 'Usuario Logueado' : 'Usuario No Logueado',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    if (isLoggedIn && user != null) ...[
                      Text('Email: ${user!.email}'),
                      Text('Estado: ${user!.status.value}'),
                      Text('Rol: ${user!.roles.first.value}'),
                    ] else
                      const Text('No hay información del usuario'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            if (!isLoggedIn)
              ElevatedButton(
                onPressed: _simulateLogin,
                child: const Text('Simular Login'),
              )
            else
              ElevatedButton(
                onPressed: _simulateLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Cerrar Sesión'),
              ),
          ],
        ),
      ),
    );
  }
}

// ========================================
// 4. CÓMO USAR EN TU APLICACIÓN
// ========================================

/*
PASOS PARA USAR LA BASE DE DATOS:

1. **Importar las dependencias necesarias:**
   ```dart
   import 'package:uniride_driver/core/di/injection_container.dart' as di;
   import 'package:uniride_driver/features/auth/domain/services/user_local_service.dart';
   ```

2. **Obtener el servicio:**
   ```dart
   final userService = di.sl<UserLocalService>();
   ```

3. **Operaciones básicas:**
   ```dart
   // Guardar usuario
   await userService.saveUser(userModel);
   
   // Obtener usuario
   final user = await userService.getUser();
   
   // Eliminar todos los usuarios
   await userService.deleteAllUsers();
   ```

4. **Manejo de errores:**
   ```dart
   try {
     final user = await userService.getUser();
     // Usar el usuario
   } catch (e) {
     print('Error: $e');
   }
   ```

5. **Usar en widgets:**
   - Usa FutureBuilder para cargar datos
   - Usa setState para actualizar la UI
   - Maneja estados de carga y error

6. **Funciones útiles:**
   - DatabaseUtils.isUserLoggedIn()
   - DatabaseUtils.getCurrentUser()
   - DatabaseUtils.logout()
   - DatabaseUtils.isDriver()
   - DatabaseUtils.isVerified()
*/
