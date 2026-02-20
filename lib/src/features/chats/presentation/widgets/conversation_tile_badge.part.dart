part of 'conversation_tile.dart';

Widget _conversationBadge(int unread) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: const BoxDecoration(
    color: Color(0xFFD4913D),
    shape: BoxShape.circle,
  ),
  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
  child: Center(
    child: Text(
      unread > 99 ? '99+' : '$unread',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);
