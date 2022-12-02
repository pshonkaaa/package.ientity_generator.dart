import 'dart:async';

import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:ientity/library.dart';
import 'package:ientity_generator/src/internal/TableAnn_Visitor.dart';
import 'package:json_annotation_ex/library.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

class ExtensionGenerator extends GeneratorForAnnotation<AnTable> {
  final List<String> entityNames = [];

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final sb = new StringBuffer();
    sb.writeln('// ignore_for_file: unused_local_variable, dead_code');
    
    final gen = await super.generate(library, buildStep);

    {
      sb.writeln('/*');
      sb.writeln('export "generated.g.dart" show ');
      for(int i = 0; i < entityNames.length; i++) {
        if(i != 0)
          sb.writeln(", ");
        final name = entityNames[i];
        sb.write("\t$name");
      }
      sb.writeln(';');
      sb.writeln('*/');
    }
    // debugger();
    sb.writeln(gen);
    // print(content);
    return sb.toString();
  }
  
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = TableAnn_Visitor(element);
    element.visitChildren(visitor);
    if(!visitor.parsed)
      return '';

    entityNames.add(visitor.entityName);

    final buffer = StringBuffer();

    final entity = QEntity.fromClassElement(visitor);

    buffer.write(entity.buffer);
    
    return buffer.toString();
  }
}

































