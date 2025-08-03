class SelectBarangayModel {
  String? selectedBarangay;
  bool isLoading;
  final bool isConfirm;
  List<String> availableBarangays;

  SelectBarangayModel({
    this.selectedBarangay,
    this.isLoading = false,
    this.isConfirm = true,
    List<String>? availableBarangays,
  }) : availableBarangays = availableBarangays ?? [
    'Banilad',
    'Bulacao',
    'Day-as',
    'Ermita',
    'Guadalupe',
    'Inayawan',
    'Labangon',
    'Lahug',
    'Pari-an',
    'Pasil'
  ];

  SelectBarangayModel copyWith({
    String? selectedBarangay,
    bool? isLoading,
    bool? isConfirm,
    List<String>? availableBarangays,
  }) {
    return SelectBarangayModel(
      selectedBarangay: selectedBarangay ?? this.selectedBarangay,
      isLoading: isLoading ?? this.isLoading,
      isConfirm: isConfirm ?? this.isConfirm,
      availableBarangays: availableBarangays ?? this.availableBarangays,
    );
  }

  bool get canConfirm => selectedBarangay != null && !isLoading;
}
