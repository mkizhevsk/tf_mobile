// api
const String apiLogin = "login";
const String apiPassword = "password";
const String apiUrl = "https://wordnest.online";

// Database column types
const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textTypeNullable = "TEXT";
const String textType = "TEXT NOT NULL";
const String intTypeNullable = "INTEGER";
const String boolType = "BOOLEAN NOT NULL";

// Card table constants
const String cardTableName = "card";
const String cardIdField = "id";
const String cardInternalCodeField = "internal_code";
const String cardEditDateTimeField = "edit_date_time";
const String cardFrontField = "front";
const String cardBackField = "back";
const String cardExampleField = "example";
const String cardStatusField = "status";

// Token table constants
const String tokenTableName = "token";
const String tokenIdField = "id";
const String accessTokenField = "access_token";
const String refreshTokenField = "refresh_token";
const String tokenTypeField = "token_type";
const String expiryDateField = "expiry_date";

const int cardIsNotLearned = 0;
const int cardIsLearned = 1;
