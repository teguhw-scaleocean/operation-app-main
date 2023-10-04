class HomeArgument {
  final bool? isSignIn;
  final int companyId;
  final String emailAddress;

  HomeArgument(
      {this.isSignIn = false,
      required this.companyId,
      required this.emailAddress});
}