class QEntity {
  final TableAnn_Visitor visitor;
  final buffer = StringBuffer();
  QEntity.fromClassElement(this.visitor) {
    buffer.writeln('class ${visitor.entityName} extends IEntity {');

    buffer.writeln('static const TAG = "${visitor.entityName}";');

    buffer.writeln('');
    
    // buffer.writeln('@override');
    // buffer.writeln('late int id;');
    for(final field in visitor.fields) {
      final info = FieldInfo(visitor, field);
      _putField(
        type: info.typeName,
        name: info.name,
      );
    }

    if(visitor.modelName.isNotEmpty) {
      buffer.writeln();
      _putField(
        type: visitor.modelName,
        name: "model",
      );
    }    

    // Constructor .create
    //--------------------------------------------------------------------------
    {
      buffer.writeln('${visitor.entityName}.create({');
      for(final field in visitor.fields) {
        final info = FieldInfo(visitor, field);
        if(info.isPrimaryKey)
          continue;
        buffer.writeln('\trequired this.${info.name},');
      }
      buffer.writeln('}) : super.create() {');
      buffer.writeln('id = 0;');
      buffer.writeln('setEdited(true, changed: COLUMNS);');
      if(visitor.modelName.isNotEmpty)
        buffer.writeln('model = ${visitor.modelName}.fromEntity(this);');
      buffer.writeln('}');
    }
    //--------------------------------------------------------------------------

    buffer.writeln('');

    // Constructor .fromTable
    //--------------------------------------------------------------------------
    {
      buffer.writeln('${visitor.entityName}.fromTable(JsonObjectEx json) : super.fromTable(json) {');
      for(final field in visitor.fields) {
        final info = FieldInfo(visitor, field);
        final method = getJsonMethodByType(
          varName: "json",
          type: info.dartType,
          typeName: info.typeName,
          typeNameWithoutTemplates: info.typeNameWithoutTemplates,
          templates: info.templates,
          keyName: "${info.constName}.name",
          isNullable: info.isNullable,
          isSerializable: info.isSerializable,
        );
        buffer.writeln('${info.name} = $method');
      }
        
      buffer.writeln('');

      if(visitor.modelName.isNotEmpty)
        buffer.writeln('model = ${visitor.modelName}.fromEntity(this);');

      buffer.writeln('}');
    }
    //--------------------------------------------------------------------------

    buffer.writeln('');
    buffer.writeln('');
    
    // COLUMNS
    //--------------------------------------------------------------------------
    {
      for(final field in visitor.fields) {
        final info = FieldInfo(visitor, field);
        buffer.writeln('\tstatic const ${info.constName} = ${visitor.className}.${field.name};');
      }

      buffer.writeln('');
      
      buffer.writeln('\tstatic const COLUMNS = [');
      for(final field in visitor.fields) {
        final info = FieldInfo(visitor, field);
        buffer.writeln('\t\t${info.constName},');
      }
      buffer.writeln('\t];');

    }
    //--------------------------------------------------------------------------

    buffer.writeln('');
    buffer.writeln('');

    // initState
    //--------------------------------------------------------------------------
    {
      buffer.writeln('@override');
      buffer.writeln('void initState() {');
      {
        buffer.writeln('super.initState();');
        if(visitor.modelName.isNotEmpty)
          buffer.writeln('model.initState();');
      }
      buffer.writeln('}');
    }
    //--------------------------------------------------------------------------

    buffer.writeln('');

    // dispose
    //--------------------------------------------------------------------------
    {
      buffer.writeln('@override');
      buffer.writeln('void dispose() {');
      {
        buffer.writeln('super.dispose();');
        if(visitor.modelName.isNotEmpty)
          buffer.writeln('model.dispose();');
      }
      buffer.writeln('}');
    }
    //--------------------------------------------------------------------------

    buffer.writeln('');


    


    // isIdentical
    //--------------------------------------------------------------------------
    {
      buffer.writeln('@override');
      buffer.writeln('bool isIdentical(');
      buffer.writeln('covariant ${visitor.entityName} m, {');
      buffer.writeln('List<EntityColumnInfo> include = const [],');
      buffer.writeln('List<EntityColumnInfo> exclude = const [],');
      buffer.writeln('List<ChangedColumn>? differences,');
      buffer.writeln('}) {');
      {
        buffer.writeln('final src = this, dst = m;');
        buffer.writeln('final List<EntityColumnInfo> changedList = [];');
        buffer.writeln('bool changed = false;');
        buffer.writeln('');
        buffer.writeln('final list = IEntity.makeParamsList(COLUMNS, include, exclude);');
        buffer.writeln('{');

        buffer.writeln('bool flag = false;');
        for(final field in visitor.fields) {
          final info = FieldInfo(visitor, field);
          buffer.writeln('//------------------------------------------------------------------------');
          buffer.writeln('flag = list.remove(${info.constName});');
          buffer.writeln('if(flag && !_isEquals(dst.id, src.id)) {');
            buffer.writeln('changedList.add(${info.constName});');
            buffer.writeln('differences?.add(ChangedColumn(${info.constName}, dst.${info.name}, src.${info.name}));');
            buffer.writeln('dst.${info.name} = src.${info.name};');
            buffer.writeln('changed = true;');
          buffer.writeln('}');
        }

        buffer.writeln('}');

      }

      buffer.writeln(r'assert(list.isEmpty, "unknown columns = ${list.map((e) => e.name).toList()}");');
      buffer.writeln('if(changed) {');
      buffer.writeln('m.setEdited(true, changed: changedList);');
      buffer.writeln('} return changed;');
      
      buffer.writeln('}');
    }
    //--------------------------------------------------------------------------
      
    // copyTo
    //--------------------------------------------------------------------------
    {
      buffer.writeln('@override');
      buffer.writeln('bool copyTo(');
      buffer.writeln('covariant ${visitor.entityName} m, {');
      buffer.writeln('List<EntityColumnInfo> include = const [],');
      buffer.writeln('List<EntityColumnInfo> exclude = const [],');
      buffer.writeln('List<ChangedColumn>? differences,');
      buffer.writeln('}) {');
      {
        buffer.writeln('throw UnimplementedError();');
      }
      buffer.writeln('}');
    }
    //--------------------------------------------------------------------------
      
    // copyChangesTo
    //--------------------------------------------------------------------------
    {
      buffer.writeln('@override');
      buffer.writeln('bool copyChangesTo(');
      buffer.writeln('covariant ${visitor.entityName} m, {');
      buffer.writeln('List<EntityColumnInfo> include = const [],');
      buffer.writeln('List<EntityColumnInfo> exclude = const [],');
      buffer.writeln('List<ChangedColumn>? differences,');
      buffer.writeln('}) {');
      {
        buffer.writeln('final src = this, dst = m;');
        buffer.writeln('');
        buffer.writeln('differences ??= [];');
        buffer.writeln('');
        buffer.writeln('final identical = isIdentical(');
        buffer.writeln('dst,');
        buffer.writeln('include: include,');
        buffer.writeln('exclude: exclude,');
        buffer.writeln('differences: differences,');
        buffer.writeln(');');
        buffer.writeln('');
        buffer.writeln('if(!identical)');
        buffer.writeln('return false;');
        buffer.writeln('');
        buffer.writeln('final list = differences.map((e) => e.column).toList();');
        buffer.writeln('');
        buffer.writeln('{');
          buffer.writeln('bool flag = false;');
          for(final field in visitor.fields) {
            final info = FieldInfo(visitor, field);
            buffer.writeln('//------------------------------------------------------------------------');
            buffer.writeln('flag = list.remove(${info.constName});');
            buffer.writeln('if(flag && dst.id != src.id) {');
              buffer.writeln('dst.${info.name} = src.${info.name};');
            buffer.writeln('}');
          }
        buffer.writeln('}');
      }

      buffer.writeln(r'assert(list.isEmpty, "unknown columns = ${list.map((e) => e.name).toList()}");');
      buffer.writeln('m.setEdited(true, changed: differences.map((e) => e.column));');
      buffer.writeln('return true;');
      buffer.writeln('}');
    }
    //--------------------------------------------------------------------------

    // toTable
    //--------------------------------------------------------------------------
    {
      buffer.writeln('@override');
      buffer.writeln('RowInfo toTable({');
      buffer.writeln('required ERequestType requestType,');
      buffer.writeln('List<EntityColumnInfo> include = const [],');
      buffer.writeln('List<EntityColumnInfo> exclude = const [],');
      buffer.writeln('}) {');
      {
        buffer.writeln('final list = IEntity.makeParamsList(COLUMNS, include, exclude);');
        buffer.writeln('final map = {');
          for(final field in visitor.fields) {
            final info = FieldInfo(visitor, field);
            if(info.isPrimaryKey) {
              buffer.writeln('if(list.remove(${info.constName}) && requestType != ERequestType.insert)');
            } else {
              buffer.writeln('if(list.remove(${info.constName}))');
            }
            
            final value = getValueByType(
              varName: "${info.name}",
              type: info.dartType,
              typeName: info.typeName,
              typeNameWithoutTemplates: info.typeNameWithoutTemplates,
              keyName: "${info.constName}.name",
              isNullable: info.isNullable,
              isSerializable: info.isSerializable,
            );
            buffer.writeln('${info.constName}: _transform(${info.constName}, ${value}),');
          }
        buffer.writeln('};');
        buffer.writeln('');
        buffer.writeln(r'assert(list.isEmpty, "unknown columns = ${list.map((e) => e.name).toList()}");');
        buffer.writeln('return RowInfo(map);');
      }
      buffer.writeln('}');
    }
    //--------------------------------------------------------------------------

    // static _isEquals
    //--------------------------------------------------------------------------
    {
      buffer.writeln('bool _isEquals<T>(T a, T b) {');
      {
        buffer.writeln('if(T == List)');
          buffer.writeln('return listEquals(a as List, b as List);');
        buffer.writeln('if(T == Map)');
          buffer.writeln('return mapEquals(a as Map, b as Map);');
        buffer.writeln('return a == b;');
        
      }
      buffer.writeln('}');
    }
    //--------------------------------------------------------------------------

    // static _transform
    //--------------------------------------------------------------------------
    {
      buffer.writeln('T _transform<T>(EntityColumnInfo<T> column, T value) {');
      {
        buffer.writeln('''
          if(column.transformer == null)
            return value;
          return column.transformer!(value);
        ''');
        
      }
      buffer.writeln('}');
    }
    //--------------------------------------------------------------------------


    buffer.writeln('}');
  }

