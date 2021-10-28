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
    CONSTANTS: seatsmax TYPE string VALUE `142', PRICE = '1`.


ENDCLASS.



CLASS zcl_security_cc_problem_1 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "Check that you have data that matches your input
    SELECT * FROM /dmo/flight
      WHERE carrier_id = @carrierid
        AND connection_id = @connectionid
            INTO TABLE @DATA(flights).
    IF sy-subrc = 0.
      out->write( flights ).
      TRY.
          DATA root TYPE REF TO cx_root.
          DATA(dynamicupdate) = |SEATS_MAX = { cl_abap_dyn_prg=>quote( seatsmax ) }|. " see SAP Note 1520356
          UPDATE /dmo/flight
            SET (dynamicupdate)
            WHERE carrier_id = @carrierid
                AND connection_id = @connectionid.
          IF sy-subrc = 0.
            out->write( 'Successfully updated flight' ).
          ELSE.
            out->write( 'Failed to update flight' ).

      "Check the data afterwards
            SELECT * FROM /dmo/flight
        WHERE carrier_id = @carrierid
          AND connection_id = @connectionid
          INTO TABLE @flights.
            IF sy-subrc = 0.
              out->write( flights ).
        CATCH cx_sy_dynamic_osql_syntax cx_root INTO lx_root.
          out->write( lx_root ).
          out->write( |Internal error| ).
        ENDIF.
      ENDTRY.
    ENDIF.
  ENDMETHOD.
ENDCLASS.