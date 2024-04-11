import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/models/message_model.dart';

class ShowDateCard extends StatelessWidget {
  const ShowDateCard({
    Key? key,
    required this.date,
  }) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: context.theme.receiverChatCardBg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        DateFormat.yMMMd().format(date),
      ),
    );
  }
}
