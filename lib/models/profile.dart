class Profile{
  final String imagePath;
  final String name;
  final String nickName;
  final int numberFriends;
  final int numberPosts;
  final String about;

  Profile(this.imagePath, this.name, this.nickName, this.numberFriends,
      this.numberPosts, this.about);

  @override
  String toString() {
    return 'Profile{imagePath: $imagePath, name: $name, nickName: $nickName, numberFriends: $numberFriends, numberPosts: $numberPosts, about: $about}';
  }
}