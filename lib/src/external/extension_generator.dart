import 'dart:async';

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:ientity/library.dart';
import 'package:ientity_generator/src/internal/TableAnn_Visitor.dart';
import 'package:source_gen/source_gen.dart';
import 'package:true_core/library.dart';

import '../internal/classes/field_info.dart';
import '../internal/enums.dart';

class ExtensionGenerator extends GeneratorForAnnotation<TableAnnotation> {
  final List<String> entityNames = [];

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final sb = new StringBuffer();
    sb.writeln('// ignore_for_file: unused_local_variable, dead_code');

    sb.writeln(_generateGlobal());
    
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


String _generateGlobal() {
  final buffer = StringBuffer();

  // _isEquals
  //--------------------------------------------------------------------------
  {
    buffer.writeln('bool _isEquals<T>(T a, T b) {');
    {
      buffer.writeln('if(T == List)');
        buffer.writeln('return _listEquals(a as List, b as List);');
      buffer.writeln('if(T == Map)');
        buffer.writeln('return _mapEquals(a as Map, b as Map);');
      buffer.writeln('return a == b;');
      
    }
    buffer.writeln('}');
  }
  //--------------------------------------------------------------------------

  // _listEquals
  //--------------------------------------------------------------------------
  {
    final string =
'''/// from 'package:flutter/foundation.dart'
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
''';
    buffer.writeln(string);
  };
  //--------------------------------------------------------------------------

  // _mapEquals
  //--------------------------------------------------------------------------
  {
    final string =
'''/// from 'package:flutter/foundation.dart'
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
''';
    buffer.writeln(string);
  };
  //--------------------------------------------------------------------------

  // _transform
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

  return buffer.toString();
}

































class QEntity {
  final TableAnn_Visitor visitor;
  final buffer = StringBuffer();
  
  QEntity.fromClassElement(this.visitor) {
    _main();
  }
    
  void _main() {
    buffer.writeln('class ${visitor.entityName} extends BaseEntity {');

    buffer.writeln('static const TAG = "${visitor.entityName}";');

    buffer.writeln();
    buffer.writeln();

    _genColumns();

    buffer.writeln();
    buffer.writeln();

    _genConstructorCreate();

    buffer.writeln();

    _genConstructorFromTable();

    buffer.writeln();

    _genVariables();

    buffer.writeln();

    buffer.writeln();
    buffer.writeln();

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

    buffer.writeln();

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

    buffer.writeln();


    


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
        buffer.writeln();
        buffer.writeln('final list = BaseEntity.makeParamsList(COLUMNS, include, exclude);');
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
      // buffer.writeln('if(changed) {');
      // buffer.writeln('m.setEdited(true, changed: changedList);');
      // buffer.writeln('}');
      buffer.writeln('return changed;');
      
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
        buffer.writeln();
        buffer.writeln('differences ??= [];');
        buffer.writeln();
        buffer.writeln('final identical = isIdentical(');
        buffer.writeln('dst,');
        buffer.writeln('include: include,');
        buffer.writeln('exclude: exclude,');
        buffer.writeln('differences: differences,');
        buffer.writeln(');');
        buffer.writeln();
        buffer.writeln('if(!identical)');
        buffer.writeln('return false;');
        buffer.writeln();
        buffer.writeln('final list = differences.map((e) => e.column).toList();');
        buffer.writeln();
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
        buffer.writeln('final _list = BaseEntity.makeParamsList(COLUMNS, include, exclude);');
        buffer.writeln('final _map = {');
          for(final field in visitor.fields) {
            final info = FieldInfo(visitor, field);
            if(info.isPrimaryKey) {
              buffer.writeln('if(_list.remove(${info.constName}) && requestType != ERequestType.insert)');
            } else {
              buffer.writeln('if(_list.remove(${info.constName}))');
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
        buffer.writeln();
        buffer.writeln(r'assert(_list.isEmpty, "unknown columns = ${_list.map((e) => e.name).toList()}");');
        buffer.writeln('return RowInfo(_map);');
      }
      buffer.writeln('}');
    }
    //--------------------------------------------------------------------------


    buffer.writeln('}');
  }

