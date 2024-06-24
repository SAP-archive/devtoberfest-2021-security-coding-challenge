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
    CONSTANTS: carrierId TYPE /dmo/carrier_id VALUE 'AA'.
    CONSTANTS: connectionId TYPE /dmo/connection_id VALUE '0322' .

    "During Input Someone Puts Extra SQL Conditions into the input value - SQL Injection!
    "Remember we are simulating the input here, this normally would come from UI or Service Interface
    CONSTANTS: seatsMax TYPE string VALUE `142', PRICE = '1`.

ENDCLASS.



CLASS zcl_security_cc_problem_1 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    TRY.
        " Check that you have data that matches your input

        " For reading - we could validate allowed input using own rules
        " some_validator->validate_input( ... ) etc.

        " Check authorization(s) etc.
        " AUTHORITY-CHECK OBJECT 'S_CARRID'
        "   ID 'CARRID' FIELD carrierId
        "   ID 'ACTVT'  FIELD '03'.

        " or use whitelists
        " cl_abap_dyn_prg=>check_whitelist_tab( val = carrierId
        "                                       whitelist = ...whitelisted input carriers ).

        SELECT * FROM /dmo/flight
          WHERE carrier_id = @carrierId
            AND connection_id = @connectionId
                INTO TABLE @DATA(flights).

        out->write( flights ).

        " Here for seats_max only update int-check would be enough
        cl_abap_dyn_prg=>check_int_value( seatsmax ).
        DATA(dynamicUpdate) = |SEATS_MAX = '{ seatsMax }'|.

        " ...or quote
        " DATA(dynamicUpdate) = |SEATS_MAX = { cl_abap_dyn_prg=>quote( seatsMax ) }|.

        " or use dynamic variable
        " DATA(dynamicUpdate) = `SEATS_MAX = @seatsMax`.

        " AUTHORITY-CHECK OBJECT '...'
        "   ID 'CARRID' FIELD ...
        "   ID 'ACTVT'  FIELD '02'.

        UPDATE /dmo/flight
             SET (dynamicUpdate)
           WHERE carrier_id = @carrierId
                AND connection_id = @connectionId.

        " Check the data afterwards
        SELECT * FROM /dmo/flight
          WHERE carrier_id = @carrierId
            AND connection_id = @connectionId
            INTO TABLE @flights.

        out->write( flights ).

      CATCH cx_abap_not_an_integer INTO DATA(exception).
        out->write( exception->get_text( ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
