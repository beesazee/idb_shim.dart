library idb_shim_websql;

import 'dart:async';
import 'dart:convert';

import 'package:idb_shim/src/common/common_factory.dart';
import 'package:idb_shim/src/common/common_meta.dart';
import 'package:idb_shim/src/common/common_value.dart';
import 'package:idb_shim/src/common/common_transaction.dart';
import 'package:idb_shim/src/common/common_database.dart';
import 'package:idb_shim/src/websql/websql_client_constants.dart';
import 'package:idb_shim/src/websql/websql_utils.dart';
import 'package:idb_shim/src/websql/websql_wrapper.dart';

import 'idb_client.dart';
import 'src/common/common_validation.dart';
import "src/utils/core_imports.dart";

part 'src/websql/websql_cursor.dart';
part 'src/websql/websql_database.dart';
part 'src/websql/websql_error.dart';
part 'src/websql/websql_global_store.dart';
part 'src/websql/websql_index.dart';
part 'src/websql/websql_object_store.dart';
part 'src/websql/websql_query.dart';
part 'src/websql/websql_transaction.dart';

IdbWebSqlFactory get idbWebSqlFactory => new IdbWebSqlFactory();

class IdbWebSqlFactory extends IdbFactoryBase {
  @override
  bool get persistent => true;

  // global store
  _WebSqlGlobalStore _globalStore = new _WebSqlGlobalStore();

  static IdbWebSqlFactory _instance;

  IdbWebSqlFactory._();

  @override
  String get name => idbFactoryWebSql;

  factory IdbWebSqlFactory() {
    if (_instance == null) {
      _instance = new IdbWebSqlFactory._();
    }
    return _instance;
  }

  set globalStoreDbName(String dbName) {
    _globalStore.dbName = dbName;
  }

  @override
  Future<Database> open(String dbName,
      {int version,
      OnUpgradeNeededFunction onUpgradeNeeded,
      OnBlockedFunction onBlocked}) {
    // check params
    if (((version != null) || (onUpgradeNeeded != null)) &&
        ((version == null) || (onUpgradeNeeded == null))) {
      return new Future.error(new ArgumentError(
          'version and onUpgradeNeeded must be specified together'));
    }
    if (version == 0) {
      return new Future.error(new ArgumentError('version cannot be 0'));
    } else if (version == null) {
      version = 1;
    }

    if (dbName == null) {
      return new Future.error(new ArgumentError('dbName cannot be null'));
    }

    // add the db name and remove it if it fails
    return _globalStore.addDatabaseName(dbName).then((_) {
      _WebSqlDatabase database = new _WebSqlDatabase(dbName);
      return database.open(version, onUpgradeNeeded).then((_) {
        return database;
      }, onError: (e) {
        _globalStore.deleteDatabaseName(dbName);
        throw e;
      });
    });
  }

  @override
  Future<IdbFactory> deleteDatabase(String dbName,
      {OnBlockedFunction onBlocked}) {
    if (dbName == null) {
      return new Future.error(new ArgumentError('dbName cannot be null'));
    }
    // remove the db name and add it back if it fails
    return _globalStore.deleteDatabaseName(dbName).then((_) {
      _WebSqlDatabase database = new _WebSqlDatabase(dbName);
      return database._delete().then((_) {
        return this;
      }, onError: (e) {
        _globalStore.addDatabaseName(dbName);
        throw e;
      });
    });
  }

  @override
  bool get supportsDatabaseNames {
    return true;
  }

  @override
  Future<List<String>> getDatabaseNames() {
    return _globalStore.getDatabaseNames();
  }

  /**
   * Check if WebSQL is supported on this platform
   */
  static bool get supported {
    return SqlDatabase.supported;
  }
}
