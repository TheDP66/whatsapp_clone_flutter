import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/feature/contact/repository/contacts_repository.dart';

final contactsControllerProvider = FutureProvider(
  (ref) {
    final contractRepository = ref.watch(contactsRepositoryProvider);

    return contractRepository.getAllContacts();
  },
);
