class ClinicReportEntity {
  const ClinicReportEntity({
    required this.totalBookings,
    required this.completedBookings,
    required this.cancelledBookings,
    required this.totalRevenue,
    required this.totalExpenses,
    required this.dailyRevenue,
  });

  final int totalBookings;
  final int completedBookings;
  final int cancelledBookings;
  final double totalRevenue;
  final double totalExpenses;
  final List<double> dailyRevenue;

  double get netProfit => totalRevenue - totalExpenses;
}
