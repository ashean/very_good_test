// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $TodoItemsTable extends TodoItems
    with TableInfo<$TodoItemsTable, TodoItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['body']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $TodoItemsTable createAlias(String alias) {
    return $TodoItemsTable(attachedDatabase, alias);
  }
}

class TodoItem extends DataClass implements Insertable<TodoItem> {
  final int id;
  final String title;
  final String content;
  final DateTime? createdAt;
  const TodoItem({
    required this.id,
    required this.title,
    required this.content,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(content);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  TodoItemsCompanion toCompanion(bool nullToAbsent) {
    return TodoItemsCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory TodoItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoItem(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  TodoItem copyWith({
    int? id,
    String? title,
    String? content,
    Value<DateTime?> createdAt = const Value.absent(),
  }) => TodoItem(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  TodoItem copyWithCompanion(TodoItemsCompanion data) {
    return TodoItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class TodoItemsCompanion extends UpdateCompanion<TodoItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime?> createdAt;
  const TodoItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TodoItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    this.createdAt = const Value.absent(),
  }) : title = Value(title),
       content = Value(content);
  static Insertable<TodoItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'body': content,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TodoItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? content,
    Value<DateTime?>? createdAt,
  }) {
    return TodoItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['body'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    age,
    heightCm,
    weightKg,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String name;
  final int age;
  final double heightCm;
  final double weightKg;
  final DateTime createdAt;
  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<int>(age);
    map['height_cm'] = Variable<double>(heightCm);
    map['weight_kg'] = Variable<double>(weightKg);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      name: Value(name),
      age: Value(age),
      heightCm: Value(heightCm),
      weightKg: Value(weightKg),
      createdAt: Value(createdAt),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'heightCm': serializer.toJson<double>(heightCm),
      'weightKg': serializer.toJson<double>(weightKg),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserProfile copyWith({
    int? id,
    String? name,
    int? age,
    double? heightCm,
    double? weightKg,
    DateTime? createdAt,
  }) => UserProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
    heightCm: heightCm ?? this.heightCm,
    weightKg: weightKg ?? this.weightKg,
    createdAt: createdAt ?? this.createdAt,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, age, heightCm, weightKg, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.createdAt == this.createdAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> age;
  final Value<double> heightCm;
  final Value<double> weightKg;
  final Value<DateTime> createdAt;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int age,
    required double heightCm,
    required double weightKg,
    required DateTime createdAt,
  }) : name = Value(name),
       age = Value(age),
       heightCm = Value(heightCm),
       weightKg = Value(weightKg),
       createdAt = Value(createdAt);
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? age,
    Value<double>? heightCm,
    Value<double>? weightKg,
    Value<DateTime>? createdAt,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BloodTestResultsTable extends BloodTestResults
    with TableInfo<$BloodTestResultsTable, BloodTestResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BloodTestResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userProfileIdMeta = const VerificationMeta(
    'userProfileId',
  );
  @override
  late final GeneratedColumn<int> userProfileId = GeneratedColumn<int>(
    'user_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles (id)',
    ),
  );
  static const VerificationMeta _testDateMeta = const VerificationMeta(
    'testDate',
  );
  @override
  late final GeneratedColumn<DateTime> testDate = GeneratedColumn<DateTime>(
    'test_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCholesterolMeta = const VerificationMeta(
    'totalCholesterol',
  );
  @override
  late final GeneratedColumn<double> totalCholesterol = GeneratedColumn<double>(
    'total_cholesterol',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hdlCholesterolMeta = const VerificationMeta(
    'hdlCholesterol',
  );
  @override
  late final GeneratedColumn<double> hdlCholesterol = GeneratedColumn<double>(
    'hdl_cholesterol',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ldlCholesterolMeta = const VerificationMeta(
    'ldlCholesterol',
  );
  @override
  late final GeneratedColumn<double> ldlCholesterol = GeneratedColumn<double>(
    'ldl_cholesterol',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _triglyceridesMeta = const VerificationMeta(
    'triglycerides',
  );
  @override
  late final GeneratedColumn<double> triglycerides = GeneratedColumn<double>(
    'triglycerides',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fastingGlucoseMeta = const VerificationMeta(
    'fastingGlucose',
  );
  @override
  late final GeneratedColumn<double> fastingGlucose = GeneratedColumn<double>(
    'fasting_glucose',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hba1cMeta = const VerificationMeta('hba1c');
  @override
  late final GeneratedColumn<double> hba1c = GeneratedColumn<double>(
    'hba1c',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userProfileId,
    testDate,
    totalCholesterol,
    hdlCholesterol,
    ldlCholesterol,
    triglycerides,
    fastingGlucose,
    hba1c,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blood_test_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<BloodTestResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_profile_id')) {
      context.handle(
        _userProfileIdMeta,
        userProfileId.isAcceptableOrUnknown(
          data['user_profile_id']!,
          _userProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userProfileIdMeta);
    }
    if (data.containsKey('test_date')) {
      context.handle(
        _testDateMeta,
        testDate.isAcceptableOrUnknown(data['test_date']!, _testDateMeta),
      );
    } else if (isInserting) {
      context.missing(_testDateMeta);
    }
    if (data.containsKey('total_cholesterol')) {
      context.handle(
        _totalCholesterolMeta,
        totalCholesterol.isAcceptableOrUnknown(
          data['total_cholesterol']!,
          _totalCholesterolMeta,
        ),
      );
    }
    if (data.containsKey('hdl_cholesterol')) {
      context.handle(
        _hdlCholesterolMeta,
        hdlCholesterol.isAcceptableOrUnknown(
          data['hdl_cholesterol']!,
          _hdlCholesterolMeta,
        ),
      );
    }
    if (data.containsKey('ldl_cholesterol')) {
      context.handle(
        _ldlCholesterolMeta,
        ldlCholesterol.isAcceptableOrUnknown(
          data['ldl_cholesterol']!,
          _ldlCholesterolMeta,
        ),
      );
    }
    if (data.containsKey('triglycerides')) {
      context.handle(
        _triglyceridesMeta,
        triglycerides.isAcceptableOrUnknown(
          data['triglycerides']!,
          _triglyceridesMeta,
        ),
      );
    }
    if (data.containsKey('fasting_glucose')) {
      context.handle(
        _fastingGlucoseMeta,
        fastingGlucose.isAcceptableOrUnknown(
          data['fasting_glucose']!,
          _fastingGlucoseMeta,
        ),
      );
    }
    if (data.containsKey('hba1c')) {
      context.handle(
        _hba1cMeta,
        hba1c.isAcceptableOrUnknown(data['hba1c']!, _hba1cMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BloodTestResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BloodTestResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_profile_id'],
      )!,
      testDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}test_date'],
      )!,
      totalCholesterol: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cholesterol'],
      ),
      hdlCholesterol: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hdl_cholesterol'],
      ),
      ldlCholesterol: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ldl_cholesterol'],
      ),
      triglycerides: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}triglycerides'],
      ),
      fastingGlucose: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fasting_glucose'],
      ),
      hba1c: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hba1c'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BloodTestResultsTable createAlias(String alias) {
    return $BloodTestResultsTable(attachedDatabase, alias);
  }
}