  void _genColumns() {
    for(final field in visitor.fields) {
      final info = FieldInfo(visitor, field);
      buffer.writeln('\tstatic const ${info.constName} = ${visitor.className}.${field.name};');
    }

    buffer.writeln();
    
    buffer.writeln('\tstatic const COLUMNS = [');
    for(final field in visitor.fields) {
      final info = FieldInfo(visitor, field);
      buffer.writeln('\t\t${info.constName},');
    }
    buffer.writeln('\t];');
  }

  void _genConstructorCreate() {
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

  void _genConstructorFromTable() {
    buffer.writeln('${visitor.entityName}.fromTable(Map<String, dynamic> json) : super.fromTable(json) {');

    buffer.writeln();

    {
      buffer.writeln('// checking if column not exists :|');

      final string = r'''
        for(final column in COLUMNS) {
          if(!json.containsKey(column.name)) {
            throw 'Key not exists; key = ${column.name}';
          }
        }
      ''';
      buffer.writeln(string);
    }

    buffer.writeln();

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
      
    buffer.writeln();

    if(visitor.modelName.isNotEmpty)
      buffer.writeln('model = ${visitor.modelName}.fromEntity(this);');

    buffer.writeln('}');
  }
  
  void _genVariables() {
    // buffer.writeln('@override');
    // buffer.writeln('late int id;');

    for(final field in visitor.fields) {
      final info = FieldInfo(visitor, field);

      buffer.writeln("late ${info.typeName} ${info.name};");
    }

    if(visitor.modelName.isNotEmpty) {
      buffer.writeln();

      buffer.writeln("late ${visitor.modelName} model;");
    }

    buffer.writeln();
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
      case EDartType.enum_:
        String value = varName;
        if(isNullable)
          value += "?";
        return "${value}.index";
      case EDartType.list:
        return "JsonArrayEx.fromList($varName).stringify()";
      case EDartType.map:
        return "BaseEntity.jsonEncode($varName)";
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
    String methodTemplate = '';

    switch(type) {
      case EDartType.int:
        method = "parseInteger";
        break;
      case EDartType.double:
        method = "parseDouble";
        break;
      case EDartType.string:
        method = "parseString";
        break;
      case EDartType.bool:
        method = "parseBoolean";
        break;
      case EDartType.enum_:
        method = "parseInteger";
        break;
      case EDartType.list:
        method = "parseArray";
        methodTemplate = templates.tryFirst ?? '';
        break;
      case EDartType.map:
        method = "parseString";
        break;
      case EDartType.dynamic:
        method = "parseDynamic";
        if(typeNameWithoutTemplates == "JsonObjectEx")
          method = "parseJsonObject";
        else if(typeNameWithoutTemplates == "JsonArrayEx")
          method = "parseJsonArray";
        else if(isSerializable)
          method = "parseJsonObject";
        break;

      default:
        throw 'Unknown data type; variable name = $varName';
        // method = "getDynamic";
        // break;
    }

    // final args = methodArgs.join(", ");
    String suffix = '';


    if(isNullable) {
      buffer.write("$varName[$keyName] != null ? ");
      // suffix = "!";
    }

    if(type == EDartType.enum_) {        
      buffer.write("${typeNameWithoutTemplates}.values[");

    } else if(isSerializable) {        
      buffer.write("${typeNameWithoutTemplates}.fromJson(");
      
    } else if(type == EDartType.map) {        
      buffer.write('BaseEntity.jsonDecode<${templates.join(",")}>(');
    }


    methodTemplate = methodTemplate.isEmpty ? '' : '<$methodTemplate>';
    
    buffer.write('ValueParser.${method}${methodTemplate}(${varName}[${keyName}])$suffix');
    
    if(type == EDartType.enum_) {
      buffer.write("]");

    } else if(isSerializable) {
      buffer.write(")");
      
    } else if(type == EDartType.map) {
      buffer.write(")");

      buffer.write('!');
    }

    if(isNullable) {
      buffer.write(" : null");
    }
    
    buffer.write(";");
    return buffer.toString();
  }
}








































