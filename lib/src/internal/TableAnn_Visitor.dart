import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:ientity/library.dart';
import 'package:json_annotation_ex/library.dart';
import 'package:json_ex/library.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/type_checker.dart';
import 'package:foundation/library.dart';

class TableAnn_Visitor extends SimpleElementVisitor<void> {
  static const TypeChecker ANNOTATION_TABLE = TypeChecker.fromRuntime(TableAnnotation);
  static const TypeChecker ANNOTATION_TABLE_COLUMN = TypeChecker.fromRuntime(TableColumnAnnotation);
  static const TypeChecker CLASS_ITABLE = TypeChecker.fromRuntime(BaseTable);
  static const TypeChecker CLASS_ENTITY_COLUMN_INFO = TypeChecker.fromRuntime(EntityColumnInfo);
  static const TypeChecker CLASS_JSON_SERIALIZABLE = TypeChecker.fromRuntime(JsonSerializable);


  bool parsed = false;
  
  late final String className;
  late final String entityName;
  late final String modelName;
  late final List<String> mixins;
  late final String removePrefix;
  late final FieldRename fieldRename;
  late final List<FieldElement> fields;


  // final List<Field> fields = [];
  // final List<Parameter> parameters = [];

  // @override
  // void visitClassElement(ClassElement element) {
  //   debugger();
  //   print(element);
  // }

  TableAnn_Visitor(Element element) {
    if(element is ClassElement) {
      className = element.name.replaceFirst('*', '');
      if(!CLASS_ITABLE.isSuperOf(element)) {
        print("Class $className doesnt extends $CLASS_ITABLE");
        return;
      } final annTable = _parseTableAnnotation(ANNOTATION_TABLE.firstAnnotationOf(element)!);

      entityName = annTable.entityName;
      modelName = annTable.modelName;
      mixins = annTable.mixins;
      removePrefix = annTable.removePrefix;
      fieldRename = annTable.fieldRename;

      fields = element.fields.where((e) {
        if(!e.isStatic)
          return false;
        if(!CLASS_ENTITY_COLUMN_INFO.isExactlyType(e.type))
          return false;
        return true;
      }).toList();

      if(fields.tryFirstWhere((e) => ANNOTATION_TABLE_COLUMN.hasAnnotationOf(e)) != null)
        fields.retainWhere((e) => ANNOTATION_TABLE_COLUMN.hasAnnotationOf(e));

      parsed = true;
    }
  }

  static ParsedTableAnn _parseTableAnnotation(DartObject object) {
    return ParsedTableAnn(
      entityName: object.getField("entityName")!.toStringValue()!,
      modelName: object.getField("model")!.toTypeValue()?.getDisplayString(withNullability: false) ?? "",
      mixins: object.getField("mixins")!.toListValue()!.map((e) => e.toTypeValue()!.getDisplayString(withNullability: true)).toList(),
      removePrefix: object.getField("removePrefix")!.toStringValue()!,
      fieldRename: FieldRename.values[_DartObject_GetEnumIndex(object.getField("fieldRename")!)],
    );
  }

  static int _DartObject_GetEnumIndex(DartObject object) {
    return object.getField("index")!.toIntValue()!;
  }
}

class ParsedTableAnn {
  final String entityName;
  
  final String modelName;

  final List<String> mixins;
  
  final String removePrefix;
  
  final FieldRename fieldRename;
  const ParsedTableAnn({
    required this.entityName,
    required this.modelName,
    required this.mixins,
    required this.removePrefix,
    required this.fieldRename,
  });
}