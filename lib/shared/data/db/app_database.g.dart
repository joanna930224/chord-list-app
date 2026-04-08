// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ChordsTable extends Chords with TableInfo<$ChordsTable, Chord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChordsTable(this.attachedDatabase, [this._alias]);
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rootMeta = const VerificationMeta('root');
  @override
  late final GeneratedColumn<String> root = GeneratedColumn<String>(
    'root',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBarreChordMeta = const VerificationMeta(
    'isBarreChord',
  );
  @override
  late final GeneratedColumn<bool> isBarreChord = GeneratedColumn<bool>(
    'is_barre_chord',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_barre_chord" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _aliasesMeta = const VerificationMeta(
    'aliases',
  );
  @override
  late final GeneratedColumn<String> aliases = GeneratedColumn<String>(
    'aliases',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    fullName,
    root,
    type,
    difficulty,
    isBarreChord,
    aliases,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chords';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chord> instance, {
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
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('root')) {
      context.handle(
        _rootMeta,
        root.isAcceptableOrUnknown(data['root']!, _rootMeta),
      );
    } else if (isInserting) {
      context.missing(_rootMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('is_barre_chord')) {
      context.handle(
        _isBarreChordMeta,
        isBarreChord.isAcceptableOrUnknown(
          data['is_barre_chord']!,
          _isBarreChordMeta,
        ),
      );
    }
    if (data.containsKey('aliases')) {
      context.handle(
        _aliasesMeta,
        aliases.isAcceptableOrUnknown(data['aliases']!, _aliasesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      root: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      isBarreChord: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_barre_chord'],
      )!,
      aliases: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aliases'],
      ),
    );
  }

  @override
  $ChordsTable createAlias(String alias) {
    return $ChordsTable(attachedDatabase, alias);
  }
}

