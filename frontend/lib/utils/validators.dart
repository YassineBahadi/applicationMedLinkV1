class Validators {
  static String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire';
    }
    return null;
  }

  static String? numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire';
    }
    if (int.tryParse(value) == null) {
      return 'Veuillez entrer un nombre valide';
    }
    return null;
  }
}