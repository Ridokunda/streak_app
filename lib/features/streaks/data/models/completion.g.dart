// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCompletionCollection on Isar {
  IsarCollection<Completion> get completions => this.collection();
}

const CompletionSchema = CollectionSchema(
  name: r'Completion',
  id: -5586095416965545486,
  properties: {
    r'completedDate': PropertySchema(
      id: 0,
      name: r'completedDate',
      type: IsarType.dateTime,
    ),
    r'streakId': PropertySchema(
      id: 1,
      name: r'streakId',
      type: IsarType.long,
    ),
    r'usedFreeze': PropertySchema(
      id: 2,
      name: r'usedFreeze',
      type: IsarType.bool,
    )
  },
  estimateSize: _completionEstimateSize,
  serialize: _completionSerialize,
  deserialize: _completionDeserialize,
  deserializeProp: _completionDeserializeProp,
  idName: r'id',
  indexes: {
    r'streakId': IndexSchema(
      id: 3382946778143624669,
      name: r'streakId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'streakId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'completedDate': IndexSchema(
      id: -1824252074580776348,
      name: r'completedDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'completedDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _completionGetId,
  getLinks: _completionGetLinks,
  attach: _completionAttach,
  version: '3.1.0+1',
);

int _completionEstimateSize(
  Completion object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _completionSerialize(
  Completion object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedDate);
  writer.writeLong(offsets[1], object.streakId);
  writer.writeBool(offsets[2], object.usedFreeze);
}

Completion _completionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Completion(
    completedDate: reader.readDateTime(offsets[0]),
    streakId: reader.readLong(offsets[1]),
    usedFreeze: reader.readBoolOrNull(offsets[2]) ?? false,
  );
  object.id = id;
  return object;
}

P _completionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _completionGetId(Completion object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _completionGetLinks(Completion object) {
  return [];
}

void _completionAttach(IsarCollection<dynamic> col, Id id, Completion object) {
  object.id = id;
}

extension CompletionQueryWhereSort
    on QueryBuilder<Completion, Completion, QWhere> {
  QueryBuilder<Completion, Completion, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhere> anyStreakId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'streakId'),
      );
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhere> anyCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'completedDate'),
      );
    });
  }
}

extension CompletionQueryWhere
    on QueryBuilder<Completion, Completion, QWhereClause> {
  QueryBuilder<Completion, Completion, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause> streakIdEqualTo(
      int streakId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'streakId',
        value: [streakId],
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause> streakIdNotEqualTo(
      int streakId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'streakId',
              lower: [],
              upper: [streakId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'streakId',
              lower: [streakId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'streakId',
              lower: [streakId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'streakId',
              lower: [],
              upper: [streakId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause> streakIdGreaterThan(
    int streakId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'streakId',
        lower: [streakId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause> streakIdLessThan(
    int streakId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'streakId',
        lower: [],
        upper: [streakId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause> streakIdBetween(
    int lowerStreakId,
    int upperStreakId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'streakId',
        lower: [lowerStreakId],
        includeLower: includeLower,
        upper: [upperStreakId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause> completedDateEqualTo(
      DateTime completedDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completedDate',
        value: [completedDate],
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause>
      completedDateNotEqualTo(DateTime completedDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedDate',
              lower: [],
              upper: [completedDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedDate',
              lower: [completedDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedDate',
              lower: [completedDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedDate',
              lower: [],
              upper: [completedDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause>
      completedDateGreaterThan(
    DateTime completedDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedDate',
        lower: [completedDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause> completedDateLessThan(
    DateTime completedDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedDate',
        lower: [],
        upper: [completedDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterWhereClause> completedDateBetween(
    DateTime lowerCompletedDate,
    DateTime upperCompletedDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedDate',
        lower: [lowerCompletedDate],
        includeLower: includeLower,
        upper: [upperCompletedDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CompletionQueryFilter
    on QueryBuilder<Completion, Completion, QFilterCondition> {
  QueryBuilder<Completion, Completion, QAfterFilterCondition>
      completedDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterFilterCondition>
      completedDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterFilterCondition>
      completedDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterFilterCondition>
      completedDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterFilterCondition> streakIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'streakId',
        value: value,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterFilterCondition>
      streakIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'streakId',
        value: value,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterFilterCondition> streakIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'streakId',
        value: value,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterFilterCondition> streakIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'streakId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Completion, Completion, QAfterFilterCondition> usedFreezeEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'usedFreeze',
        value: value,
      ));
    });
  }
}

extension CompletionQueryObject
    on QueryBuilder<Completion, Completion, QFilterCondition> {}

extension CompletionQueryLinks
    on QueryBuilder<Completion, Completion, QFilterCondition> {}

extension CompletionQuerySortBy
    on QueryBuilder<Completion, Completion, QSortBy> {
  QueryBuilder<Completion, Completion, QAfterSortBy> sortByCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedDate', Sort.asc);
    });
  }

  QueryBuilder<Completion, Completion, QAfterSortBy> sortByCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedDate', Sort.desc);
    });
  }

  QueryBuilder<Completion, Completion, QAfterSortBy> sortByStreakId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakId', Sort.asc);
    });
  }

  QueryBuilder<Completion, Completion, QAfterSortBy> sortByStreakIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakId', Sort.desc);
    });
  }

  QueryBuilder<Completion, Completion, QAfterSortBy> sortByUsedFreeze() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedFreeze', Sort.asc);
    });
  }

  QueryBuilder<Completion, Completion, QAfterSortBy> sortByUsedFreezeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedFreeze', Sort.desc);
    });
  }
}

extension CompletionQuerySortThenBy
    on QueryBuilder<Completion, Completion, QSortThenBy> {
  QueryBuilder<Completion, Completion, QAfterSortBy> thenByCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedDate', Sort.asc);
    });
  }

  QueryBuilder<Completion, Completion, QAfterSortBy> thenByCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedDate', Sort.desc);
    });
  }

  QueryBuilder<Completion, Completion, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Completion, Completion, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Completion, Completion, QAfterSortBy> thenByStreakId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakId', Sort.asc);
    });
  }

  QueryBuilder<Completion, Completion, QAfterSortBy> thenByStreakIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakId', Sort.desc);
    });
  }

  QueryBuilder<Completion, Completion, QAfterSortBy> thenByUsedFreeze() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedFreeze', Sort.asc);
    });
  }

  QueryBuilder<Completion, Completion, QAfterSortBy> thenByUsedFreezeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedFreeze', Sort.desc);
    });
  }
}

extension CompletionQueryWhereDistinct
    on QueryBuilder<Completion, Completion, QDistinct> {
  QueryBuilder<Completion, Completion, QDistinct> distinctByCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedDate');
    });
  }

  QueryBuilder<Completion, Completion, QDistinct> distinctByStreakId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streakId');
    });
  }

  QueryBuilder<Completion, Completion, QDistinct> distinctByUsedFreeze() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'usedFreeze');
    });
  }
}

extension CompletionQueryProperty
    on QueryBuilder<Completion, Completion, QQueryProperty> {
  QueryBuilder<Completion, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Completion, DateTime, QQueryOperations> completedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedDate');
    });
  }

  QueryBuilder<Completion, int, QQueryOperations> streakIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streakId');
    });
  }

  QueryBuilder<Completion, bool, QQueryOperations> usedFreezeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'usedFreeze');
    });
  }
}