class Chord extends DataClass implements Insertable<Chord> {
  final int id;
  final String name;
  final String fullName;
  final String root;
  final String type;
  final String difficulty;
  final bool isBarreChord;
  final String? aliases;
  const Chord({
    required this.id,
    required this.name,
    required this.fullName,
    required this.root,
    required this.type,
    required this.difficulty,
    required this.isBarreChord,
    this.aliases,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['full_name'] = Variable<String>(fullName);
    map['root'] = Variable<String>(root);
    map['type'] = Variable<String>(type);
    map['difficulty'] = Variable<String>(difficulty);
    map['is_barre_chord'] = Variable<bool>(isBarreChord);
    if (!nullToAbsent || aliases != null) {
      map['aliases'] = Variable<String>(aliases);
    }
    return map;
  }

  ChordsCompanion toCompanion(bool nullToAbsent) {
    return ChordsCompanion(
      id: Value(id),
      name: Value(name),
      fullName: Value(fullName),
      root: Value(root),
      type: Value(type),
      difficulty: Value(difficulty),
      isBarreChord: Value(isBarreChord),
      aliases: aliases == null && nullToAbsent
          ? const Value.absent()
          : Value(aliases),
    );
  }

  factory Chord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chord(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      fullName: serializer.fromJson<String>(json['fullName']),
      root: serializer.fromJson<String>(json['root']),
      type: serializer.fromJson<String>(json['type']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      isBarreChord: serializer.fromJson<bool>(json['isBarreChord']),
      aliases: serializer.fromJson<String?>(json['aliases']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'fullName': serializer.toJson<String>(fullName),
      'root': serializer.toJson<String>(root),
      'type': serializer.toJson<String>(type),
      'difficulty': serializer.toJson<String>(difficulty),
      'isBarreChord': serializer.toJson<bool>(isBarreChord),
      'aliases': serializer.toJson<String?>(aliases),
    };
  }

  Chord copyWith({
    int? id,
    String? name,
    String? fullName,
    String? root,
    String? type,
    String? difficulty,
    bool? isBarreChord,
    Value<String?> aliases = const Value.absent(),
  }) => Chord(
    id: id ?? this.id,
    name: name ?? this.name,
    fullName: fullName ?? this.fullName,
    root: root ?? this.root,
    type: type ?? this.type,
    difficulty: difficulty ?? this.difficulty,
    isBarreChord: isBarreChord ?? this.isBarreChord,
    aliases: aliases.present ? aliases.value : this.aliases,
  );
  Chord copyWithCompanion(ChordsCompanion data) {
    return Chord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      root: data.root.present ? data.root.value : this.root,
      type: data.type.present ? data.type.value : this.type,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      isBarreChord: data.isBarreChord.present
          ? data.isBarreChord.value
          : this.isBarreChord,
      aliases: data.aliases.present ? data.aliases.value : this.aliases,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fullName: $fullName, ')
          ..write('root: $root, ')
          ..write('type: $type, ')
          ..write('difficulty: $difficulty, ')
          ..write('isBarreChord: $isBarreChord, ')
          ..write('aliases: $aliases')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    fullName,
    root,
    type,
    difficulty,
    isBarreChord,
    aliases,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chord &&
          other.id == this.id &&
          other.name == this.name &&
          other.fullName == this.fullName &&
          other.root == this.root &&
          other.type == this.type &&
          other.difficulty == this.difficulty &&
          other.isBarreChord == this.isBarreChord &&
          other.aliases == this.aliases);
}

class ChordsCompanion extends UpdateCompanion<Chord> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> fullName;
  final Value<String> root;
  final Value<String> type;
  final Value<String> difficulty;
  final Value<bool> isBarreChord;
  final Value<String?> aliases;
  const ChordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.fullName = const Value.absent(),
    this.root = const Value.absent(),
    this.type = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.isBarreChord = const Value.absent(),
    this.aliases = const Value.absent(),
  });
  ChordsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String fullName,
    required String root,
    required String type,
    required String difficulty,
    this.isBarreChord = const Value.absent(),
    this.aliases = const Value.absent(),
  }) : name = Value(name),
       fullName = Value(fullName),
       root = Value(root),
       type = Value(type),
       difficulty = Value(difficulty);
  static Insertable<Chord> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? fullName,
    Expression<String>? root,
    Expression<String>? type,
    Expression<String>? difficulty,
    Expression<bool>? isBarreChord,
    Expression<String>? aliases,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (fullName != null) 'full_name': fullName,
      if (root != null) 'root': root,
      if (type != null) 'type': type,
      if (difficulty != null) 'difficulty': difficulty,
      if (isBarreChord != null) 'is_barre_chord': isBarreChord,
      if (aliases != null) 'aliases': aliases,
    });
  }

  ChordsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? fullName,
    Value<String>? root,
    Value<String>? type,
    Value<String>? difficulty,
    Value<bool>? isBarreChord,
    Value<String?>? aliases,
  }) {
    return ChordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      root: root ?? this.root,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      isBarreChord: isBarreChord ?? this.isBarreChord,
      aliases: aliases ?? this.aliases,
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
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (root.present) {
      map['root'] = Variable<String>(root.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (isBarreChord.present) {
      map['is_barre_chord'] = Variable<bool>(isBarreChord.value);
    }
    if (aliases.present) {
      map['aliases'] = Variable<String>(aliases.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fullName: $fullName, ')
          ..write('root: $root, ')
          ..write('type: $type, ')
          ..write('difficulty: $difficulty, ')
          ..write('isBarreChord: $isBarreChord, ')
          ..write('aliases: $aliases')
          ..write(')'))
        .toString();
  }
}

class $ChordPositionsTable extends ChordPositions
    with TableInfo<$ChordPositionsTable, ChordPosition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChordPositionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _chordIdMeta = const VerificationMeta(
    'chordId',
  );
  @override
  late final GeneratedColumn<int> chordId = GeneratedColumn<int>(
    'chord_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chords (id)',
    ),
  );
  static const VerificationMeta _baseFretMeta = const VerificationMeta(
    'baseFret',
  );
  @override
  late final GeneratedColumn<int> baseFret = GeneratedColumn<int>(
    'base_fret',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fretsMeta = const VerificationMeta('frets');
  @override
  late final GeneratedColumn<String> frets = GeneratedColumn<String>(
    'frets',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingersMeta = const VerificationMeta(
    'fingers',
  );
  @override
  late final GeneratedColumn<String> fingers = GeneratedColumn<String>(
    'fingers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionIndexMeta = const VerificationMeta(
    'positionIndex',
  );
  @override
  late final GeneratedColumn<int> positionIndex = GeneratedColumn<int>(
    'position_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chordId,
    baseFret,
    frets,
    fingers,
    positionIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chord_positions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChordPosition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chord_id')) {
      context.handle(
        _chordIdMeta,
        chordId.isAcceptableOrUnknown(data['chord_id']!, _chordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chordIdMeta);
    }
    if (data.containsKey('base_fret')) {
      context.handle(
        _baseFretMeta,
        baseFret.isAcceptableOrUnknown(data['base_fret']!, _baseFretMeta),
      );
    } else if (isInserting) {
      context.missing(_baseFretMeta);
    }
    if (data.containsKey('frets')) {
      context.handle(
        _fretsMeta,
        frets.isAcceptableOrUnknown(data['frets']!, _fretsMeta),
      );
    } else if (isInserting) {
      context.missing(_fretsMeta);
    }
    if (data.containsKey('fingers')) {
      context.handle(
        _fingersMeta,
        fingers.isAcceptableOrUnknown(data['fingers']!, _fingersMeta),
      );
    } else if (isInserting) {
      context.missing(_fingersMeta);
    }
    if (data.containsKey('position_index')) {
      context.handle(
        _positionIndexMeta,
        positionIndex.isAcceptableOrUnknown(
          data['position_index']!,
          _positionIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_positionIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChordPosition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChordPosition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chord_id'],
      )!,
      baseFret: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_fret'],
      )!,
      frets: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frets'],
      )!,
      fingers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingers'],
      )!,
      positionIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_index'],
      )!,
    );
  }

  @override
  $ChordPositionsTable createAlias(String alias) {
    return $ChordPositionsTable(attachedDatabase, alias);
  }
}

