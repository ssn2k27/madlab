// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// void main() {
//   runApp(MoodApp());
// }
//
// class MoodApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Mood Tracker",
//       theme: ThemeData(fontFamily: 'Poppins'),
//       home: MoodHome(),
//     );
//   }
// }
//
// class MoodHome extends StatefulWidget {
//   @override
//   _MoodHomeState createState() => _MoodHomeState();
// }
//
// class _MoodHomeState extends State<MoodHome> {
//   Map<String, String> moodData = {}; // date -> mood
//
//   final moods = {
//     "Happy": "😊",
//     "Sad": "😢",
//     "Angry": "😡",
//     "Relaxed": "😌",
//     "Excited": "🤩",
//   };
//
//   Color getMoodColor(String mood) {
//     switch (mood) {
//       case "Happy":
//         return Colors.yellow.shade300;
//       case "Sad":
//         return Colors.blue.shade300;
//       case "Angry":
//         return Colors.red.shade300;
//       case "Relaxed":
//         return Colors.green.shade300;
//       case "Excited":
//         return Colors.purple.shade300;
//       default:
//         return Colors.grey.shade200;
//     }
//   }
//
//   String todayKey() {
//     return DateFormat('yyyy-MM-dd').format(DateTime.now());
//   }
//
//   void setMood(String mood) {
//     setState(() {
//       moodData[todayKey()] = mood;
//     });
//   }
//
//   /// WEEK DATA
//   List<String> getLast7Days() {
//     return List.generate(7, (i) {
//       return DateFormat('yyyy-MM-dd')
//           .format(DateTime.now().subtract(Duration(days: i)));
//     });
//   }
//
//   /// MOST FREQUENT MOOD
//   String getMostFrequentMood() {
//     Map<String, int> count = {};
//
//     for (var day in getLast7Days()) {
//       if (moodData.containsKey(day)) {
//         String mood = moodData[day]!;
//         count[mood] = (count[mood] ?? 0) + 1;
//       }
//     }
//
//     String topMood = "None";
//     int max = 0;
//
//     count.forEach((key, value) {
//       if (value > max) {
//         max = value;
//         topMood = key;
//       }
//     });
//
//     return topMood;
//   }
//
//   /// WEEK ANALYSIS
//   Map<String, int> getWeeklyStats() {
//     Map<String, int> stats = {};
//
//     for (var mood in moods.keys) {
//       stats[mood] = 0;
//     }
//
//     for (var day in getLast7Days()) {
//       if (moodData.containsKey(day)) {
//         stats[moodData[day]!] =
//             (stats[moodData[day]!] ?? 0) + 1;
//       }
//     }
//
//     return stats;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String todayMood = moodData[todayKey()] ?? "";
//
//     return Scaffold(
//       backgroundColor:
//       todayMood.isEmpty ? Colors.white : getMoodColor(todayMood),
//       appBar: AppBar(title: Text("Mood Tracker")),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// TODAY
//             Text(
//               "How are you feeling today?",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//
//             SizedBox(height: 15),
//
//             /// MOOD BUTTONS
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: moods.entries.map((entry) {
//                 return GestureDetector(
//                   onTap: () => setMood(entry.key),
//                   child: Column(
//                     children: [
//                       Text(entry.value, style: TextStyle(fontSize: 30)),
//                       Text(entry.key),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//
//             SizedBox(height: 30),
//
//             /// WEEK ANALYSIS
//             Text(
//               "Weekly Analysis",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//
//             SizedBox(height: 10),
//
//             ...getWeeklyStats().entries.map((e) {
//               return Padding(
//                 padding: EdgeInsets.symmetric(vertical: 4),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("${moods[e.key]} ${e.key}"),
//                     Text("${e.value} days"),
//                   ],
//                 ),
//               );
//             }),
//
//             SizedBox(height: 20),
//
//             /// MOST FREQUENT
//             Text(
//               "Most Frequent Mood:",
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 5),
//             Text(
//               "${getMostFrequentMood()} ${moods[getMostFrequentMood()] ?? ""}",
//               style: TextStyle(
//                   fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//
//             Spacer(),
//
//             /// MINI HISTORY (LAST 7 DAYS)
//             Text(
//               "Last 7 Days",
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 10),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: getLast7Days().map((day) {
//                 String? mood = moodData[day];
//                 return Column(
//                   children: [
//                     Text(DateFormat('E').format(DateTime.parse(day))),
//                     Text(
//                       mood != null ? moods[mood]! : "—",
//                       style: TextStyle(fontSize: 22),
//                     )
//                   ],
//                 );
//               }).toList(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }