// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables.dart';

// **************************************************************************
// ExtensionGenerator
// **************************************************************************

// ignore_for_file: unused_local_variable, dead_code
bool _isEquals<T>(T a, T b) {
  if (T == List) return _listEquals(a as List, b as List);
  if (T == Map) return _mapEquals(a as Map, b as Map);
  return a == b;
}

/// from 'package:flutter/foundation.dart'
bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (int index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) {
      return false;
    }
  }
  return true;
}

/// from 'package:flutter/foundation.dart'
bool _mapEquals<T, U>(Map<T, U>? a, Map<T, U>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (final T key in a.keys) {
    if (!b.containsKey(key) || b[key] != a[key]) {
      return false;
    }
  }
  return true;
}

T _transform<T>(EntityColumnInfo<T> column, T value) {
  if (column.transformer == null) return value;
  return column.transformer!(value);
}

/*
export "generated.g.dart" show 
	QCatalogCheckItemEntity;
*/
class QCatalogCheckItemEntity extends BaseEntity {
  static const TAG = "QCatalogCheckItemEntity";

  static const ID = CatalogChecklistItemsTable.COLUMN_ID;
  static const STRING = CatalogChecklistItemsTable.COLUMN_STRING;
  static const NULL_STRING = CatalogChecklistItemsTable.COLUMN_NULL_STRING;
  static const ENUMA = CatalogChecklistItemsTable.COLUMN_ENUMA;
  static const ENUM_NULLABLE = CatalogChecklistItemsTable.COLUMN_ENUM_NULLABLE;
  static const DOUBLEA = CatalogChecklistItemsTable.COLUMN_DOUBLEA;
  static const DOUBLE_NULL = CatalogChecklistItemsTable.COLUMN_DOUBLE_NULL;
  static const OBJECT = CatalogChecklistItemsTable.COLUMN_OBJECT;
  static const OBJECT_NULL = CatalogChecklistItemsTable.COLUMN_OBJECT_NULL;
  static const ARRAY = CatalogChecklistItemsTable.COLUMN_ARRAY;
  static const ARRAY_NULL = CatalogChecklistItemsTable.COLUMN_ARRAY_NULL;
  static const LIST_STRING = CatalogChecklistItemsTable.COLUMN_LIST_STRING;
  static const LIST_INT = CatalogChecklistItemsTable.COLUMN_LIST_INT;
  static const LIST_DOUBLE = CatalogChecklistItemsTable.COLUMN_LIST_DOUBLE;
  static const SERIALIZABLE = CatalogChecklistItemsTable.COLUMN_SERIALIZABLE;
  static const MAP = CatalogChecklistItemsTable.COLUMN_MAP;

  static const COLUMNS = [
    ID,
    STRING,
    NULL_STRING,
    ENUMA,
    ENUM_NULLABLE,
    DOUBLEA,
    DOUBLE_NULL,
    OBJECT,
    OBJECT_NULL,
    ARRAY,
    ARRAY_NULL,
    LIST_STRING,
    LIST_INT,
    LIST_DOUBLE,
    SERIALIZABLE,
    MAP,
  ];

  QCatalogCheckItemEntity.create({
    required this.string,
    required this.nullString,
    required this.enuma,
    required this.enumNullable,
    required this.doublea,
    required this.doubleNull,
    required this.object,
    required this.objectNull,
    required this.array,
    required this.arrayNull,
    required this.listString,
    required this.listInt,
    required this.listDouble,
    required this.serializable,
    required this.map,
  }) : super.create() {
    id = 0;
    setEdited(true, changed: COLUMNS);
  }

