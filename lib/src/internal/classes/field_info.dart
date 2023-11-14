import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:json_annotation_ex/library.dart';
import 'package:recase/recase.dart';

import '../TableAnn_Visitor.dart';
import '../enums.dart';

class FieldInfo {
  late String name;
  late String constName;
  late String typeName;
  late String typeNameWithoutTemplates;
  late List<String> templates;
  late EDartType dartType;
  late bool isNullable;
  late bool isPrimaryKey;
  late bool isSerializable;
  FieldInfo(
    TableAnn_Visitor visitor,
    FieldElement field,
  ) {
    final argumentType = (field.type as InterfaceType).typeArguments.first;

    name = field.name;
    name = name.replaceFirst(visitor.removePrefix, "");
    name = encodedFieldName(visitor.fieldRename, name);
    constName = encodedFieldName(FieldRename.constant, name);
    typeName = argumentType.getDisplayString(withNullability: true);
    typeNameWithoutTemplates = argumentType.getDisplayString(withNullability: false).replaceFirst(RegExp(r"\<.*>"), "");
    templates = !typeName.contains("<") ? [] : argumentType.getDisplayString(withNullability: false).replaceAllMapped(RegExp(r".*?\<(.*?)\>"), (match) => match.group(1)!).split(", ");
    dartType = dartTypeToEnum(argumentType);
    isNullable = typeName.endsWith("?");
    // TODO constructor
    isPrimaryKey = name.toLowerCase() == "id";
    isSerializable = TableAnn_Visitor.CLASS_JSON_SERIALIZABLE.isSuperTypeOf(argumentType);
  }

  static String encodedFieldName(
    FieldRename fieldRename,
    String declaredName,
  ) {
    switch (fieldRename) {
      case FieldRename.none:
        return declaredName;
      case FieldRename.camel:
        return declaredName.camelCase;
      case FieldRename.constant:
        return declaredName.constantCase;
      case FieldRename.snake:
        return declaredName.snakeCase;
      case FieldRename.kebab:
        return declaredName.paramCase;
      case FieldRename.pascal:
        return declaredName.pascalCase;
    }
  }

  static EDartType dartTypeToEnum(DartType type) {
    final name = type.getDisplayString(withNullability: false);
    if(name == "bool")
      return EDartType.bool;
    if(name == "double")
      return EDartType.double;
    if(name == "int")
      return EDartType.int;
    if(name == "String")
      return EDartType.string;
    if(name == "dynamic")
      return EDartType.dynamic;
    if(type is InterfaceType && type.superclass != null) {
      if(type.superclass!.isDartCoreEnum)
        return EDartType.enum_;
    }
    if(name.startsWith("List"))
      return EDartType.list;
    if(name.startsWith("Map"))
      return EDartType.map;
    return EDartType.dynamic;

    // // if(type.isDartAsyncFuture)
    // //   return EDartType.asyncFuture;
    // // if(type.isDartAsyncFutureOr)
    // //   return EDartType.asyncFuture;
    // // if(type.isDartAsyncStream)
    // //   return EDartType.asyncFuture;
    // if(type.isDartCoreBool)
    //   return EDartType.bool;
    // if(type.isDartCoreDouble)
    //   return EDartType.double;
    // if(type.isDartCoreEnum)
    //   return EDartType.ENUM;
    // // if(type.isDartCoreFunction)
    // //   return EDartType.asyncFuture;
    // if(type.isDartCoreInt)
    //   return EDartType.int;
    // // if(type.isDartCoreIterable)
    // //   return EDartType.asyncFuture;
    // if(type.isDartCoreList)
    //   return EDartType.list;
    // if(type.isDartCoreMap)
    //   return EDartType.map;
    // // if(type.isDartCoreNull)
    // //   return EDartType.asyncFuture;
    // // if(type.isDartCoreNum)
    // //   return EDartType.asyncFuture;
    // if(type.isDartCoreObject)
    //   return EDartType.object;
    // // if(type.isDartCoreRecord)
    // //   return EDartType.asyncFuture;
    // // if(type.isDartCoreSet)
    // //   return EDartType.asyncFuture;
    // if(type.isDartCoreString)
    //   return EDartType.string;
    // // if(type.isDartCoreSymbol)
    // //   return EDartType.asyncFuture;
    // if(type.isDynamic)
    //   return EDartType.dynamic;
    // // if(type.isVoid)
    // //   return EDartType.VOID;
    // return EDartType.dynamic;
  }
}
