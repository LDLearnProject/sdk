// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library fasta.mixin_application_builder;

import 'builder.dart' show
    TypeBuilder;

import 'scope.dart' show
    Scope;

abstract class MixinApplicationBuilder<T extends TypeBuilder>
    extends TypeBuilder {
  final T supertype;
  final List<T> mixins;

  MixinApplicationBuilder(this.supertype, this.mixins);

  void resolveIn(Scope scope) {
    supertype.resolveIn(scope);
    for (T t in mixins) {
      t.resolveIn(scope);
    }
  }

  String get debugName => "MixinApplicationBuilder";

  StringBuffer printOn(StringBuffer buffer) {
    buffer.write(supertype);
    buffer.write(" with ");
    bool first = true;
    for (T t in mixins) {
      if (!first) buffer.write(", ");
      first = false;
      t.printOn(buffer);
    }
    return buffer;
  }
}
