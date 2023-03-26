-- =============================================
-- SaveToDB Framework for PostgreSQL
-- Version 10.8, January 9, 2023
--
-- This script updates SaveToDB Framework 10 to the latest version
--
-- Copyright 2015-2023 Gartle LLC
--
-- License: MIT
-- =============================================

SELECT CASE WHEN 1008 <= cast(substr(handler_code, 1, strpos(handler_code, '.') - 1) AS int) * 100 + cast(substr(handler_code, strpos(handler_code, '.') + 1) AS decimal) THEN 'SaveToDB Framework is up-to-date. Update skipped' ELSE '' END AS check_version FROM xls.handlers WHERE table_schema = 'xls' AND table_name = 'savetodb_framework' AND column_name = 'version' AND event_name = 'Information' LIMIT 1;

DELETE FROM xls.handlers WHERE table_schema = 'xls' AND table_name = 'users' AND handler_name = 'xl_actions_set_role_permissions';

UPDATE xls.handlers t
SET
    handler_code = s.handler_code
    , target_worksheet = s.target_worksheet
    , menu_order = s.menu_order
    , edit_parameters = s.edit_parameters
FROM
    (
    SELECT
        NULL AS table_schema
        , NULL AS table_name
        , NULL AS column_name
        , NULL AS event_name
        , NULL AS handler_schema
        , NULL AS handler_name
        , NULL AS handler_type
        , NULL AS handler_code
        , NULL AS target_worksheet
        , CAST(NULL AS integer) AS menu_order
        , CAST(NULL AS boolean) AS edit_parameters

    UNION ALL SELECT 'xls', 'savetodb_framework', 'version', 'Information', NULL, NULL, 'ATTRIBUTE', '10.8', NULL, NULL, NULL
    UNION ALL SELECT 'xls', 'handlers', 'event_name', 'ValidationList', NULL, NULL, 'VALUES', 'Actions, AddHyperlinks, AddStateColumn, Authentication, BitColumn, Change, ContextMenu, ConvertFormulas, DataTypeBit, DataTypeBoolean, DataTypeDate, DataTypeDateTime, DataTypeDateTimeOffset, DataTypeDouble, DataTypeInt, DataTypeGuid, DataTypeString, DataTypeTime, DataTypeTimeSpan, DefaultListObject, DefaultValue, DependsOn, DoNotAddChangeHandler, DoNotAddDependsOn, DoNotAddManyToMany, DoNotAddValidation, DoNotChange, DoNotConvertFormulas, DoNotKeepComments, DoNotKeepFormulas, DoNotSave, DoNotSelect, DoNotSort, DoNotTranslate, DoubleClick, DynamicColumns, Format, Formula, FormulaValue, Information, JsonForm, KeepFormulas, KeepComments, License, LoadFormat, ManyToMany, ParameterValues, ProtectRows, RegEx, SaveFormat, SaveWithoutTransaction, SelectionChange, SelectionList, SelectPeriod, SyncParameter, UpdateChangedCellsOnly, UpdateEntireRow, ValidationList', NULL, NULL, NULL

    ) s
WHERE
    s.table_name IS NOT NULL
    AND t.table_schema = s.table_schema
    AND t.table_name = s.table_name
    AND COALESCE(t.column_name, '') = COALESCE(s.column_name, '')
    AND t.event_name = s.event_name
    AND COALESCE(t.handler_schema, '') = COALESCE(s.handler_schema, '')
    AND COALESCE(t.handler_name, '') = COALESCE(s.handler_name, '')
    AND COALESCE(t.handler_type, '') = COALESCE(s.handler_type, '')
    AND (
    NOT COALESCE(t.handler_code, '') = COALESCE(s.handler_code, '')
    OR NOT COALESCE(t.target_worksheet, '') = COALESCE(s.target_worksheet, '')
    OR NOT COALESCE(t.menu_order, -1) = COALESCE(s.menu_order, -1)
    OR NOT COALESCE(t.edit_parameters, false) = COALESCE(s.edit_parameters, false)
    );

INSERT INTO xls.handlers
    ( table_schema
    , table_name
    , column_name
    , event_name
    , handler_schema
    , handler_name
    , handler_type
    , handler_code
    , target_worksheet
    , menu_order
    , edit_parameters
    )
