import 'package:firetest/screens/fbAuth/allauthoptions.dart';
import 'package:firetest/screens/fbStorage/home.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class AllExamples extends StatelessWidget {
  const AllExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Examples')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const FbStorage();
                  },
                ));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  title: const Text("FireBase Storage"),
                  leading: Icon(
                    FluentIcons.storage_20_regular,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const AllAuthOptions();
                  },
                ));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  title: const Text("FireBase Authentication"),
                  leading: Icon(
                    FluentIcons.person_mail_20_regular,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
