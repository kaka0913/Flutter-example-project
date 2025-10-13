import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work/core/di/auth_di.dart';

/// ユーザー切り替えウィジェット
class UserSwitcher extends ConsumerWidget {
  const UserSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final availableUsers = ref.watch(availableUsersProvider);

    if (currentUser == null) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton(
      tooltip: 'ユーザーを切り替え',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(currentUser.avatarUrl),
            ),
            const SizedBox(width: 8),
            Text(
              currentUser.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      itemBuilder: (context) {
        return availableUsers.map((user) {
          final isSelected = user.id == currentUser.id;
          return PopupMenuItem(
            value: user.id,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check,
                    color: Colors.blue,
                  ),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (userId) {
        ref.read(currentUserProvider.notifier).switchUser(userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${availableUsers.firstWhere((u) => u.id == userId).name}に切り替えました'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