SELECT
    s.table_schema
    , s.table_name
    , s.column_name
    , s.event_name
    , s.handler_schema
    , s.handler_name
    , s.handler_type
    , s.handler_code
    , s.target_worksheet
    , s.menu_order
    , s.edit_parameters
FROM
    (
    SELECT
        NULL AS table_schema
        , NULL AS table_name
        , NULL AS column_name
        , NULL AS event_name
        , NULL AS handler_schema
        , NULL AS handler_name
        , NULL AS handler_type
        , NULL AS handler_code
        , NULL AS target_worksheet
        , CAST(NULL AS integer) AS menu_order
        , CAST(NULL AS boolean) AS edit_parameters

    UNION ALL SELECT 'xls', 'savetodb_framework', 'version', 'Information', NULL, NULL, 'ATTRIBUTE', '10.8', NULL, NULL, NULL
    UNION ALL SELECT 'xls', 'handlers', 'event_name', 'ValidationList', NULL, NULL, 'VALUES', 'Actions, AddHyperlinks, AddStateColumn, Authentication, BitColumn, Change, ContextMenu, ConvertFormulas, DataTypeBit, DataTypeBoolean, DataTypeDate, DataTypeDateTime, DataTypeDateTimeOffset, DataTypeDouble, DataTypeInt, DataTypeGuid, DataTypeString, DataTypeTime, DataTypeTimeSpan, DefaultListObject, DefaultValue, DependsOn, DoNotAddChangeHandler, DoNotAddDependsOn, DoNotAddManyToMany, DoNotAddValidation, DoNotChange, DoNotConvertFormulas, DoNotKeepComments, DoNotKeepFormulas, DoNotSave, DoNotSelect, DoNotSort, DoNotTranslate, DoubleClick, DynamicColumns, Format, Formula, FormulaValue, Information, JsonForm, KeepFormulas, KeepComments, License, LoadFormat, ManyToMany, ParameterValues, ProtectRows, RegEx, SaveFormat, SaveWithoutTransaction, SelectionChange, SelectionList, SelectPeriod, SyncParameter, UpdateChangedCellsOnly, UpdateEntireRow, ValidationList', NULL, NULL, NULL

    ) s
    LEFT OUTER JOIN xls.handlers t ON
        t.table_schema = s.table_schema
        AND t.table_name = s.table_name
        AND COALESCE(t.column_name, '') = COALESCE(s.column_name, '')
        AND t.event_name = s.event_name
        AND COALESCE(t.handler_schema, '') = COALESCE(s.handler_schema, '')
        AND COALESCE(t.handler_name, '') = COALESCE(s.handler_name, '')
        AND COALESCE(t.handler_type, '') = COALESCE(s.handler_type, '')
WHERE
    t.table_name IS NULL
    AND s.table_name IS NOT NULL;

CREATE OR REPLACE FUNCTION xls.xl_actions_set_role_permissions (
    )
    RETURNS void
    LANGUAGE plpgsql
AS $$
BEGIN

GRANT USAGE ON SCHEMA xls TO xls_users;
GRANT USAGE ON SCHEMA xls TO xls_formats;
GRANT USAGE ON SCHEMA xls TO xls_developers;

GRANT SELECT ON xls.columns             TO xls_users;
GRANT SELECT ON xls.formats             TO xls_users;
GRANT SELECT ON xls.handlers            TO xls_users;
GRANT SELECT ON xls.objects             TO xls_users;
GRANT SELECT ON xls.translations        TO xls_users;
GRANT SELECT ON xls.workbooks           TO xls_users;
GRANT SELECT ON xls.queries             TO xls_users;

GRANT SELECT, INSERT, UPDATE, DELETE ON xls.formats TO xls_formats;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA xls TO xls_formats;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE xls.columns       TO xls_developers;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE xls.objects       TO xls_developers;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE xls.handlers      TO xls_developers;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE xls.translations  TO xls_developers;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE xls.formats       TO xls_developers;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE xls.workbooks     TO xls_developers;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE xls.queries       TO xls_developers;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA xls TO xls_developers;

GRANT SELECT ON xls.users TO xls_developers;

GRANT EXECUTE ON FUNCTION xls.xl_actions_set_role_permissions   TO xls_developers;

END
$$;

-- print SaveToDB Framework updated
