bool emailError(String email) {
  final RegExp regex = RegExp(
    r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$",
  );
  return regex.hasMatch(email);
}

String? emailValid(String email) {
  if (email.isEmpty) {
    return 'Campo obrigatório';
  } else if (!emailError(email)) {
    return 'Email invalido';
  }
  return null;
}

String? nameValid(String name) {
  if (name.isEmpty) {
    return 'Campo obrigatório';
  } else if (name.trim().split(' ').isEmpty) {
    return 'Preencha seu Nome completo';
  }
  return null;
}

String? passValid(String pass) {
  if (pass.isEmpty) {
    return 'Campo obrigatório';
  } else if (pass.length < 6) {
    return 'Minimo de 6 caracteres ';
  }
  return null;
}

String? descValid(String description) {
  if (description.length > 151) {
    return 'Descrição muito longo, Maximo 150 caracteres.';
  }
  return null;
}

String? nameMedicineValid(String name) {
  if (name.isEmpty) {
    return 'Insira o nome';
  } else if (name.length > 18) {
    return 'Nome muito logo, Maximo 18 caracteres';
  }
  return null;
}
