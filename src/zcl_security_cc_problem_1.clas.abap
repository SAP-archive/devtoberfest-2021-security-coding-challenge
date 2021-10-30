CLASS zcl_security_cc_problem_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    "Uses Data Model - https://github.com/SAP-samples/abap-platform-refscen-flight

  PRIVATE SECTION.
    TYPES tt_results TYPE STANDARD TABLE OF /dmo/flight WITH EMPTY KEY.

    "Simulate Input Parameters via a constant to keep example UI/Service/Interface agnostic
    CONSTANTS: carrierId TYPE /dmo/carrier_id VALUE 'AA'.
    CONSTANTS: connectionId TYPE /dmo/connection_id VALUE '0322' .

    "During Input Someone Puts Extra SQL Conditions into the input value - SQL Injection!
    "Remember we are simulating the input here, this normally would come from UI or Service Interface
    CONSTANTS: seatsMax TYPE string VALUE `142', PRICE = '1`.

    METHODS select_flights
      IMPORTING i_carrierId     TYPE /dmo/carrier_id
                i_connectionId  TYPE /dmo/connection_id
      RETURNING VALUE(r_result) TYPE tt_results.

    METHODS update_flights
      IMPORTING i_carrierId    TYPE /dmo/carrier_id
                i_connectionId TYPE /dmo/connection_id
                i_seatsMax     TYPE string
      RAISING   cx_abap_not_an_integer.

ENDCLASS.

CLASS zcl_security_cc_problem_1 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(flights) = select_flights(
                      i_carrierId    = carrierId
                      i_connectionId = connectionId ).

    out->write( flights ).

    TRY.
        update_flights(
          i_carrierid    = carrierId
          i_connectionid = connectionId
          i_seatsmax     = seatsMax ).

        "Check the data afterwards
        flights = select_flights(
                    i_carrierId    = carrierId
                    i_connectionId = connectionId ).

        out->write( flights ).

      CATCH cx_abap_not_an_integer INTO DATA(lcx).
        out->write( lcx->get_text( ) ).

    ENDTRY.

  ENDMETHOD.

  METHOD select_flights.

    "Check that you have data that matches your input
    SELECT * FROM /dmo/flight
      WHERE carrier_id = @i_carrierId
      AND connection_id = @i_connectionId
      INTO TABLE @r_result.

  ENDMETHOD.

  METHOD update_flights.

    DATA(dynamicUpdate) = |SEATS_MAX = '{ cl_abap_dyn_prg=>check_int_value( i_seatsMax ) }'|.

    UPDATE /dmo/flight
      SET (dynamicUpdate)
      WHERE carrier_id = @i_carrierId
      AND connection_id = @i_connectionId.

  ENDMETHOD.

ENDCLASS.
