"* use this source file for your ABAP unit test classes
CLASS ltcl_test_problem_3 DEFINITION DEFERRED.
CLASS zcl_security_cc_problem_3 DEFINITION
  LOCAL FRIENDS ltcl_test_problem_3.

CLASS ltcl_test_problem_3 DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    TYPES tt_flights TYPE STANDARD TABLE OF /dmo/flight WITH EMPTY KEY.
    DATA cut TYPE REF TO zcl_security_cc_problem_3.

    CLASS-DATA osql TYPE REF TO if_osql_test_environment.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS test_select_valid_input FOR TESTING RAISING cx_static_check.
    METHODS test_select_invalid_input FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_test_problem_3 IMPLEMENTATION.

  METHOD test_select_valid_input.

    FIELD-SYMBOLS <results> TYPE STANDARD TABLE.

    TRY.
        DATA(content) = cut->select_table_content( '/DMO/FLIGHT' ).
        ASSIGN content->* TO <results>.

        cl_abap_unit_assert=>assert_equals(
          act = <results>
          exp = VALUE tt_flights(
                  ( client ='001' carrier_id ='AA' connection_id ='0018' flight_date ='20191122' price ='3823.00 ' currency_code ='USD' plane_type_id ='767-200' seats_max ='260' seats_occupied ='247'  )
                  ( client ='001' carrier_id ='AZ' connection_id ='0788' flight_date ='20200919' price ='7580.00 ' currency_code ='EUR' plane_type_id ='767-200' seats_max ='260' seats_occupied ='221'  )
                )
        ).

      CATCH cx_abap_not_a_table
            cx_abap_not_in_package INTO DATA(lcx).
        cl_abap_unit_assert=>fail( lcx->get_text( ) ) ##no_text.
    ENDTRY.

  ENDMETHOD.

  METHOD test_select_invalid_input.

    TRY.
        cut->select_table_content( 'xxx' ).

      CATCH cx_abap_not_a_table
            cx_abap_not_in_package INTO DATA(lcx).

        cl_abap_unit_assert=>assert_equals(
          act = lcx->get_text( )
          exp = 'The value xxx is not the name of a database table.' ) ##no_text.

    ENDTRY.

  ENDMETHOD.

  METHOD class_setup.

    osql = cl_osql_test_environment=>create( VALUE #( ( '/DMO/FLIGHT' ) ) ).
    DATA(flights) = VALUE tt_flights(
       ( client ='001' carrier_id ='AA' connection_id ='0018' flight_date ='20191122' price ='3823.00 ' currency_code ='USD' plane_type_id ='767-200' seats_max ='260' seats_occupied ='247'  )
       ( client ='001' carrier_id ='AZ' connection_id ='0788' flight_date ='20200919' price ='7580.00 ' currency_code ='EUR' plane_type_id ='767-200' seats_max ='260' seats_occupied ='221'  )
    ).

    osql->insert_test_data( flights ).

  ENDMETHOD.

  METHOD class_teardown.
    osql->destroy( ).
  ENDMETHOD.

  METHOD setup.
    cut = NEW #( ).
  ENDMETHOD.

ENDCLASS.
