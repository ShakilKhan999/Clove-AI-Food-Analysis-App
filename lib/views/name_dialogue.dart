// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AppNameDialog extends StatefulWidget {
//   const AppNameDialog({Key? key}) : super(key: key);
//
//   @override
//   State<AppNameDialog> createState() => _AppNameDialogState();
// }
//
// class _AppNameDialogState extends State<AppNameDialog> {
//   final TextEditingController _controller = TextEditingController();
//    SharedPreferences? _prefs;
//   static const String _appNameKey = 'app_name';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSavedName();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () => showAppNameDialog(context),
//       style: ElevatedButton.styleFrom(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: const EdgeInsets.symmetric(
//           horizontal: 24,
//           vertical: 12,
//         ),
//       ),
//       child: const Text('Configure App Name'),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }