part of 'tables.dart';

mixin TestMixin {
  
}

enum TestEnum {
  a,
  b,
  c,
}

@AnTable(entityName: "QCatalogCheckItemEntity", model: null, mixins: [TestMixin])
class CatalogChecklistItemsTable extends ITable<QCatalogCheckItemEntity> {
  static const TAG                 = "CatalogChecklistItemsTable";

  static const TABLE_NAME          = "catalogChecklistItems";


  //----------------------------------------------------------------------------
  static const EntityColumnInfo<int> COLUMN_ID            = EntityColumnInfo(QCatalogCheckItemEntityParam.id, "id", SqliteColumnTypes.integer, dartType: int, isPrimaryKey: true);

  static const EntityColumnInfo<String> COLUMN_SERVER_ID     = EntityColumnInfo(QCatalogCheckItemEntityParam.serverId, "serverId", SqliteColumnTypes.text, dartType: String);
  static const EntityColumnInfo<String?> COLUMN_NAME          = EntityColumnInfo(QCatalogCheckItemEntityParam.name, "name", SqliteColumnTypes.text, dartType: String);
  static const EntityColumnInfo<TestEnum> COLUMN_DEPRECATED    = EntityColumnInfo(QCatalogCheckItemEntityParam.deprecated, "deprecated", SqliteColumnTypes.integer, dartType: int);
  static const EntityColumnInfo<TestEnum?> COLUMN_DEPRECATED2    = EntityColumnInfo(QCatalogCheckItemEntityParam.deprecated, "deprecated", SqliteColumnTypes.integer, dartType: int);
  static const EntityColumnInfo<double> COLUMN_AUTO          = EntityColumnInfo(QCatalogCheckItemEntityParam.auto, "auto", SqliteColumnTypes.integer, dartType: int);
  static const EntityColumnInfo<JsonObjectEx> COLUMN_OBJECT          = EntityColumnInfo(QCatalogCheckItemEntityParam.typeName, "type", SqliteColumnTypes.integer, dartType: int);
  static const EntityColumnInfo<JsonArrayEx> COLUMN_ARRAY          = EntityColumnInfo(QCatalogCheckItemEntityParam.typeName, "type", SqliteColumnTypes.integer, dartType: int);
  static const EntityColumnInfo<List<String>> COLUMN_LIST_STRING      = EntityColumnInfo(QCatalogCheckItemEntityParam.modified, "modified", SqliteColumnTypes.integer, dartType: int);
  static const EntityColumnInfo<List<int>> COLUMN_LIST_INT      = EntityColumnInfo(QCatalogCheckItemEntityParam.modified, "modified", SqliteColumnTypes.integer, dartType: int);
  static const EntityColumnInfo<List<double>> COLUMN_LIST_DOUBLE      = EntityColumnInfo(QCatalogCheckItemEntityParam.modified, "modified", SqliteColumnTypes.integer, dartType: int);
  static const EntityColumnInfo<VersionInfoEntity> COLUMN_TEST      = EntityColumnInfo(QCatalogCheckItemEntityParam.modified, "abc", SqliteColumnTypes.integer, dartType: int);
  static const EntityColumnInfo<Map<int, String>> COLUMN_TEST2      = EntityColumnInfo(QCatalogCheckItemEntityParam.modified, "abc", SqliteColumnTypes.integer, dartType: int);

  static const COLUMNS = [
    COLUMN_ID,
    COLUMN_SERVER_ID,
    COLUMN_NAME,
    COLUMN_DEPRECATED,
    COLUMN_AUTO,
    COLUMN_TYPE,
    COLUMN_MODIFIED,
  ];
  //----------------------------------------------------------------------------

  CatalogChecklistItemsTable({
    required DatabaseExecutor database,
  }) : super(
    name: TABLE_NAME,
    columns: COLUMNS_ALL,
    database: database,
  );
}

class VersionInfoEntity extends JsonSerializable {
  late final String version;
  late final String options;
  VersionInfoEntity.constructor({
    required this.version,
    required this.options,
  }) : super.constructor();
  
  VersionInfoEntity.fromJson(JsonObjectEx json) : super.fromJson(json) {
    this.version = json.getString("version")!;
    this.options = json.getString("options")!;
  }
  
  @override
  JsonObjectEx toJson() {
    return JsonObjectEx.fromMap({
      version: version,
      options: options,
    });
  }
}