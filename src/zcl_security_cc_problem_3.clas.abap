CLASS zcl_security_cc_problem_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    "Uses Data Model - https://github.com/SAP-samples/abap-platform-refscen-flight
  PROTECTED SECTION.
  PRIVATE SECTION.
    "Simulate Input Parameters via a constant to keep example UI/Service/Interface agnostic
    CONSTANTS: dbTable TYPE string VALUE '/DMO/FLIGHT'.

ENDCLASS.



CLASS zcl_security_cc_problem_3 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA dref TYPE REF TO data.
    FIELD-SYMBOLS <results> TYPE STANDARD TABLE.

    "Do you really want every table to be accessible? Yet it needs to be dynamic and support all tables within your Package
    TRY.
        DATA(flightTableName) = cl_abap_dyn_prg=>check_table_or_view_name_str( val      = dbTable
                                                                               packages = '/DMO/FLIGHT_LEGACY' ).

        CREATE DATA dref TYPE STANDARD TABLE OF (flightTableName)
                         WITH EMPTY KEY.
        ASSIGN dref->* TO <results>.

        SELECT * FROM (flightTableName) INTO TABLE @<results> UP TO 100 ROWS.

        out->write( |Data for table: { dbTable }| ).
        out->write( <results> ).

      CATCH cx_abap_not_a_table cx_abap_not_in_package.
        out->write( |Nice try ;)| ).
      CATCH cx_sy_dynamic_osql_syntax.
        out->write( |Stupid me| ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
