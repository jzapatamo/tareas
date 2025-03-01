import 'package:taller_dart/taller_dart.dart' as taller_dart;

class Empleado {
  String nombre;
  String empresa;
  int horasTrabajadas;
  double? bono;

  Empleado(this.nombre, this.empresa, this.horasTrabajadas, {this.bono});
}

double calcularSalario(int horasTrabajadas) {
  const double tarifaNormal = 50000;
  const double tarifaExtra = 80000;
  const int limiteHorasNormales = 160;

  if (horasTrabajadas <= limiteHorasNormales) {
    return horasTrabajadas * tarifaNormal;
  } else {
    int horasExtras = horasTrabajadas - limiteHorasNormales;
    return (limiteHorasNormales * tarifaNormal) + (horasExtras * tarifaExtra);
  }
}

void main() {
  List<Empleado> empleados = [
    Empleado("Pepe Pérez", "Motores S.A.", 170, bono: 23000),
    Empleado("Ana Gómez", "Motores S.A.", 150),
    Empleado("Carlos Ruiz", "Motores S.A.", 180, bono: 50000),
    Empleado("Luis Torres", "ElectroTech", 160),
    Empleado("María López", "Motores S.A.", 200),
  ];

  for (var empleado in empleados) {
    if (empleado.empresa == "Motores S.A.") {
      double salario = calcularSalario(empleado.horasTrabajadas);

      if (empleado.bono != null) {
        print("${empleado.nombre} gana \$${salario.toStringAsFixed(0)} y su subsidio de transporte es \$${empleado.bono!.toStringAsFixed(0)}");
      } else {
        print("${empleado.nombre} gana \$${salario.toStringAsFixed(0)}");
      }
    }
  }
}
