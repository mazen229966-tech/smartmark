class DbSchema {
  static const dbName = 'smartmark.db';
  static const dbVersion = 1;

  static const tablePlans = 'marketing_plans';

  static const colId = 'id';
  static const colBusinessName = 'businessName';
  static const colCategory = 'category';
  static const colGoal = 'goal';
  static const colPlatform = 'platform';
  static const colAudience = 'audience';
  static const colBudgetLevel = 'budgetLevel';
  static const colBrandImagePath = 'brandImagePath';
  static const colPlanJson = 'planJson';
  static const colCreatedAt = 'createdAt';

  static const createPlansTable = '''
  CREATE TABLE $tablePlans(
    $colId INTEGER PRIMARY KEY AUTOINCREMENT,
    $colBusinessName TEXT NOT NULL,
    $colCategory TEXT NOT NULL,
    $colGoal TEXT NOT NULL,
    $colPlatform TEXT NOT NULL,
    $colAudience TEXT NOT NULL,
    $colBudgetLevel TEXT NOT NULL,
    $colBrandImagePath TEXT,
    $colPlanJson TEXT NOT NULL,
    $colCreatedAt TEXT NOT NULL
  )
  ''';
}