  QCatalogCheckItemEntity.fromTable(Map<String, dynamic> json)
      : super.fromTable(json) {
// checking if column not exists :|
    for (final column in COLUMNS) {
      if (!json.containsKey(column.name)) {
        throw 'Key not exists; key = ${column.name}';
      }
    }

    id = ValueParser.parseInteger(json[ID.name]);
    string = ValueParser.parseString(json[STRING.name]);
    nullString = json[NULL_STRING.name] != null
        ? ValueParser.parseString(json[NULL_STRING.name])
        : null;
    enuma = TestEnum.values[ValueParser.parseInteger(json[ENUMA.name])];
    enumNullable = json[ENUM_NULLABLE.name] != null
        ? TestEnum.values[ValueParser.parseInteger(json[ENUM_NULLABLE.name])]
        : null;
    doublea = ValueParser.parseDouble(json[DOUBLEA.name]);
    doubleNull = json[DOUBLE_NULL.name] != null
        ? ValueParser.parseDouble(json[DOUBLE_NULL.name])
        : null;
    object = ValueParser.parseJsonObject(json[OBJECT.name]);
    objectNull = json[OBJECT_NULL.name] != null
        ? ValueParser.parseJsonObject(json[OBJECT_NULL.name])
        : null;
    array = ValueParser.parseJsonArray(json[ARRAY.name]);
    arrayNull = json[ARRAY_NULL.name] != null
        ? ValueParser.parseJsonArray(json[ARRAY_NULL.name])
        : null;
    listString = ValueParser.parseArray<String>(json[LIST_STRING.name]);
    listInt = ValueParser.parseArray<int>(json[LIST_INT.name]);
    listDouble = ValueParser.parseArray<double>(json[LIST_DOUBLE.name]);
    serializable = VersionInfoEntity.fromJson(
        ValueParser.parseJsonObject(json[SERIALIZABLE.name]));
    map = BaseEntity.jsonDecode<int, String>(
        ValueParser.parseString(json[MAP.name]))!;
  }

