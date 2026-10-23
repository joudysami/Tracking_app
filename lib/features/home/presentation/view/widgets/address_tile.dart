
import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_color.dart';

class AddressTile extends StatelessWidget {
  final String title;
  final String address;
  final bool isStore;

  const AddressTile({
    super.key,
    required this.title,
    required this.address,
    this.isStore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                isStore ? context.colors.pink : context.colors.white,
            child: isStore
                ? const Icon(
                    Icons.local_florist,
                    color: Colors.white,
                    size: 20,
                  )
                : const Icon(
                    Icons.person,
                    color: Colors.brown,
                    size: 20,
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                     Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: context.colors.black,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: context.colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
