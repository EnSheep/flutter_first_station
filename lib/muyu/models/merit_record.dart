class MeritRecord {
  final String id; // 记录的唯一标识
  final int timestamp; // 记录的时间戳
  final int value; // 功德数
  final String image; // 图片资源
  final String audio; // 音效名称

  MeritRecord(this.id, this.timestamp, this.value, this.image, this.audio);
}