class BloodTestResult extends DataClass implements Insertable<BloodTestResult> {
  final int id;
  final int userProfileId;
  final DateTime testDate;
  final double? totalCholesterol;
  final double? hdlCholesterol;
  final double? ldlCholesterol;
  final double? triglycerides;
  final double? fastingGlucose;
  final double? hba1c;
  final DateTime createdAt;
  const BloodTestResult({
    required this.id,
    required this.userProfileId,
    required this.testDate,
    this.totalCholesterol,
    this.hdlCholesterol,
    this.ldlCholesterol,
    this.triglycerides,
    this.fastingGlucose,
    this.hba1c,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_profile_id'] = Variable<int>(userProfileId);
    map['test_date'] = Variable<DateTime>(testDate);
    if (!nullToAbsent || totalCholesterol != null) {
      map['total_cholesterol'] = Variable<double>(totalCholesterol);
    }
    if (!nullToAbsent || hdlCholesterol != null) {
      map['hdl_cholesterol'] = Variable<double>(hdlCholesterol);
    }
    if (!nullToAbsent || ldlCholesterol != null) {
      map['ldl_cholesterol'] = Variable<double>(ldlCholesterol);
    }
    if (!nullToAbsent || triglycerides != null) {
      map['triglycerides'] = Variable<double>(triglycerides);
    }
    if (!nullToAbsent || fastingGlucose != null) {
      map['fasting_glucose'] = Variable<double>(fastingGlucose);
    }
    if (!nullToAbsent || hba1c != null) {
      map['hba1c'] = Variable<double>(hba1c);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BloodTestResultsCompanion toCompanion(bool nullToAbsent) {
    return BloodTestResultsCompanion(
      id: Value(id),
      userProfileId: Value(userProfileId),
      testDate: Value(testDate),
      totalCholesterol: totalCholesterol == null && nullToAbsent
          ? const Value.absent()
          : Value(totalCholesterol),
      hdlCholesterol: hdlCholesterol == null && nullToAbsent
          ? const Value.absent()
          : Value(hdlCholesterol),
      ldlCholesterol: ldlCholesterol == null && nullToAbsent
          ? const Value.absent()
          : Value(ldlCholesterol),
      triglycerides: triglycerides == null && nullToAbsent
          ? const Value.absent()
          : Value(triglycerides),
      fastingGlucose: fastingGlucose == null && nullToAbsent
          ? const Value.absent()
          : Value(fastingGlucose),
      hba1c: hba1c == null && nullToAbsent
          ? const Value.absent()
          : Value(hba1c),
      createdAt: Value(createdAt),
    );
  }

  factory BloodTestResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BloodTestResult(
      id: serializer.fromJson<int>(json['id']),
      userProfileId: serializer.fromJson<int>(json['userProfileId']),
      testDate: serializer.fromJson<DateTime>(json['testDate']),
      totalCholesterol: serializer.fromJson<double?>(json['totalCholesterol']),
      hdlCholesterol: serializer.fromJson<double?>(json['hdlCholesterol']),
      ldlCholesterol: serializer.fromJson<double?>(json['ldlCholesterol']),
      triglycerides: serializer.fromJson<double?>(json['triglycerides']),
      fastingGlucose: serializer.fromJson<double?>(json['fastingGlucose']),
      hba1c: serializer.fromJson<double?>(json['hba1c']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userProfileId': serializer.toJson<int>(userProfileId),
      'testDate': serializer.toJson<DateTime>(testDate),
      'totalCholesterol': serializer.toJson<double?>(totalCholesterol),
      'hdlCholesterol': serializer.toJson<double?>(hdlCholesterol),
      'ldlCholesterol': serializer.toJson<double?>(ldlCholesterol),
      'triglycerides': serializer.toJson<double?>(triglycerides),
      'fastingGlucose': serializer.toJson<double?>(fastingGlucose),
      'hba1c': serializer.toJson<double?>(hba1c),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BloodTestResult copyWith({
    int? id,
    int? userProfileId,
    DateTime? testDate,
    Value<double?> totalCholesterol = const Value.absent(),
    Value<double?> hdlCholesterol = const Value.absent(),
    Value<double?> ldlCholesterol = const Value.absent(),
    Value<double?> triglycerides = const Value.absent(),
    Value<double?> fastingGlucose = const Value.absent(),
    Value<double?> hba1c = const Value.absent(),
    DateTime? createdAt,
  }) => BloodTestResult(
    id: id ?? this.id,
    userProfileId: userProfileId ?? this.userProfileId,
    testDate: testDate ?? this.testDate,
    totalCholesterol: totalCholesterol.present
        ? totalCholesterol.value
        : this.totalCholesterol,
    hdlCholesterol: hdlCholesterol.present
        ? hdlCholesterol.value
        : this.hdlCholesterol,
    ldlCholesterol: ldlCholesterol.present
        ? ldlCholesterol.value
        : this.ldlCholesterol,
    triglycerides: triglycerides.present
        ? triglycerides.value
        : this.triglycerides,
    fastingGlucose: fastingGlucose.present
        ? fastingGlucose.value
        : this.fastingGlucose,
    hba1c: hba1c.present ? hba1c.value : this.hba1c,
    createdAt: createdAt ?? this.createdAt,
  );
  BloodTestResult copyWithCompanion(BloodTestResultsCompanion data) {
    return BloodTestResult(
      id: data.id.present ? data.id.value : this.id,
      userProfileId: data.userProfileId.present
          ? data.userProfileId.value
          : this.userProfileId,
      testDate: data.testDate.present ? data.testDate.value : this.testDate,
      totalCholesterol: data.totalCholesterol.present
          ? data.totalCholesterol.value
          : this.totalCholesterol,
      hdlCholesterol: data.hdlCholesterol.present
          ? data.hdlCholesterol.value
          : this.hdlCholesterol,
      ldlCholesterol: data.ldlCholesterol.present
          ? data.ldlCholesterol.value
          : this.ldlCholesterol,
      triglycerides: data.triglycerides.present
          ? data.triglycerides.value
          : this.triglycerides,
      fastingGlucose: data.fastingGlucose.present
          ? data.fastingGlucose.value
          : this.fastingGlucose,
      hba1c: data.hba1c.present ? data.hba1c.value : this.hba1c,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BloodTestResult(')
          ..write('id: $id, ')
          ..write('userProfileId: $userProfileId, ')
          ..write('testDate: $testDate, ')
          ..write('totalCholesterol: $totalCholesterol, ')
          ..write('hdlCholesterol: $hdlCholesterol, ')
          ..write('ldlCholesterol: $ldlCholesterol, ')
          ..write('triglycerides: $triglycerides, ')
          ..write('fastingGlucose: $fastingGlucose, ')
          ..write('hba1c: $hba1c, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userProfileId,
    testDate,
    totalCholesterol,
    hdlCholesterol,
    ldlCholesterol,
    triglycerides,
    fastingGlucose,
    hba1c,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BloodTestResult &&
          other.id == this.id &&
          other.userProfileId == this.userProfileId &&
          other.testDate == this.testDate &&
          other.totalCholesterol == this.totalCholesterol &&
          other.hdlCholesterol == this.hdlCholesterol &&
          other.ldlCholesterol == this.ldlCholesterol &&
          other.triglycerides == this.triglycerides &&
          other.fastingGlucose == this.fastingGlucose &&
          other.hba1c == this.hba1c &&
          other.createdAt == this.createdAt);
}

class BloodTestResultsCompanion extends UpdateCompanion<BloodTestResult> {
  final Value<int> id;
  final Value<int> userProfileId;
  final Value<DateTime> testDate;
  final Value<double?> totalCholesterol;
  final Value<double?> hdlCholesterol;
  final Value<double?> ldlCholesterol;
  final Value<double?> triglycerides;
  final Value<double?> fastingGlucose;
  final Value<double?> hba1c;
  final Value<DateTime> createdAt;
  const BloodTestResultsCompanion({
    this.id = const Value.absent(),
    this.userProfileId = const Value.absent(),
    this.testDate = const Value.absent(),
    this.totalCholesterol = const Value.absent(),
    this.hdlCholesterol = const Value.absent(),
    this.ldlCholesterol = const Value.absent(),
    this.triglycerides = const Value.absent(),
    this.fastingGlucose = const Value.absent(),
    this.hba1c = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BloodTestResultsCompanion.insert({
    this.id = const Value.absent(),
    required int userProfileId,
    required DateTime testDate,
    this.totalCholesterol = const Value.absent(),
    this.hdlCholesterol = const Value.absent(),
    this.ldlCholesterol = const Value.absent(),
    this.triglycerides = const Value.absent(),
    this.fastingGlucose = const Value.absent(),
    this.hba1c = const Value.absent(),
    required DateTime createdAt,
  }) : userProfileId = Value(userProfileId),
       testDate = Value(testDate),
       createdAt = Value(createdAt);
  static Insertable<BloodTestResult> custom({
    Expression<int>? id,
    Expression<int>? userProfileId,
    Expression<DateTime>? testDate,
    Expression<double>? totalCholesterol,
    Expression<double>? hdlCholesterol,
    Expression<double>? ldlCholesterol,
    Expression<double>? triglycerides,
    Expression<double>? fastingGlucose,
    Expression<double>? hba1c,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userProfileId != null) 'user_profile_id': userProfileId,
      if (testDate != null) 'test_date': testDate,
      if (totalCholesterol != null) 'total_cholesterol': totalCholesterol,
      if (hdlCholesterol != null) 'hdl_cholesterol': hdlCholesterol,
      if (ldlCholesterol != null) 'ldl_cholesterol': ldlCholesterol,
      if (triglycerides != null) 'triglycerides': triglycerides,
      if (fastingGlucose != null) 'fasting_glucose': fastingGlucose,
      if (hba1c != null) 'hba1c': hba1c,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BloodTestResultsCompanion copyWith({
    Value<int>? id,
    Value<int>? userProfileId,
    Value<DateTime>? testDate,
    Value<double?>? totalCholesterol,
    Value<double?>? hdlCholesterol,
    Value<double?>? ldlCholesterol,
    Value<double?>? triglycerides,
    Value<double?>? fastingGlucose,
    Value<double?>? hba1c,
    Value<DateTime>? createdAt,
  }) {
    return BloodTestResultsCompanion(
      id: id ?? this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      testDate: testDate ?? this.testDate,
      totalCholesterol: totalCholesterol ?? this.totalCholesterol,
      hdlCholesterol: hdlCholesterol ?? this.hdlCholesterol,
      ldlCholesterol: ldlCholesterol ?? this.ldlCholesterol,
      triglycerides: triglycerides ?? this.triglycerides,
      fastingGlucose: fastingGlucose ?? this.fastingGlucose,
      hba1c: hba1c ?? this.hba1c,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userProfileId.present) {
      map['user_profile_id'] = Variable<int>(userProfileId.value);
    }
    if (testDate.present) {
      map['test_date'] = Variable<DateTime>(testDate.value);
    }
    if (totalCholesterol.present) {
      map['total_cholesterol'] = Variable<double>(totalCholesterol.value);
    }
    if (hdlCholesterol.present) {
      map['hdl_cholesterol'] = Variable<double>(hdlCholesterol.value);
    }
    if (ldlCholesterol.present) {
      map['ldl_cholesterol'] = Variable<double>(ldlCholesterol.value);
    }
    if (triglycerides.present) {
      map['triglycerides'] = Variable<double>(triglycerides.value);
    }
    if (fastingGlucose.present) {
      map['fasting_glucose'] = Variable<double>(fastingGlucose.value);
    }
    if (hba1c.present) {
      map['hba1c'] = Variable<double>(hba1c.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BloodTestResultsCompanion(')
          ..write('id: $id, ')
          ..write('userProfileId: $userProfileId, ')
          ..write('testDate: $testDate, ')
          ..write('totalCholesterol: $totalCholesterol, ')
          ..write('hdlCholesterol: $hdlCholesterol, ')
          ..write('ldlCholesterol: $ldlCholesterol, ')
          ..write('triglycerides: $triglycerides, ')
          ..write('fastingGlucose: $fastingGlucose, ')
          ..write('hba1c: $hba1c, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TodoItemsTable todoItems = $TodoItemsTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $BloodTestResultsTable bloodTestResults = $BloodTestResultsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    todoItems,
    userProfiles,
    bloodTestResults,
  ];
}

typedef $$TodoItemsTableCreateCompanionBuilder =
    TodoItemsCompanion Function({
      Value<int> id,
      required String title,
      required String content,
      Value<DateTime?> createdAt,
    });
typedef $$TodoItemsTableUpdateCompanionBuilder =
    TodoItemsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> content,
      Value<DateTime?> createdAt,
    });

class $$TodoItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodoItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodoItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TodoItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodoItemsTable,
          TodoItem,
          $$TodoItemsTableFilterComposer,
          $$TodoItemsTableOrderingComposer,
          $$TodoItemsTableAnnotationComposer,
          $$TodoItemsTableCreateCompanionBuilder,
          $$TodoItemsTableUpdateCompanionBuilder,
          (TodoItem, BaseReferences<_$AppDatabase, $TodoItemsTable, TodoItem>),
          TodoItem,
          PrefetchHooks Function()
        > {
  $$TodoItemsTableTableManager(_$AppDatabase db, $TodoItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
              }) => TodoItemsCompanion(
                id: id,
                title: title,
                content: content,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String content,
                Value<DateTime?> createdAt = const Value.absent(),
              }) => TodoItemsCompanion.insert(
                id: id,
                title: title,
                content: content,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodoItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodoItemsTable,
      TodoItem,
      $$TodoItemsTableFilterComposer,
      $$TodoItemsTableOrderingComposer,
      $$TodoItemsTableAnnotationComposer,
      $$TodoItemsTableCreateCompanionBuilder,
      $$TodoItemsTableUpdateCompanionBuilder,
      (TodoItem, BaseReferences<_$AppDatabase, $TodoItemsTable, TodoItem>),
      TodoItem,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      required String name,
      required int age,
      required double heightCm,
      required double weightKg,
      required DateTime createdAt,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> age,
      Value<double> heightCm,
      Value<double> weightKg,
      Value<DateTime> createdAt,
    });

final class $$UserProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile> {
  $$UserProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BloodTestResultsTable, List<BloodTestResult>>
  _bloodTestResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bloodTestResults,
    aliasName: $_aliasNameGenerator(
      db.userProfiles.id,
      db.bloodTestResults.userProfileId,
    ),
  );

  $$BloodTestResultsTableProcessedTableManager get bloodTestResultsRefs {
    final manager = $$BloodTestResultsTableTableManager(
      $_db,
      $_db.bloodTestResults,
    ).filter((f) => f.userProfileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bloodTestResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bloodTestResultsRefs(
    Expression<bool> Function($$BloodTestResultsTableFilterComposer f) f,
  ) {
    final $$BloodTestResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bloodTestResults,
      getReferencedColumn: (t) => t.userProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BloodTestResultsTableFilterComposer(
            $db: $db,
            $table: $db.bloodTestResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> bloodTestResultsRefs<T extends Object>(
    Expression<T> Function($$BloodTestResultsTableAnnotationComposer a) f,
  ) {
    final $$BloodTestResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bloodTestResults,
      getReferencedColumn: (t) => t.userProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BloodTestResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.bloodTestResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (UserProfile, $$UserProfilesTableReferences),
          UserProfile,
          PrefetchHooks Function({bool bloodTestResultsRefs})
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                name: name,
                age: age,
                heightCm: heightCm,
                weightKg: weightKg,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int age,
                required double heightCm,
                required double weightKg,
                required DateTime createdAt,
              }) => UserProfilesCompanion.insert(
                id: id,
                name: name,
                age: age,
                heightCm: heightCm,
                weightKg: weightKg,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bloodTestResultsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (bloodTestResultsRefs) db.bloodTestResults,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bloodTestResultsRefs)
                    await $_getPrefetchedData<
                      UserProfile,
                      $UserProfilesTable,
                      BloodTestResult
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableReferences
                          ._bloodTestResultsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UserProfilesTableReferences(
                            db,
                            table,
                            p0,
                          ).bloodTestResultsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.userProfileId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (UserProfile, $$UserProfilesTableReferences),
      UserProfile,
      PrefetchHooks Function({bool bloodTestResultsRefs})
    >;
typedef $$BloodTestResultsTableCreateCompanionBuilder =
    BloodTestResultsCompanion Function({
      Value<int> id,
      required int userProfileId,
      required DateTime testDate,
      Value<double?> totalCholesterol,
      Value<double?> hdlCholesterol,
      Value<double?> ldlCholesterol,
      Value<double?> triglycerides,
      Value<double?> fastingGlucose,
      Value<double?> hba1c,
      required DateTime createdAt,
    });
typedef $$BloodTestResultsTableUpdateCompanionBuilder =
    BloodTestResultsCompanion Function({
      Value<int> id,
      Value<int> userProfileId,
      Value<DateTime> testDate,
      Value<double?> totalCholesterol,
      Value<double?> hdlCholesterol,
      Value<double?> ldlCholesterol,
      Value<double?> triglycerides,
      Value<double?> fastingGlucose,
      Value<double?> hba1c,
      Value<DateTime> createdAt,
    });

final class $$BloodTestResultsTableReferences
    extends
        BaseReferences<_$AppDatabase, $BloodTestResultsTable, BloodTestResult> {
  $$BloodTestResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTable _userProfileIdTable(_$AppDatabase db) =>
      db.userProfiles.createAlias(
        $_aliasNameGenerator(
          db.bloodTestResults.userProfileId,
          db.userProfiles.id,
        ),
      );

  $$UserProfilesTableProcessedTableManager get userProfileId {
    final $_column = $_itemColumn<int>('user_profile_id')!;

    final manager = $$UserProfilesTableTableManager(
      $_db,
      $_db.userProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BloodTestResultsTableFilterComposer
    extends Composer<_$AppDatabase, $BloodTestResultsTable> {
  $$BloodTestResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get testDate => $composableBuilder(
    column: $table.testDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCholesterol => $composableBuilder(
    column: $table.totalCholesterol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hdlCholesterol => $composableBuilder(
    column: $table.hdlCholesterol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ldlCholesterol => $composableBuilder(
    column: $table.ldlCholesterol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get triglycerides => $composableBuilder(
    column: $table.triglycerides,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fastingGlucose => $composableBuilder(
    column: $table.fastingGlucose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hba1c => $composableBuilder(
    column: $table.hba1c,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableFilterComposer get userProfileId {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableFilterComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BloodTestResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $BloodTestResultsTable> {
  $$BloodTestResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get testDate => $composableBuilder(
    column: $table.testDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCholesterol => $composableBuilder(
    column: $table.totalCholesterol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hdlCholesterol => $composableBuilder(
    column: $table.hdlCholesterol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ldlCholesterol => $composableBuilder(
    column: $table.ldlCholesterol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get triglycerides => $composableBuilder(
    column: $table.triglycerides,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fastingGlucose => $composableBuilder(
    column: $table.fastingGlucose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hba1c => $composableBuilder(
    column: $table.hba1c,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableOrderingComposer get userProfileId {
    final $$UserProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BloodTestResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BloodTestResultsTable> {
  $$BloodTestResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get testDate =>
      $composableBuilder(column: $table.testDate, builder: (column) => column);

  GeneratedColumn<double> get totalCholesterol => $composableBuilder(
    column: $table.totalCholesterol,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hdlCholesterol => $composableBuilder(
    column: $table.hdlCholesterol,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ldlCholesterol => $composableBuilder(
    column: $table.ldlCholesterol,
    builder: (column) => column,
  );

  GeneratedColumn<double> get triglycerides => $composableBuilder(
    column: $table.triglycerides,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fastingGlucose => $composableBuilder(
    column: $table.fastingGlucose,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hba1c =>
      $composableBuilder(column: $table.hba1c, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UserProfilesTableAnnotationComposer get userProfileId {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BloodTestResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BloodTestResultsTable,
          BloodTestResult,
          $$BloodTestResultsTableFilterComposer,
          $$BloodTestResultsTableOrderingComposer,
          $$BloodTestResultsTableAnnotationComposer,
          $$BloodTestResultsTableCreateCompanionBuilder,
          $$BloodTestResultsTableUpdateCompanionBuilder,
          (BloodTestResult, $$BloodTestResultsTableReferences),
          BloodTestResult,
          PrefetchHooks Function({bool userProfileId})
        > {
  $$BloodTestResultsTableTableManager(
    _$AppDatabase db,
    $BloodTestResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BloodTestResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BloodTestResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BloodTestResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userProfileId = const Value.absent(),
                Value<DateTime> testDate = const Value.absent(),
                Value<double?> totalCholesterol = const Value.absent(),
                Value<double?> hdlCholesterol = const Value.absent(),
                Value<double?> ldlCholesterol = const Value.absent(),
                Value<double?> triglycerides = const Value.absent(),
                Value<double?> fastingGlucose = const Value.absent(),
                Value<double?> hba1c = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BloodTestResultsCompanion(
                id: id,
                userProfileId: userProfileId,
                testDate: testDate,
                totalCholesterol: totalCholesterol,
                hdlCholesterol: hdlCholesterol,
                ldlCholesterol: ldlCholesterol,
                triglycerides: triglycerides,
                fastingGlucose: fastingGlucose,
                hba1c: hba1c,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userProfileId,
                required DateTime testDate,
                Value<double?> totalCholesterol = const Value.absent(),
                Value<double?> hdlCholesterol = const Value.absent(),
                Value<double?> ldlCholesterol = const Value.absent(),
                Value<double?> triglycerides = const Value.absent(),
                Value<double?> fastingGlucose = const Value.absent(),
                Value<double?> hba1c = const Value.absent(),
                required DateTime createdAt,
              }) => BloodTestResultsCompanion.insert(
                id: id,
                userProfileId: userProfileId,
                testDate: testDate,
                totalCholesterol: totalCholesterol,
                hdlCholesterol: hdlCholesterol,
                ldlCholesterol: ldlCholesterol,
                triglycerides: triglycerides,
                fastingGlucose: fastingGlucose,
                hba1c: hba1c,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BloodTestResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userProfileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userProfileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userProfileId,
                                referencedTable:
                                    $$BloodTestResultsTableReferences
                                        ._userProfileIdTable(db),
                                referencedColumn:
                                    $$BloodTestResultsTableReferences
                                        ._userProfileIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BloodTestResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BloodTestResultsTable,
      BloodTestResult,
      $$BloodTestResultsTableFilterComposer,
      $$BloodTestResultsTableOrderingComposer,
      $$BloodTestResultsTableAnnotationComposer,
      $$BloodTestResultsTableCreateCompanionBuilder,
      $$BloodTestResultsTableUpdateCompanionBuilder,
      (BloodTestResult, $$BloodTestResultsTableReferences),
      BloodTestResult,
      PrefetchHooks Function({bool userProfileId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TodoItemsTableTableManager get todoItems =>
      $$TodoItemsTableTableManager(_db, _db.todoItems);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$BloodTestResultsTableTableManager get bloodTestResults =>
      $$BloodTestResultsTableTableManager(_db, _db.bloodTestResults);
}