class ChordPosition extends DataClass implements Insertable<ChordPosition> {
  final int id;
  final int chordId;
  final int baseFret;
  final String frets;
  final String fingers;
  final int positionIndex;
  const ChordPosition({
    required this.id,
    required this.chordId,
    required this.baseFret,
    required this.frets,
    required this.fingers,
    required this.positionIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chord_id'] = Variable<int>(chordId);
    map['base_fret'] = Variable<int>(baseFret);
    map['frets'] = Variable<String>(frets);
    map['fingers'] = Variable<String>(fingers);
    map['position_index'] = Variable<int>(positionIndex);
    return map;
  }

  ChordPositionsCompanion toCompanion(bool nullToAbsent) {
    return ChordPositionsCompanion(
      id: Value(id),
      chordId: Value(chordId),
      baseFret: Value(baseFret),
      frets: Value(frets),
      fingers: Value(fingers),
      positionIndex: Value(positionIndex),
    );
  }

  factory ChordPosition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChordPosition(
      id: serializer.fromJson<int>(json['id']),
      chordId: serializer.fromJson<int>(json['chordId']),
      baseFret: serializer.fromJson<int>(json['baseFret']),
      frets: serializer.fromJson<String>(json['frets']),
      fingers: serializer.fromJson<String>(json['fingers']),
      positionIndex: serializer.fromJson<int>(json['positionIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chordId': serializer.toJson<int>(chordId),
      'baseFret': serializer.toJson<int>(baseFret),
      'frets': serializer.toJson<String>(frets),
      'fingers': serializer.toJson<String>(fingers),
      'positionIndex': serializer.toJson<int>(positionIndex),
    };
  }

  ChordPosition copyWith({
    int? id,
    int? chordId,
    int? baseFret,
    String? frets,
    String? fingers,
    int? positionIndex,
  }) => ChordPosition(
    id: id ?? this.id,
    chordId: chordId ?? this.chordId,
    baseFret: baseFret ?? this.baseFret,
    frets: frets ?? this.frets,
    fingers: fingers ?? this.fingers,
    positionIndex: positionIndex ?? this.positionIndex,
  );
  ChordPosition copyWithCompanion(ChordPositionsCompanion data) {
    return ChordPosition(
      id: data.id.present ? data.id.value : this.id,
      chordId: data.chordId.present ? data.chordId.value : this.chordId,
      baseFret: data.baseFret.present ? data.baseFret.value : this.baseFret,
      frets: data.frets.present ? data.frets.value : this.frets,
      fingers: data.fingers.present ? data.fingers.value : this.fingers,
      positionIndex: data.positionIndex.present
          ? data.positionIndex.value
          : this.positionIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChordPosition(')
          ..write('id: $id, ')
          ..write('chordId: $chordId, ')
          ..write('baseFret: $baseFret, ')
          ..write('frets: $frets, ')
          ..write('fingers: $fingers, ')
          ..write('positionIndex: $positionIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, chordId, baseFret, frets, fingers, positionIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChordPosition &&
          other.id == this.id &&
          other.chordId == this.chordId &&
          other.baseFret == this.baseFret &&
          other.frets == this.frets &&
          other.fingers == this.fingers &&
          other.positionIndex == this.positionIndex);
}

class ChordPositionsCompanion extends UpdateCompanion<ChordPosition> {
  final Value<int> id;
  final Value<int> chordId;
  final Value<int> baseFret;
  final Value<String> frets;
  final Value<String> fingers;
  final Value<int> positionIndex;
  const ChordPositionsCompanion({
    this.id = const Value.absent(),
    this.chordId = const Value.absent(),
    this.baseFret = const Value.absent(),
    this.frets = const Value.absent(),
    this.fingers = const Value.absent(),
    this.positionIndex = const Value.absent(),
  });
  ChordPositionsCompanion.insert({
    this.id = const Value.absent(),
    required int chordId,
    required int baseFret,
    required String frets,
    required String fingers,
    required int positionIndex,
  }) : chordId = Value(chordId),
       baseFret = Value(baseFret),
       frets = Value(frets),
       fingers = Value(fingers),
       positionIndex = Value(positionIndex);
  static Insertable<ChordPosition> custom({
    Expression<int>? id,
    Expression<int>? chordId,
    Expression<int>? baseFret,
    Expression<String>? frets,
    Expression<String>? fingers,
    Expression<int>? positionIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chordId != null) 'chord_id': chordId,
      if (baseFret != null) 'base_fret': baseFret,
      if (frets != null) 'frets': frets,
      if (fingers != null) 'fingers': fingers,
      if (positionIndex != null) 'position_index': positionIndex,
    });
  }

  ChordPositionsCompanion copyWith({
    Value<int>? id,
    Value<int>? chordId,
    Value<int>? baseFret,
    Value<String>? frets,
    Value<String>? fingers,
    Value<int>? positionIndex,
  }) {
    return ChordPositionsCompanion(
      id: id ?? this.id,
      chordId: chordId ?? this.chordId,
      baseFret: baseFret ?? this.baseFret,
      frets: frets ?? this.frets,
      fingers: fingers ?? this.fingers,
      positionIndex: positionIndex ?? this.positionIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chordId.present) {
      map['chord_id'] = Variable<int>(chordId.value);
    }
    if (baseFret.present) {
      map['base_fret'] = Variable<int>(baseFret.value);
    }
    if (frets.present) {
      map['frets'] = Variable<String>(frets.value);
    }
    if (fingers.present) {
      map['fingers'] = Variable<String>(fingers.value);
    }
    if (positionIndex.present) {
      map['position_index'] = Variable<int>(positionIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChordPositionsCompanion(')
          ..write('id: $id, ')
          ..write('chordId: $chordId, ')
          ..write('baseFret: $baseFret, ')
          ..write('frets: $frets, ')
          ..write('fingers: $fingers, ')
          ..write('positionIndex: $positionIndex')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChordsTable chords = $ChordsTable(this);
  late final $ChordPositionsTable chordPositions = $ChordPositionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [chords, chordPositions];
}

typedef $$ChordsTableCreateCompanionBuilder =
    ChordsCompanion Function({
      Value<int> id,
      required String name,
      required String fullName,
      required String root,
      required String type,
      required String difficulty,
      Value<bool> isBarreChord,
      Value<String?> aliases,
    });
typedef $$ChordsTableUpdateCompanionBuilder =
    ChordsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> fullName,
      Value<String> root,
      Value<String> type,
      Value<String> difficulty,
      Value<bool> isBarreChord,
      Value<String?> aliases,
    });

final class $$ChordsTableReferences
    extends BaseReferences<_$AppDatabase, $ChordsTable, Chord> {
  $$ChordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChordPositionsTable, List<ChordPosition>>
  _chordPositionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chordPositions,
    aliasName: $_aliasNameGenerator(db.chords.id, db.chordPositions.chordId),
  );

  $$ChordPositionsTableProcessedTableManager get chordPositionsRefs {
    final manager = $$ChordPositionsTableTableManager(
      $_db,
      $_db.chordPositions,
    ).filter((f) => f.chordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chordPositionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChordsTableFilterComposer
    extends Composer<_$AppDatabase, $ChordsTable> {
  $$ChordsTableFilterComposer({
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

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get root => $composableBuilder(
    column: $table.root,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBarreChord => $composableBuilder(
    column: $table.isBarreChord,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chordPositionsRefs(
    Expression<bool> Function($$ChordPositionsTableFilterComposer f) f,
  ) {
    final $$ChordPositionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chordPositions,
      getReferencedColumn: (t) => t.chordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChordPositionsTableFilterComposer(
            $db: $db,
            $table: $db.chordPositions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChordsTable> {
  $$ChordsTableOrderingComposer({
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

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get root => $composableBuilder(
    column: $table.root,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBarreChord => $composableBuilder(
    column: $table.isBarreChord,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChordsTable> {
  $$ChordsTableAnnotationComposer({
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

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get root =>
      $composableBuilder(column: $table.root, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBarreChord => $composableBuilder(
    column: $table.isBarreChord,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aliases =>
      $composableBuilder(column: $table.aliases, builder: (column) => column);

  Expression<T> chordPositionsRefs<T extends Object>(
    Expression<T> Function($$ChordPositionsTableAnnotationComposer a) f,
  ) {
    final $$ChordPositionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chordPositions,
      getReferencedColumn: (t) => t.chordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChordPositionsTableAnnotationComposer(
            $db: $db,
            $table: $db.chordPositions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChordsTable,
          Chord,
          $$ChordsTableFilterComposer,
          $$ChordsTableOrderingComposer,
          $$ChordsTableAnnotationComposer,
          $$ChordsTableCreateCompanionBuilder,
          $$ChordsTableUpdateCompanionBuilder,
          (Chord, $$ChordsTableReferences),
          Chord,
          PrefetchHooks Function({bool chordPositionsRefs})
        > {
  $$ChordsTableTableManager(_$AppDatabase db, $ChordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> root = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<bool> isBarreChord = const Value.absent(),
                Value<String?> aliases = const Value.absent(),
              }) => ChordsCompanion(
                id: id,
                name: name,
                fullName: fullName,
                root: root,
                type: type,
                difficulty: difficulty,
                isBarreChord: isBarreChord,
                aliases: aliases,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String fullName,
                required String root,
                required String type,
                required String difficulty,
                Value<bool> isBarreChord = const Value.absent(),
                Value<String?> aliases = const Value.absent(),
              }) => ChordsCompanion.insert(
                id: id,
                name: name,
                fullName: fullName,
                root: root,
                type: type,
                difficulty: difficulty,
                isBarreChord: isBarreChord,
                aliases: aliases,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ChordsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({chordPositionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (chordPositionsRefs) db.chordPositions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chordPositionsRefs)
                    await $_getPrefetchedData<
                      Chord,
                      $ChordsTable,
                      ChordPosition
                    >(
                      currentTable: table,
                      referencedTable: $$ChordsTableReferences
                          ._chordPositionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ChordsTableReferences(
                        db,
                        table,
                        p0,
                      ).chordPositionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.chordId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ChordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChordsTable,
      Chord,
      $$ChordsTableFilterComposer,
      $$ChordsTableOrderingComposer,
      $$ChordsTableAnnotationComposer,
      $$ChordsTableCreateCompanionBuilder,
      $$ChordsTableUpdateCompanionBuilder,
      (Chord, $$ChordsTableReferences),
      Chord,
      PrefetchHooks Function({bool chordPositionsRefs})
    >;
typedef $$ChordPositionsTableCreateCompanionBuilder =
    ChordPositionsCompanion Function({
      Value<int> id,
      required int chordId,
      required int baseFret,
      required String frets,
      required String fingers,
      required int positionIndex,
    });
typedef $$ChordPositionsTableUpdateCompanionBuilder =
    ChordPositionsCompanion Function({
      Value<int> id,
      Value<int> chordId,
      Value<int> baseFret,
      Value<String> frets,
      Value<String> fingers,
      Value<int> positionIndex,
    });

final class $$ChordPositionsTableReferences
    extends BaseReferences<_$AppDatabase, $ChordPositionsTable, ChordPosition> {
  $$ChordPositionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChordsTable _chordIdTable(_$AppDatabase db) => db.chords.createAlias(
    $_aliasNameGenerator(db.chordPositions.chordId, db.chords.id),
  );

  $$ChordsTableProcessedTableManager get chordId {
    final $_column = $_itemColumn<int>('chord_id')!;

    final manager = $$ChordsTableTableManager(
      $_db,
      $_db.chords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChordPositionsTableFilterComposer
    extends Composer<_$AppDatabase, $ChordPositionsTable> {
  $$ChordPositionsTableFilterComposer({
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

  ColumnFilters<int> get baseFret => $composableBuilder(
    column: $table.baseFret,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frets => $composableBuilder(
    column: $table.frets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingers => $composableBuilder(
    column: $table.fingers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positionIndex => $composableBuilder(
    column: $table.positionIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$ChordsTableFilterComposer get chordId {
    final $$ChordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chordId,
      referencedTable: $db.chords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChordsTableFilterComposer(
            $db: $db,
            $table: $db.chords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChordPositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChordPositionsTable> {
  $$ChordPositionsTableOrderingComposer({
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

  ColumnOrderings<int> get baseFret => $composableBuilder(
    column: $table.baseFret,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frets => $composableBuilder(
    column: $table.frets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingers => $composableBuilder(
    column: $table.fingers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positionIndex => $composableBuilder(
    column: $table.positionIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChordsTableOrderingComposer get chordId {
    final $$ChordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chordId,
      referencedTable: $db.chords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChordsTableOrderingComposer(
            $db: $db,
            $table: $db.chords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChordPositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChordPositionsTable> {
  $$ChordPositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get baseFret =>
      $composableBuilder(column: $table.baseFret, builder: (column) => column);

  GeneratedColumn<String> get frets =>
      $composableBuilder(column: $table.frets, builder: (column) => column);

  GeneratedColumn<String> get fingers =>
      $composableBuilder(column: $table.fingers, builder: (column) => column);

  GeneratedColumn<int> get positionIndex => $composableBuilder(
    column: $table.positionIndex,
    builder: (column) => column,
  );

  $$ChordsTableAnnotationComposer get chordId {
    final $$ChordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chordId,
      referencedTable: $db.chords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChordsTableAnnotationComposer(
            $db: $db,
            $table: $db.chords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChordPositionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChordPositionsTable,
          ChordPosition,
          $$ChordPositionsTableFilterComposer,
          $$ChordPositionsTableOrderingComposer,
          $$ChordPositionsTableAnnotationComposer,
          $$ChordPositionsTableCreateCompanionBuilder,
          $$ChordPositionsTableUpdateCompanionBuilder,
          (ChordPosition, $$ChordPositionsTableReferences),
          ChordPosition,
          PrefetchHooks Function({bool chordId})
        > {
  $$ChordPositionsTableTableManager(
    _$AppDatabase db,
    $ChordPositionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChordPositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChordPositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChordPositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> chordId = const Value.absent(),
                Value<int> baseFret = const Value.absent(),
                Value<String> frets = const Value.absent(),
                Value<String> fingers = const Value.absent(),
                Value<int> positionIndex = const Value.absent(),
              }) => ChordPositionsCompanion(
                id: id,
                chordId: chordId,
                baseFret: baseFret,
                frets: frets,
                fingers: fingers,
                positionIndex: positionIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int chordId,
                required int baseFret,
                required String frets,
                required String fingers,
                required int positionIndex,
              }) => ChordPositionsCompanion.insert(
                id: id,
                chordId: chordId,
                baseFret: baseFret,
                frets: frets,
                fingers: fingers,
                positionIndex: positionIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChordPositionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chordId = false}) {
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
                    if (chordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chordId,
                                referencedTable: $$ChordPositionsTableReferences
                                    ._chordIdTable(db),
                                referencedColumn:
                                    $$ChordPositionsTableReferences
                                        ._chordIdTable(db)
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

typedef $$ChordPositionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChordPositionsTable,
      ChordPosition,
      $$ChordPositionsTableFilterComposer,
      $$ChordPositionsTableOrderingComposer,
      $$ChordPositionsTableAnnotationComposer,
      $$ChordPositionsTableCreateCompanionBuilder,
      $$ChordPositionsTableUpdateCompanionBuilder,
      (ChordPosition, $$ChordPositionsTableReferences),
      ChordPosition,
      PrefetchHooks Function({bool chordId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChordsTableTableManager get chords =>
      $$ChordsTableTableManager(_db, _db.chords);
  $$ChordPositionsTableTableManager get chordPositions =>
      $$ChordPositionsTableTableManager(_db, _db.chordPositions);
}
