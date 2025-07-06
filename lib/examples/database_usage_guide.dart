// GUÍA DE USO DE LA BASE DE DATOS EN UNIRIDE DRIVER

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uniride_driver/core/database/database_helper.dart';
import 'package:uniride_driver/core/di/injection_container.dart' as di;
import 'package:uniride_driver/features/auth/data/models/user_model.dart';
import 'package:uniride_driver/features/auth/domain/entities/role.dart';
import 'package:uniride_driver/features/auth/domain/entities/user_status.dart';
import 'package:uniride_driver/features/auth/domain/services/user_local_service.dart';

// 1. USANDO LA BASE DE DATOS A TRAVÉS DEL SERVICE LAYER (RECOMENDADO)
// ================================================================

class DatabaseUsageGuide {
  
  // EJEMPLO 1: Guardar un usuario
  Future<void> saveUserExample() async {
    // Obtener el servicio desde el container de inyección de dependencias
    final userService = di.sl<UserLocalService>();
    
    // Crear un usuario
    final user = UserModel(
      id: '123',
      email: 'conductor@universidad.edu.co',
      status: UserStatus.verified,
      roles: [Role.driver],
    );
    
    // Guardar en la base de datos
    await userService.saveUser(user);
    print('Usuario guardado exitosamente');
  }
  
  // EJEMPLO 2: Obtener un usuario
  Future<UserModel?> getUserExample() async {
    final userService = di.sl<UserLocalService>();
    
    // Obtener el usuario (solo hay uno por diseño)
    final user = await userService.getUser();
    
    if (user != null) {
      print('Usuario encontrado: ${user.email}');
      print('Estado: ${user.status.value}');
      print('Rol: ${user.roles.first.value}');
      return user;
    } else {
      print('No se encontró ningún usuario');
      return null;
    }
  }
  
  // EJEMPLO 3: Eliminar todos los usuarios
  Future<void> deleteAllUsersExample() async {
    final userService = di.sl<UserLocalService>();
    
    await userService.deleteAllUsers();
    print('Todos los usuarios eliminados');
  }
  
  // EJEMPLO 4: Verificar si hay un usuario logueado
  Future<bool> isUserLoggedIn() async {
    final userService = di.sl<UserLocalService>();
    final user = await userService.getUser();
    return user != null;
  }
  
  // EJEMPLO 5: Obtener información del usuario actual
  Future<Map<String, dynamic>?> getCurrentUserInfo() async {
    final userService = di.sl<UserLocalService>();
    final user = await userService.getUser();
    
    if (user != null) {
      return {
        'id': user.id,
        'email': user.email,
        'status': user.status.value,
        'role': user.roles.first.value,
        'isVerified': user.status == UserStatus.verified,
        'isDriver': user.roles.first == Role.driver,
      };
    }
    return null;
  }
}

// 2. USANDO LA BASE DE DATOS DIRECTAMENTE (AVANZADO)
// ===================================================

class DirectDatabaseUsage {
  
  // EJEMPLO 1: Acceso directo a la base de datos
  Future<void> directDatabaseExample() async {
    // Obtener la instancia de la base de datos
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    
    // Realizar consultas directas
    final List<Map<String, dynamic>> users = await db.query(
      DatabaseHelper.usersTable,
      where: 'status = ?',
      whereArgs: ['VERIFIED'],
    );
    
    print('Usuarios verificados: ${users.length}');
  }
  
  // EJEMPLO 2: Crear una nueva tabla (migración)
  Future<void> createCustomTable() async {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS custom_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    
    print('Tabla personalizada creada');
  }
  
  // EJEMPLO 3: Insertar datos en una tabla personalizada
  Future<void> insertCustomData() async {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    
    await db.insert(
      'custom_table',
      {
        'name': 'Ejemplo',
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    print('Datos insertados');
  }
}

// 3. USANDO EN WIDGETS Y BLOCS
// =============================

// Ejemplo de uso en un Widget
class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        
        final user = snapshot.data;
        if (user == null) {
          return const Text('Usuario no encontrado');
        }
        
        return Column(
          children: [
            Text('Email: ${user.email}'),
            Text('Estado: ${user.status.value}'),
            Text('Rol: ${user.roles.first.value}'),
          ],
        );
      },
    );
  }
  
  Future<UserModel?> _getCurrentUser() async {
    final userService = di.sl<UserLocalService>();
    return await userService.getUser();
  }
}

// Ejemplo de uso en un Bloc
abstract class UserEvent {}
class LoadUserEvent extends UserEvent {}
class SaveUserEvent extends UserEvent {
  final UserModel user;
  SaveUserEvent(this.user);
}

abstract class UserState {}
class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}
class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserLocalService userService;
  
  UserBloc({required this.userService}) : super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<SaveUserEvent>(_onSaveUser);
  }
  
  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await userService.getUser();
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserError('Usuario no encontrado'));
      }
    } catch (e) {
      emit(UserError('Error al cargar usuario: $e'));
    }
  }
  
  Future<void> _onSaveUser(SaveUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userService.saveUser(event.user);
      emit(UserLoaded(event.user));
    } catch (e) {
      emit(UserError('Error al guardar usuario: $e'));
    }
  }
}

// 4. MEJORES PRÁCTICAS
// ====================

/*
1. **Usa siempre el Service Layer**: 
   - Nunca accedas a la base de datos directamente desde los widgets
   - Usa los servicios implementados (UserLocalService, etc.)

2. **Manejo de errores**: 
   - Siempre envuelve las operaciones de BD en try-catch
   - Maneja los casos donde no hay datos

3. **Inyección de dependencias**: 
   - Usa el container DI (di.sl<ServiceType>())
   - Esto hace el código más testeable y mantenible

4. **Operaciones asíncronas**: 
   - Todas las operaciones de BD son asíncronas
   - Usa await y Future correctamente

5. **Validación**: 
   - Valida los datos antes de guardarlos
   - Verifica que los objetos no sean null

6. **Performance**: 
   - Evita consultas innecesarias
   - Usa FutureBuilder para cargar datos en widgets
*/
