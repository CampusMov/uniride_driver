import 'package:flutter/material.dart';
import 'package:uniride_driver/core/di/injection_container.dart' as di;
import 'package:uniride_driver/features/auth/data/models/user_model.dart';
import 'package:uniride_driver/features/auth/domain/entities/role.dart';
import 'package:uniride_driver/features/auth/domain/entities/user_status.dart';
import 'package:uniride_driver/features/auth/domain/services/user_local_service.dart';

class DatabaseExampleWidget extends StatelessWidget {
  const DatabaseExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database Example')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              // Obtener el servicio de la base de datos
              final userService = di.sl<UserLocalService>();
              
              // Crear un usuario de ejemplo
              final user = UserModel(
                id: '123',
                email: 'usuario@ejemplo.com',
                status: UserStatus.verified,
                roles: [Role.driver],
              );
              
              // Guardar el usuario en la base de datos
              await userService.saveUser(user);
              
              print('Usuario guardado exitosamente');
            },
            child: const Text('Guardar Usuario'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Obtener el servicio de la base de datos
              final userService = di.sl<UserLocalService>();
              
              // Obtener el usuario de la base de datos
              final user = await userService.getUser();
              
              if (user != null) {
                print('Usuario encontrado: ${user.email}');
              } else {
                print('No se encontró ningún usuario');
              }
            },
            child: const Text('Obtener Usuario'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Obtener el servicio de la base de datos
              final userService = di.sl<UserLocalService>();
              
              // Eliminar todos los usuarios
              await userService.deleteAllUsers();
              
              print('Todos los usuarios eliminados');
            },
            child: const Text('Eliminar Todos los Usuarios'),
          ),
        ],
      ),
    );
  }
}
