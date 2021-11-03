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
    CONSTANTS: mainPackage TYPE devclass VALUE `/DMO/FLIGHT`.

    METHODS check_package
      IMPORTING
        input TYPE string
      RAISING
        lcx_foreign_package.

    METHODS read_inherit_packages
      IMPORTING
        input         TYPE devclass
      RETURNING
        VALUE(result) TYPE tab_packages.

ENDCLASS.



CLASS zcl_security_cc_problem_3 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA dref TYPE REF TO data.
    FIELD-SYMBOLS <results> TYPE STANDARD TABLE.

    TRY.
        check_package( dbtable ).
      CATCH lcx_foreign_package.
        out->write( |Table { dbTable } not allowed.| ).
        RETURN.
    ENDTRY.

    CREATE DATA dref TYPE STANDARD TABLE OF (dbTable)
                     WITH EMPTY KEY.
    ASSIGN dref->* TO <results>.

    "Do you really want every table to be accessible? Yet it needs to be dynamic and support all tables within your Package
    SELECT * FROM (dbTable) INTO TABLE @<results> UP TO 100 ROWS.
    out->write( |Data for table: { dbTable }| ).
    out->write( <results> ).

  ENDMETHOD.


  METHOD check_package.

    SELECT SINGLE devclass
      FROM tadir
      WHERE pgmid = `R3TR` AND object = `TABL` AND obj_name = @input
      INTO  @DATA(tablePackage).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE lcx_foreign_package.
    ELSEIF tablePackage = mainPackage.
      RETURN.
    ENDIF.

    DATA(packages) = read_inherit_packages( mainPackage ).

    IF NOT line_exists( packages[ table_line = tablePackage ] ).
      RAISE EXCEPTION TYPE lcx_foreign_package.
    ENDIF.

  ENDMETHOD.


  METHOD read_inherit_packages.

    SELECT devclass
      FROM tdevc
      WHERE parentcl = @input
      INTO TABLE @DATA(packages).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    result =
        VALUE #(
            FOR package IN packages
            ( LINES OF VALUE #( ( package-devclass ) ( LINES OF read_inherit_packages( package-devclass ) ) ) ) ).

  ENDMETHOD.


ENDCLASS.
