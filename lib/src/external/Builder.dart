library truecollaboration.ientity_generator;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'extension_generator.dart';


Builder generateExtension(BuilderOptions options)
  => SharedPartBuilder([ExtensionGenerator()], 'extension_generator');