import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'debug_info_row.dart';

class DebugAccountInfo extends StatelessWidget {
  final User user;

  const DebugAccountInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD4913D).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4913D), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DEBUG - Compte Connecté',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD4913D),
            ),
          ),
          const SizedBox(height: 12),
          DebugInfoRow(label: 'User ID', value: user.uid),
          DebugInfoRow(label: 'Email', value: user.email ?? 'Non défini'),
          DebugInfoRow(
            label: 'Display Name',
            value: user.displayName ?? 'Non défini',
          ),
          const SizedBox(height: 8),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users_test')
                .doc(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('Chargement...');
              }
              final data = snapshot.data?.data() as Map<String, dynamic>?;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DebugInfoRow(
                    label: 'Prénom',
                    value: data?['firstName'] ?? 'Non défini',
                  ),
                  DebugInfoRow(
                    label: 'Nom',
                    value: data?['lastName'] ?? 'Non défini',
                  ),
                  DebugInfoRow(
                    label: 'Username',
                    value: data?['username'] ?? 'Non défini',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
