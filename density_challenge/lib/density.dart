class DensityData{
final String name;
final int currentCount;
final String id;

DensityData({this.name, this.currentCount, this.id});

factory DensityData.fromJson(Map<String, dynamic> json) {
    return DensityData(
      name: json['name'],
      currentCount: json['current_count'],
      id: json['id']
    );
  }



}