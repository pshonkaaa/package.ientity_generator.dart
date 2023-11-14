part of 'tables.dart';

mixin TestMixin {
  
}

enum TestEnum {
  a,
  b,
  c,
}

@TableAnnotation(entityName: "QCatalogCheckItemEntity", model: null, mixins: [TestMixin])
class CatalogChecklistItemsTable extends BaseTable {
  static const TAG                 = "CatalogChecklistItemsTable";

  static const TABLE_NAME          = "catalogChecklistItems";


  //----------------------------------------------------------------------------
  static const EntityColumnInfo<int> COLUMN_ID                      = EntityColumnInfo("id", SqliteColumnTypes.integer, isPrimaryKey: true);

  static const EntityColumnInfo<String>       COLUMN_STRING         = EntityColumnInfo("string", SqliteColumnTypes.text);
  static const EntityColumnInfo<String?>      COLUMN_NULL_STRING    = EntityColumnInfo("stringWithNull", SqliteColumnTypes.text);

  static const EntityColumnInfo<TestEnum>     COLUMN_ENUMA          = EntityColumnInfo("enum", SqliteColumnTypes.integer);
  static const EntityColumnInfo<TestEnum?>    COLUMN_ENUM_NULLABLE  = EntityColumnInfo("enum?", SqliteColumnTypes.integer);

  static const EntityColumnInfo<double>       COLUMN_DOUBLEA        = EntityColumnInfo("balance", SqliteColumnTypes.real);
  static const EntityColumnInfo<double?>      COLUMN_DOUBLE_NULL    = EntityColumnInfo("balance?", SqliteColumnTypes.real);

  static const EntityColumnInfo<JsonObjectEx>   COLUMN_OBJECT         = EntityColumnInfo("jo", SqliteColumnTypes.text);
  static const EntityColumnInfo<JsonObjectEx?>  COLUMN_OBJECT_NULL    = EntityColumnInfo("jo?", SqliteColumnTypes.text);

  static const EntityColumnInfo<JsonArrayEx>    COLUMN_ARRAY          = EntityColumnInfo("ja", SqliteColumnTypes.text);
  static const EntityColumnInfo<JsonArrayEx?>   COLUMN_ARRAY_NULL     = EntityColumnInfo("ja?", SqliteColumnTypes.text);

  static const EntityColumnInfo<List<String>>   COLUMN_LIST_STRING    = EntityColumnInfo("nicknames", SqliteColumnTypes.text);

  static const EntityColumnInfo<List<int>>      COLUMN_LIST_INT       = EntityColumnInfo("audio_ids", SqliteColumnTypes.text);

  static const EntityColumnInfo<List<double>>   COLUMN_LIST_DOUBLE    = EntityColumnInfo("anymore", SqliteColumnTypes.text);

  static const EntityColumnInfo<VersionInfoEntity>  COLUMN_SERIALIZABLE   = EntityColumnInfo("version", SqliteColumnTypes.text);
  
  static const EntityColumnInfo<Map<int, String>>   COLUMN_MAP        = EntityColumnInfo("dictionary", SqliteColumnTypes.text);


  static const COLUMNS = QCatalogCheckItemEntity.COLUMNS; 
  //----------------------------------------------------------------------------

  CatalogChecklistItemsTable(
    
  ) : super(
    name: TABLE_NAME,
    columns: COLUMNS,
  );
}



class VersionInfoEntity extends JsonSerializable {
  late final String version;
  late final String options;
  VersionInfoEntity.constructor({
    required this.version,
    required this.options,
  }) : super.create();
  
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