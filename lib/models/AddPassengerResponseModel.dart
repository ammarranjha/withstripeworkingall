
class AddPassengerResponseModel {
  final id;
  final firstname;
  final lastname;
  final profileImageUrl;

  AddPassengerResponseModel({this.id, this.firstname, this.lastname, this.profileImageUrl});

  factory AddPassengerResponseModel.fromJson (Map<String, dynamic> data) {
    return AddPassengerResponseModel(
      id: data['_id'],
      firstname: data['firstname'],
      lastname: data['lastname'],
      profileImageUrl: data['profile_image_url']
    );
  }
} 