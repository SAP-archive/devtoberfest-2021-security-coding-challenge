CLASS zcl_security_cc_problem_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    "Uses Data Model - https://github.com/SAP-samples/abap-platform-refscen-flight
  PROTECTED SECTION.
  PRIVATE SECTION.
    "Simulate Input Parameters via a constant to keep example UI/Service/Interface agnostic
    CONSTANTS: carrierid TYPE /dmo/carrier_id VALUE 'AA'.
    CONSTANTS: connectionid TYPE /dmo/connection_id VALUE '0322' .

    "During Input Someone Puts Extra SQL Conditions into the input value - SQL Injection!
    "Remember we are simulating the input here, this normally would come from UI or Service Interface
    CONSTANTS: seatsMax TYPE string VALUE `142'.


ENDCLASS.



CLASS zcl_security_cc_problem_1 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "Check that you have data that matches your input
  
    TRY.
        SELECT * FROM /dmo/flight
      WHERE carrier_id = @carrierid
        AND connection_id = @connectionid
            INTO TABLE @DATA(flights).
        out->write( flights ).
      CATCH cx_sy_dynamic_osql_syntax.
        cl_demo_output=>display( 'Wrong input' ).
    ENDTRY.

    DATA(dynamicupdate) =  'SEATS_MAX = ' &&  cl_abap_dyn_prg=>quote( seatsmax }.
    TRY.
        UPDATE /dmo/flight
         SET (dynamicupdate)
       WHERE carrier_id = @carrierid
            AND connection_id = @connectionid.
      CATCH cx_sy_dynamic_osql_syntax.
        cl_demo_output=>display( 'Wrong input' ).
    ENDTRY.

    "Check the data afterwards
    SELECT * FROM /dmo/flight
      WHERE carrier_id = @carrierid
        AND connection_id = @connectionid
        INTO TABLE @flights.
    out->write( flights ).

  ENDMETHOD.
ENDCLASS.