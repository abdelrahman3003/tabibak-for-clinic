enum AppointmentStatus {
  pending(1),
  confirmed(2),
  completed(3),
  cancelled(4);

  final int id;
  const AppointmentStatus(this.id);
}
