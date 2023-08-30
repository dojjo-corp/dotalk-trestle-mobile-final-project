import 'package:dotalk/global/chat.dart';
import 'package:flutter/material.dart';

class IssuesCard extends StatelessWidget {
  const IssuesCard({
    super.key,
    required this.index,
    required this.issueId,
    required this.lastText,
    required this.lastTime,
    required this.agentName,
    required this.lastTextSource,
    required this.category,
  });
  final String category;
  final int index;
  final String issueId;
  final String? lastText;
  final String? lastTime;
  final String? agentName;
  final String lastTextSource;

  @override
  Widget build(BuildContext context) {
    // final allAgents = Provider.of<AgentProvider>(contexYah t).allAgents;
    final tempNames = agentName!.split(' ');
    final intials = '${tempNames[0][0]}.${tempNames[1][0]}';
    final subtitleText = lastText != null
        ? '${lastTextSource.split(' ')[0]}: $lastText'
        : ''; // always use only one, if multiiple names are given
    final categoryToUse = category.split(' ')[0];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatScreen(issueId: issueId)));
        },
        child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey[100],
              child: Text(intials),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    agentName!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                  categoryToUse,
                  style: const TextStyle(color: Colors.grey),
                ))
              ],
            ),
            subtitle: Text(
              subtitleText,
              style: TextStyle(color: Colors.grey[700]),
              maxLines: 1,
            ),
            trailing: Text(lastTime ?? ''),
            tileColor: Colors.blueGrey[200]),
      ),
    );
  }
}
