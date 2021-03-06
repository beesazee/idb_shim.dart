library idb_shim.src.client.error;

import '../../idb.dart';

// native exception won't be of this type
// the text here has been copied to match the DomException message
class DatabaseReadOnlyError extends DatabaseError {
  static String _MESSAGE = "ReadOnlyError: The transaction is read-only.";
  DatabaseReadOnlyError() : super(_MESSAGE);
}

class DatabaseStoreNotFoundError extends DatabaseError {
  static const String _MESSAGE =
      "NotFoundError: One of the specified object stores was not found.";
  static String storeMessage(var store_OR_stores) =>
      "NotFoundError: One of the specified object stores '${store_OR_stores}' was not found.";
  DatabaseStoreNotFoundError([String message = _MESSAGE]) : super(message);
}

class DatabaseIndexNotFoundError extends DatabaseError {
  static String indexMessage(var indexName) =>
      "NotFoundError: The specified index '${indexName}' was not found.";
  DatabaseIndexNotFoundError(String indexName) : super(indexMessage(indexName));
}

class DatabaseTransactionStoreNotFoundError extends DatabaseError {
  DatabaseTransactionStoreNotFoundError(String store)
      : super("NotFoundError: store '${store}' not found in transaction.");
}

class DatabaseNoKeyError extends DatabaseError {
  static String _MESSAGE =
      "DataError: The data provided does not meet requirements. No key or key range specified.";
  DatabaseNoKeyError() : super(_MESSAGE);
}

class DatabaseInvalidKeyError extends DatabaseError {
  DatabaseInvalidKeyError(key)
      : super(
            "DataError: The data provided does not meet requirements. The parameter '${key}' is not a valid key.");
}