  late int id;
  late String string;
  late String? nullString;
  late TestEnum enuma;
  late TestEnum? enumNullable;
  late double doublea;
  late double? doubleNull;
  late JsonObjectEx object;
  late JsonObjectEx? objectNull;
  late JsonArrayEx<dynamic> array;
  late JsonArrayEx<dynamic>? arrayNull;
  late List<String> listString;
  late List<int> listInt;
  late List<double> listDouble;
  late VersionInfoEntity serializable;
  late Map<int, String> map;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool isIdentical(
    covariant QCatalogCheckItemEntity m, {
    List<EntityColumnInfo> include = const [],
    List<EntityColumnInfo> exclude = const [],
    List<ChangedColumn>? differences,
  }) {
    final src = this, dst = m;
    final List<EntityColumnInfo> changedList = [];
    bool changed = false;

    final list = BaseEntity.makeParamsList(COLUMNS, include, exclude);
    {
      bool flag = false;
//------------------------------------------------------------------------
      flag = list.remove(ID);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(ID);
        differences?.add(ChangedColumn(ID, dst.id, src.id));
        dst.id = src.id;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(STRING);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(STRING);
        differences?.add(ChangedColumn(STRING, dst.string, src.string));
        dst.string = src.string;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(NULL_STRING);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(NULL_STRING);
        differences
            ?.add(ChangedColumn(NULL_STRING, dst.nullString, src.nullString));
        dst.nullString = src.nullString;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(ENUMA);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(ENUMA);
        differences?.add(ChangedColumn(ENUMA, dst.enuma, src.enuma));
        dst.enuma = src.enuma;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(ENUM_NULLABLE);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(ENUM_NULLABLE);
        differences?.add(
            ChangedColumn(ENUM_NULLABLE, dst.enumNullable, src.enumNullable));
        dst.enumNullable = src.enumNullable;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(DOUBLEA);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(DOUBLEA);
        differences?.add(ChangedColumn(DOUBLEA, dst.doublea, src.doublea));
        dst.doublea = src.doublea;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(DOUBLE_NULL);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(DOUBLE_NULL);
        differences
            ?.add(ChangedColumn(DOUBLE_NULL, dst.doubleNull, src.doubleNull));
        dst.doubleNull = src.doubleNull;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(OBJECT);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(OBJECT);
        differences?.add(ChangedColumn(OBJECT, dst.object, src.object));
        dst.object = src.object;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(OBJECT_NULL);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(OBJECT_NULL);
        differences
            ?.add(ChangedColumn(OBJECT_NULL, dst.objectNull, src.objectNull));
        dst.objectNull = src.objectNull;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(ARRAY);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(ARRAY);
        differences?.add(ChangedColumn(ARRAY, dst.array, src.array));
        dst.array = src.array;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(ARRAY_NULL);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(ARRAY_NULL);
        differences
            ?.add(ChangedColumn(ARRAY_NULL, dst.arrayNull, src.arrayNull));
        dst.arrayNull = src.arrayNull;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(LIST_STRING);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(LIST_STRING);
        differences
            ?.add(ChangedColumn(LIST_STRING, dst.listString, src.listString));
        dst.listString = src.listString;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(LIST_INT);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(LIST_INT);
        differences?.add(ChangedColumn(LIST_INT, dst.listInt, src.listInt));
        dst.listInt = src.listInt;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(LIST_DOUBLE);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(LIST_DOUBLE);
        differences
            ?.add(ChangedColumn(LIST_DOUBLE, dst.listDouble, src.listDouble));
        dst.listDouble = src.listDouble;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(SERIALIZABLE);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(SERIALIZABLE);
        differences?.add(
            ChangedColumn(SERIALIZABLE, dst.serializable, src.serializable));
        dst.serializable = src.serializable;
        changed = true;
      }
//------------------------------------------------------------------------
      flag = list.remove(MAP);
      if (flag && !_isEquals(dst.id, src.id)) {
        changedList.add(MAP);
        differences?.add(ChangedColumn(MAP, dst.map, src.map));
        dst.map = src.map;
        changed = true;
      }
    }
    assert(
        list.isEmpty, "unknown columns = ${list.map((e) => e.name).toList()}");
    return changed;
  }

  @override
  bool copyTo(
    covariant QCatalogCheckItemEntity m, {
    List<EntityColumnInfo> include = const [],
    List<EntityColumnInfo> exclude = const [],
    List<ChangedColumn>? differences,
  }) {
    throw UnimplementedError();
  }

  @override
  bool copyChangesTo(
    covariant QCatalogCheckItemEntity m, {
    List<EntityColumnInfo> include = const [],
    List<EntityColumnInfo> exclude = const [],
    List<ChangedColumn>? differences,
  }) {
    final src = this, dst = m;

    differences ??= [];

    final identical = isIdentical(
      dst,
      include: include,
      exclude: exclude,
      differences: differences,
    );

    if (!identical) return false;

    final list = differences.map((e) => e.column).toList();

    {
      bool flag = false;
//------------------------------------------------------------------------
      flag = list.remove(ID);
      if (flag && dst.id != src.id) {
        dst.id = src.id;
      }
//------------------------------------------------------------------------
      flag = list.remove(STRING);
      if (flag && dst.id != src.id) {
        dst.string = src.string;
      }
//------------------------------------------------------------------------
      flag = list.remove(NULL_STRING);
      if (flag && dst.id != src.id) {
        dst.nullString = src.nullString;
      }
//------------------------------------------------------------------------
      flag = list.remove(ENUMA);
      if (flag && dst.id != src.id) {
        dst.enuma = src.enuma;
      }
//------------------------------------------------------------------------
      flag = list.remove(ENUM_NULLABLE);
      if (flag && dst.id != src.id) {
        dst.enumNullable = src.enumNullable;
      }
//------------------------------------------------------------------------
      flag = list.remove(DOUBLEA);
      if (flag && dst.id != src.id) {
        dst.doublea = src.doublea;
      }
//------------------------------------------------------------------------
      flag = list.remove(DOUBLE_NULL);
      if (flag && dst.id != src.id) {
        dst.doubleNull = src.doubleNull;
      }
//------------------------------------------------------------------------
      flag = list.remove(OBJECT);
      if (flag && dst.id != src.id) {
        dst.object = src.object;
      }
//------------------------------------------------------------------------
      flag = list.remove(OBJECT_NULL);
      if (flag && dst.id != src.id) {
        dst.objectNull = src.objectNull;
      }
//------------------------------------------------------------------------
      flag = list.remove(ARRAY);
      if (flag && dst.id != src.id) {
        dst.array = src.array;
      }
//------------------------------------------------------------------------
      flag = list.remove(ARRAY_NULL);
      if (flag && dst.id != src.id) {
        dst.arrayNull = src.arrayNull;
      }
//------------------------------------------------------------------------
      flag = list.remove(LIST_STRING);
      if (flag && dst.id != src.id) {
        dst.listString = src.listString;
      }
//------------------------------------------------------------------------
      flag = list.remove(LIST_INT);
      if (flag && dst.id != src.id) {
        dst.listInt = src.listInt;
      }
//------------------------------------------------------------------------
      flag = list.remove(LIST_DOUBLE);
      if (flag && dst.id != src.id) {
        dst.listDouble = src.listDouble;
      }
//------------------------------------------------------------------------
      flag = list.remove(SERIALIZABLE);
      if (flag && dst.id != src.id) {
        dst.serializable = src.serializable;
      }
//------------------------------------------------------------------------
      flag = list.remove(MAP);
      if (flag && dst.id != src.id) {
        dst.map = src.map;
      }
    }
    assert(
        list.isEmpty, "unknown columns = ${list.map((e) => e.name).toList()}");
    m.setEdited(true, changed: differences.map((e) => e.column));
    return true;
  }

  @override
  RowInfo toTable({
    required ERequestType requestType,
    List<EntityColumnInfo> include = const [],
    List<EntityColumnInfo> exclude = const [],
  }) {
    final _list = BaseEntity.makeParamsList(COLUMNS, include, exclude);
    final _map = {
      if (_list.remove(ID) && requestType != ERequestType.insert)
        ID: _transform(ID, id),
      if (_list.remove(STRING)) STRING: _transform(STRING, string),
      if (_list.remove(NULL_STRING))
        NULL_STRING: _transform(NULL_STRING, nullString),
      if (_list.remove(ENUMA)) ENUMA: _transform(ENUMA, enuma.index),
      if (_list.remove(ENUM_NULLABLE))
        ENUM_NULLABLE: _transform(ENUM_NULLABLE, enumNullable?.index),
      if (_list.remove(DOUBLEA)) DOUBLEA: _transform(DOUBLEA, doublea),
      if (_list.remove(DOUBLE_NULL))
        DOUBLE_NULL: _transform(DOUBLE_NULL, doubleNull),
      if (_list.remove(OBJECT)) OBJECT: _transform(OBJECT, object.stringify()),
      if (_list.remove(OBJECT_NULL))
        OBJECT_NULL: _transform(OBJECT_NULL, objectNull?.stringify()),
      if (_list.remove(ARRAY)) ARRAY: _transform(ARRAY, array.stringify()),
      if (_list.remove(ARRAY_NULL))
        ARRAY_NULL: _transform(ARRAY_NULL, arrayNull?.stringify()),
      if (_list.remove(LIST_STRING))
        LIST_STRING: _transform(
            LIST_STRING, JsonArrayEx.fromList(listString).stringify()),
      if (_list.remove(LIST_INT))
        LIST_INT:
            _transform(LIST_INT, JsonArrayEx.fromList(listInt).stringify()),
      if (_list.remove(LIST_DOUBLE))
        LIST_DOUBLE: _transform(
            LIST_DOUBLE, JsonArrayEx.fromList(listDouble).stringify()),
      if (_list.remove(SERIALIZABLE))
        SERIALIZABLE:
            _transform(SERIALIZABLE, serializable.toJson().stringify()),
      if (_list.remove(MAP)) MAP: _transform(MAP, BaseEntity.jsonEncode(map)),
    };

    assert(_list.isEmpty,
        "unknown columns = ${_list.map((e) => e.name).toList()}");
    return RowInfo(_map);
  }
}