  void _putField({
    required String type,
    required String name,
  }) {
    buffer.writeln("late $type $name;");
  }

  static String getValueByType({
    required String varName,
    required EDartType type,
    required String typeName,
    required String typeNameWithoutTemplates,
    required String keyName,
    required bool isNullable,
    required bool isSerializable,
  }) {
    switch(type) {
      case EDartType.int:
        return varName;
      case EDartType.double:
        return varName;
      case EDartType.string:
        return varName;
      case EDartType.bool:
        return varName;
      case EDartType.ENUM:
        String value = varName;
        if(isNullable)
          value += "?";
        return "${value}.index";
      case EDartType.list:
        return "JsonArrayEx.fromList($varName).stringify()";
      case EDartType.map:
        return "IEntity.jsonEncode($varName)";
      case EDartType.dynamic:
        String value = varName;
        if(typeNameWithoutTemplates == "JsonObjectEx")
          value = "${varName}" + (isNullable ? "?" : "") + ".stringify()";
        else if(typeNameWithoutTemplates == "JsonArrayEx")
          value = "${varName}" + (isNullable ? "?" : "") + ".stringify()";
        else if(isSerializable)
          value = "${varName}" + (isNullable ? "?" : "") + ".toJson().stringify()";
        return value;

      default:
        return varName;
    }
  }

