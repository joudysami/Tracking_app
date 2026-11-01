import 'package:flutter/material.dart';

class OrderPartyCard extends StatelessWidget {
  final String title;
  final String address;
  final bool isStore;

  const OrderPartyCard({
    super.key,
    required this.title,
    required this.address,
    this.isStore = false,
  });

  static const Color _pink = Color(0xFFD51D72);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          _avatar(),
          const SizedBox(width: 12),
          Expanded(child: _details()),
        ],
      ),
    );
  }

  Widget _avatar() {
    return CircleAvatar(
      radius: 22,
      backgroundColor: isStore ? _pink : const Color(0xFFE9D6C0),
      child: Icon(
        isStore ? Icons.local_florist : Icons.person,
        color: isStore ? Colors.white : Colors.brown,
        size: 22,
      ),
    );
  }

  Widget _details() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) _title(),
        if (title.isNotEmpty) const SizedBox(height: 4),
        _addressLine(),
      ],
    );
  }

  Widget _title() {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _addressLine() {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined, size: 14, color: Colors.black54),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
          ),
        ),
      ],
    );
  }
}
