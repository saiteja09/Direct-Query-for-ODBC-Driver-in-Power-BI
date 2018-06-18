// This file contains your Data Connector logic
section DataDirectODBC;

[DataSource.Kind="DataDirectODBC", Publish="DataDirectODBC.Publish"]
shared DataDirectODBC.Databases = (dsn as text) as table =>
      let
        ConnectionString = [
            Dsn = dsn
        ],
        Credential = Extension.CurrentCredential(),
        CredentialConnectionString =
            if (Credential[AuthenticationKind]?) = "UsernamePassword" then 
                [ UID = Credential[Username], PWD = Credential[Password] ]
            else if (Credential[AuthenticationKind]?) = "Windows" then
                [ Trusted_Connection="Yes" ]
            else
                ..., 
        OdbcDatasource = Odbc.DataSource(ConnectionString, [
            HierarchicalNavigation = true,
            TolerateConcatOverflow = true,
            SqlCapabilities = [
                SupportsTop = true,
                Sql92Conformance = 8,
                GroupByCapabilities = 4 /* SQL_GB_NO_RELATION */,
                SupportsNumericLiterals = true,
                SupportsStringLiterals = true,
                SupportsOdbcDateLiterals = true,
                SupportsOdbcTimeLiterals = true,
                SupportsOdbcTimestampLiterals = true
            ],
            SQLGetFunctions = [
                // Disable using parameters in the queries that get generated.
                // We enable numeric and string literals which should enable literals for all constants.
                SQL_API_SQLBINDPARAMETER = false
            ]
        ])
        in
            OdbcDatasource;

// Data Source Kind description
DataDirectODBC = [
    Authentication = [
        Windows = [],
        UsernamePassword = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
DataDirectODBC.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = DataDirectODBC.Icons,
    SourceTypeImage = DataDirectODBC.Icons,
    SupportsDirectQuery = true
];

DataDirectODBC.Icons = [
    Icon16 = { Extension.Contents("DataDirectODBC16.png"), Extension.Contents("DataDirectODBC20.png"), Extension.Contents("DataDirectODBC24.png"), Extension.Contents("DataDirectODBC32.png") },
    Icon32 = { Extension.Contents("DataDirectODBC32.png"), Extension.Contents("DataDirectODBC40.png"), Extension.Contents("DataDirectODBC48.png"), Extension.Contents("DataDirectODBC64.png") }
];