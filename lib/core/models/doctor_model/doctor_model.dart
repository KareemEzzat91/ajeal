class Doctor {
  String ?doctorName;
  String ?doctorId;
  String ?doctorPhone;
  int ?lastChildId;
  String ?lastChildName;
  String ?lastSessionWith;
  String ?lastChattedWith;
  String ?taskAddedFor;

  Doctor(
      {this.doctorName,
        this.doctorId,
        this.doctorPhone,
        this.lastChildId,
        this.lastChildName,
        this.lastSessionWith,
        this.lastChattedWith,
        this.taskAddedFor});

  Doctor.fromJson(Map<String, dynamic> json) {
    doctorName = json['Doctor_Name'];
    doctorId = json['Doctor_id'];
    doctorPhone = json['Doctor_phone'];
    lastChildId = json['lastChildId'];
    lastChildName = json['lastChildName'];
    lastSessionWith = json['lastSessionWith'];
    lastChattedWith = json['lastChattedWith'];
    taskAddedFor = json['taskAddedFor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Doctor_Name'] = doctorName;
    data['Doctor_id'] = doctorId;
    data['Doctor_phone'] = doctorPhone;
    data['lastChildId'] = lastChildId;
    data['lastChildName'] = lastChildName;
    data['lastSessionWith'] =  lastSessionWith;
    data['lastChattedWith'] =  lastChattedWith;
    data['taskAddedFor'] =taskAddedFor;
    return data;
  }
}
