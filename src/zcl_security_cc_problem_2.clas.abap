CLASS zcl_security_cc_problem_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    "Uses Data Model - https://github.com/SAP-samples/abap-platform-refscen-flight
  PROTECTED SECTION.
  PRIVATE SECTION.
    "Simulate Input Parameters via a constant to keep example UI/Service/Interface agnostic

    "During Input Someone Puts Extra SQL Conditions into the input value - SQL Injection!
    "Remember we are simulating the input here, this normally would come from UI or Service Interface
    CONSTANTS: input TYPE string VALUE `AA' OR CARRIER_ID = 'AZ`.
ENDCLASS.



CLASS zcl_security_cc_problem_2 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(carrierId) = cl_abap_dyn_prg=>escape_quotes( input ).
    DATA(sql) = `CARRIER_ID = '` && carrierId && `'`.

    TRY.
        SELECT * FROM /dmo/flight WHERE (sql) INTO TABLE @DATA(results).
      CATCH cx_sy_open_sql_data_error.
        out->write( |Nice try ;)| ).
      CATCH cx_sy_dynamic_osql_syntax.
        out->write( |Stupid me| ).
    ENDTRY.
    out->write( results ).
  ENDMETHOD.
ENDCLASS.
