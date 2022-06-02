CLASS zcl_security_cc_problem_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    "Uses Data Model - https://github.com/SAP-samples/abap-platform-refscen-flight

    TYPES tt_results TYPE STANDARD TABLE OF /dmo/flight WITH EMPTY KEY.

    METHODS select_flights
      IMPORTING i_input         TYPE string
      RETURNING VALUE(r_result) TYPE tt_results
      RAISING   cx_sy_open_sql_data_error.

  PROTECTED SECTION.
  PRIVATE SECTION.
    "Simulate Input Parameters via a constant to keep example UI/Service/Interface agnostic

    "During Input Someone Puts Extra SQL Conditions into the input value - SQL Injection!
    "Remember we are simulating the input here, this normally would come from UI or Service Interface
    CONSTANTS: input TYPE string VALUE `AA' OR CARRIER_ID = 'AZ`.

ENDCLASS.



CLASS zcl_security_cc_problem_2 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    TRY.
        DATA(results) = select_flights( input ).
        out->write( results ).
      CATCH cx_sy_open_sql_data_error INTO DATA(lcx).
        out->write( lcx->get_text(  ) ).
    ENDTRY.

  ENDMETHOD.

  METHOD select_flights.

    DATA(sql) = `CARRIER_ID = ` && cl_abap_dyn_prg=>quote_str( i_input ).
    SELECT * FROM /dmo/flight WHERE (sql) INTO TABLE @r_result.

  ENDMETHOD.

ENDCLASS.
