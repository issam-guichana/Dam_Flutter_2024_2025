import 'package:flutter/material.dart';
import 'package:flutter_application_dam/Providers/UsersProvider.dart';
import 'package:provider/provider.dart';

class StatisticsPanel extends StatelessWidget {
  const StatisticsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statistiques des Utilisateurs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade800,
                ),
              ),
              const SizedBox(height: 20),
              _buildStatCard(
                icon: Icons.people,
                title: 'Total Utilisateurs',
                value: userProvider.totalUsers.toString(),
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              Text(
                'Distribution des Rôles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade600,
                ),
              ),
              const SizedBox(height: 8),
              _buildRoleDistribution(userProvider.roleDistribution),
              const SizedBox(height: 16),
              Text(
                'Domaines Email',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade600,
                ),
              ),
              const SizedBox(height: 8),
              _buildEmailDomainStats(userProvider.emailDomainStats),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleDistribution(Map<String, int> distribution) {
    return Column(
      children: distribution.entries.map((entry) {
        double percentage = entry.value / distribution.values.reduce((a, b) => a + b) * 100;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' Admin : 1 utilisateur',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                ' Normal users : ${entry.value} utilisateurs',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.deepPurple.shade400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmailDomainStats(Map<String, int> domains) {
    return Column(
      children: domains.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.key),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  entry.value.toString(),
                  style: TextStyle(
                    color: Colors.deepPurple.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}