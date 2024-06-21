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
    CONSTANTS: input TYPE string VALUE `AA'.
    
ENDCLASS.



CLASS zcl_security_cc_problem_2 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    
    TRY.
        DATA(sql) = `CARRIER_ID = @input'.
        SELECT * FROM /dmo/flight WHERE (sql) INTO TABLE @DATA(results).
        out->write( results ).
      CATCH cx_sy_dynamic_osql_syntax.
        cl_demo_output=>display( 'Wrong input' ).
    ENDTRY.


  ENDMETHOD.
ENDCLASS.