  static String getJsonMethodByType({
    required String varName,
    required EDartType type,
    required String typeName,
    required String typeNameWithoutTemplates,
    required List<String> templates,
    required String keyName,
    required bool isNullable,
    required bool isSerializable,
  }) {
    final buffer = StringBuffer();

    String method;

    switch(type) {
      case EDartType.int:
        method = "getInteger";
        break;
      case EDartType.double:
        method = "getDouble";
        break;
      case EDartType.string:
        method = "getString";
        break;
      case EDartType.bool:
        method = "getBoolean";
        break;
      case EDartType.ENUM:
        method = "getInteger";
        break;
      case EDartType.list:
        method = "getArray";
        break;
      case EDartType.map:
        method = "getString";
        break;
      case EDartType.dynamic:
        method = "getDynamic";
        if(typeNameWithoutTemplates == "JsonObjectEx")
          method = "getJsonObject";
        else if(typeNameWithoutTemplates == "JsonArrayEx")
          method = "getJsonArray";
        else if(isSerializable)
          method = "getJsonObject";
        break;

      default:
        method = "getDynamic";
        break;
    }

    // final args = methodArgs.join(", ");
    var suffix = isNullable ? "" : "!";

    if(type == EDartType.ENUM) {
      if(isNullable) {
        buffer.write("!$varName.isNull($keyName) ? ");
        suffix = "!";
      }
        
      buffer.write("${typeNameWithoutTemplates}.values[");

    } else if(isSerializable) {
      if(isNullable) {
        buffer.write("!$varName.isNull($keyName) ? ");
        suffix = "!";
      }
        
      buffer.write("${typeNameWithoutTemplates}.fromJson(");
      
    } else if(type == EDartType.map) {
      if(isNullable) {
        buffer.write("!$varName.isNull($keyName) ? ");
        suffix = "!";
      }
        
      buffer.write('IEntity.jsonDecode<${templates.join(",")}>(');
    }


    
    buffer.write('$varName.${method}(${keyName})$suffix');
    
    if(type == EDartType.ENUM) {
      buffer.write("]");

      if(isNullable) {
        buffer.write(" : null");
      }

    } else if(isSerializable) {
      buffer.write(")");

      if(isNullable) {
        buffer.write(" : null");
      }
      
    } else if(type == EDartType.map) {
      buffer.write(")");

      if(isNullable) {
        buffer.write(" : null");
      } else buffer.write("!");
    }
    
    buffer.write(";");
    return buffer.toString();
  }
}
















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
        return EDartType.ENUM;
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

enum EDartType {
  asyncFuture,
  asyncFutureOr,
  asyncStream,
  bool,
  double,
  ENUM,
  function,
  int,
  iterable,
  list,
  map,
  NULL,
  num,
  object,
  record,
  set,
  string,
  symbol,
  dynamic,
  VOID,
}