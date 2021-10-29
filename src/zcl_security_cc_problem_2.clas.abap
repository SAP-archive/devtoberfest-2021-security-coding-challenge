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
    " get all valid carriers and check agaunst them as a white list
    DATA allCarriers TYPE HASHED TABLE OF string WITH UNIQUE KEY table_line.
    SELECT carrier_id FROM /dmo/carrier INTO TABLE @allCarriers.

    TRY.
        DATA(sql) = |CARRIER_ID = '{  cl_abap_dyn_prg=>check_whitelist_tab( val = input whitelist = allCarriers ) }'|.
        SELECT * FROM /dmo/flight WHERE (sql) INTO TABLE @DATA(results).
        IF sy-subrc = 0.
          out->write( results ).
        ELSE.
          out->write( |No entries found for carrier: { cl_abap_dyn_prg=>escape_quotes( input ) }| ).
        ENDIF.
      CATCH cx_abap_not_in_whitelist INTO DATA(lx_exception).
        "handle exception
        out->write( |error: { lx_exception->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
