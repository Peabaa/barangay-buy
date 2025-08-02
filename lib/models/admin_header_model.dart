class AdminHeaderModel {
  final String selectedBarangay;
  final String searchQuery;
  final bool isLoggedIn;
  final String? currentUserId;
  final String? currentUserEmail;

  const AdminHeaderModel({
    required this.selectedBarangay,
    this.searchQuery = '',
    this.isLoggedIn = false,
    this.currentUserId,
    this.currentUserEmail,
  });

  AdminHeaderModel copyWith({
    String? selectedBarangay,
    String? searchQuery,
    bool? isLoggedIn,
    String? currentUserId,
    String? currentUserEmail,
  }) {
    return AdminHeaderModel(
      selectedBarangay: selectedBarangay ?? this.selectedBarangay,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      currentUserId: currentUserId ?? this.currentUserId,
      currentUserEmail: currentUserEmail ?? this.currentUserEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'selectedBarangay': selectedBarangay,
      'searchQuery': searchQuery,
      'isLoggedIn': isLoggedIn,
      'currentUserId': currentUserId,
      'currentUserEmail': currentUserEmail,
    };
  }

  factory AdminHeaderModel.fromMap(Map<String, dynamic> map) {
    return AdminHeaderModel(
      selectedBarangay: map['selectedBarangay'] ?? 'Banilad',
      searchQuery: map['searchQuery'] ?? '',
      isLoggedIn: map['isLoggedIn'] ?? false,
      currentUserId: map['currentUserId'],
      currentUserEmail: map['currentUserEmail'],
    );
  }

  @override
  String toString() {
    return 'AdminHeaderModel(selectedBarangay: $selectedBarangay, searchQuery: $searchQuery, isLoggedIn: $isLoggedIn, currentUserId: $currentUserId, currentUserEmail: $currentUserEmail)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminHeaderModel &&
        other.selectedBarangay == selectedBarangay &&
        other.searchQuery == searchQuery &&
        other.isLoggedIn == isLoggedIn &&
        other.currentUserId == currentUserId &&
        other.currentUserEmail == currentUserEmail;
  }

  @override
  int get hashCode {
    return selectedBarangay.hashCode ^
        searchQuery.hashCode ^
        isLoggedIn.hashCode ^
        currentUserId.hashCode ^
        currentUserEmail.hashCode;
  }
}
