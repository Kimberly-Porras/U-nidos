import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/bloc/register/register_bloc.dart';
import '../auth/bloc/register/register_event.dart';
import '../auth/bloc/register/register_state.dart';
import 'interests_screen.dart';

class Profile extends StatefulWidget {
  final String email;
  final String username;
  final String password;

  const Profile({
    super.key,
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController carreraCtrl = TextEditingController();
  final TextEditingController anioIngresoCtrl = TextEditingController();
  final TextEditingController habilidadesCtrl = TextEditingController();
  final TextEditingController fechaNacimientoCtrl = TextEditingController();

  String? universidadSeleccionada;
  List<String> campus = [];
  String? campusSeleccionado;

  DateTime? fechaNacimiento;

  final Map<String, List<String>> campusPorUniversidad = {
    'UCR': [
      'Sede Rodrigo Facio (San Pedro)',
      'Sede de Occidente (San Ramón)',
      'Recinto de Grecia (Grecia)',
      'Sede del Atlántico (Turrialba)',
      'Recinto de Paraíso (Paraíso)',
      'Recinto de Guápiles (Guápiles)',
      'Sede de Guanacaste (Liberia)',
      'Recinto de Santa Cruz (Santa Cruz)',
      'Sede del Caribe (Limón)',
      'Sede del Pacífico (Puntarenas)',
      'Sede del Sur (Golfito)',
      'Sede Interuniversitaria (Alajuela)',
    ],
    'UNA': [
      'Campus Omar Dengo (Heredia)',
      'Campus Benjamín Núñez (Heredia)',
      'Sede Interuniversitaria (Alajuela)',
      'Campus Sarapiquí (Sarapiquí)',
      'Campus Coto (Corredores)',
      'Campus Pérez Zeledón (Pérez Zeledón)',
      'Campus Liberia (Liberia)',
      'Campus Nicoya (Nicoya)',
    ],
    'TEC': [
      'Centro Universitario (Campus Central - Cartago)',
      'Centro Universitario (Sede San Carlos)',
      'Centro Universitario (Centro Académico de San José)',
      'Centro Universitario (Centro Académico de Alajuela)',
      'Centro Universitario (Centro Académico de Limón)',
      'Centro Universitario (Centro Académico de Zapote)',
      'Centro Universitario (Centro de Investigación en Palma Aceitera - Coto)',
    ],
    'UNED': [
      'Centro Universitario (Acosta)',
      'Centro Universitario (Alajuela)',
      'Centro Universitario (Atenas)',
      'Centro Universitario (Buenos Aires)',
      'Centro Universitario (Cañas)',
      'Centro Universitario (Cartago)',
      'Centro Universitario (Ciudad Neily)',
      'Centro Universitario (Desamparados)',
      'Centro Universitario (Guápiles)',
      'Centro Universitario (Heredia)',
      'Centro Universitario (Jicaral)',
      'Centro Universitario (La Cruz)',
      'Centro Universitario (La Reforma)',
      'Centro Universitario (Liberia)',
      'Centro Universitario (Limón)',
      'Centro Universitario (Los Chiles)',
      'Centro Universitario (Monteverde)',
      'Centro Universitario (Nicoya)',
      'Centro Universitario (Orotina)',
      'Centro Universitario (Osa)',
      'Centro Universitario (Palmares)',
      'Centro Universitario (Parrita)',
      'Centro Universitario (Pérez Zeledón)',
      'Centro Universitario (Puerto Jiménez)',
      'Centro Universitario (Puntarenas)',
      'Centro Universitario (Puriscal)',
      'Centro Universitario (San Carlos)',
      'Centro Universitario (San José)',
      'Centro Universitario (San Marcos)',
      'Centro Universitario (San Vito)',
      'Centro Universitario (Santa Cruz)',
      'Centro Universitario (Sarapiquí)',
      'Centro Universitario (Siquirres)',
      'Centro Universitario (Talamanca)',
      'Centro Universitario (Tilarán)',
      'Centro Universitario (Turrialba)',
      'Centro Universitario (Upala)',
    ],

    'UTN': [
      'Centro Universitario (Sede Central - Alajuela)',
      'Centro Universitario (Sede de Atenas)',
      'Centro Universitario (Sede de Guanacaste - Liberia)',
      'Centro Universitario (Sede de Guanacaste - Cañas)',
      'Centro Universitario (Sede del Pacífico - Puntarenas)',
      'Centro Universitario (Sede del Pacífico - El Roble)',
      'Centro Universitario (Sede de San Carlos)',
      'Centro Universitario (Centro de Formación Pedagógica y Tecnología Educativa - CFPTE)',
    ],
  };

  @override
  void initState() {
    super.initState();
    _cargarUniversidadYCampus();
  }

  Future<void> _cargarUniversidadYCampus() async {
    final prefs = await SharedPreferences.getInstance();
    universidadSeleccionada = prefs.getString('universidad') ?? '';
    setState(() {
      campus = campusPorUniversidad[universidadSeleccionada] ?? [];
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    carreraCtrl.dispose();
    anioIngresoCtrl.dispose();
    habilidadesCtrl.dispose();
    fechaNacimientoCtrl.dispose();
    super.dispose();
  }

  void _seleccionarFechaNacimiento() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        fechaNacimiento = picked;
        fechaNacimientoCtrl.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro - Paso 2')),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is RegisterError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is RegisterProfileCompleted) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => Interests(
                      email: widget.email,
                      username: widget.username,
                      password: widget.password,
                      name: nameCtrl.text,
                      campus: campusSeleccionado!,
                    ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: carreraCtrl,
                  decoration: const InputDecoration(labelText: 'Carrera'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: anioIngresoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Año de ingreso',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: habilidadesCtrl,
                  decoration: const InputDecoration(labelText: 'Habilidades'),
                  maxLines: null, // ✅ Multilínea
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 16),
                if (campus.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value: campusSeleccionado,
                    hint: const Text('Seleccione un campus'),
                    items:
                        campus.map((campus) {
                          return DropdownMenuItem(
                            value: campus,
                            child: Text(campus),
                          );
                        }).toList(),
                    onChanged: (valor) {
                      setState(() {
                        campusSeleccionado = valor;
                      });
                    },
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  controller: fechaNacimientoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de nacimiento',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: _seleccionarFechaNacimiento,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (campusSeleccionado == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor seleccione un campus'),
                        ),
                      );
                      return;
                    }

                    if (fechaNacimiento == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor seleccione su fecha de nacimiento',
                          ),
                        ),
                      );
                      return;
                    }

                    if (anioIngresoCtrl.text.isEmpty ||
                        int.tryParse(anioIngresoCtrl.text) == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ingrese un año válido')),
                      );
                      return;
                    }

                    context.read<RegisterBloc>().add(
                      ProfileCompleted(
                        nombre: nameCtrl.text,
                        universidad: universidadSeleccionada ?? '',
                        campus: campusSeleccionado!,
                        carrera: carreraCtrl.text,
                        anioIngreso: int.parse(anioIngresoCtrl.text),
                        habilidades: habilidadesCtrl.text,
                        fechaNacimiento: fechaNacimiento!,
                      ),
                    );
                  },
                  child: const Text('Siguiente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
