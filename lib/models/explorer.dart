class Explorer {
  final String name;
  final String track;
  final int year;
  final List<String> skills;
  final String? bio;

  Explorer({
    required this.name,
    required this.track,
    required this.year,
    required this.skills,
    this.bio,
  });

  String shortProfile() => '$name - $track (Year $year)';

  List<String> topSkills(int n) => skills.take(n).toList();
}
