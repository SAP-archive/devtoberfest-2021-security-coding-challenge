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
ENDCLASS.



CLASS zcl_security_cc_problem_3 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    CONSTANTS object_category_total_object TYPE string VALUE `R3TR` ##NO_TEXT.
    CONSTANTS object_type_database_table TYPE string VALUE `TABL` ##NO_TEXT.
    CONSTANTS object_type_class TYPE string VALUE `CLAS` ##NO_TEXT.
    CONSTANTS class_prefix_for_classdescr TYPE string VALUE `\CLASS=` ##NO_TEXT.

    DATA dref TYPE REF TO data.
    FIELD-SYMBOLS <results> TYPE STANDARD TABLE.
    CREATE DATA dref TYPE STANDARD TABLE OF (dbTable)
                     WITH EMPTY KEY.
    ASSIGN dref->* TO <results>.

    "Get the current class name and check this classes package if dbTable exits in this package
    DATA(current_class_name) = substring_after( val = cl_abap_classdescr=>get_class_name( me )
                                                sub = class_prefix_for_classdescr ).
    SELECT SINGLE @abap_true
      FROM I_CustABAPObjDirectoryEntry
      WHERE ABAPObjectCategory = @object_category_total_object
        AND ABAPObjectType     = @object_type_database_table
        AND ABAPObject         = @dbTable
        AND ABAPPackage        = ( SELECT ABAPpackage
                                     FROM I_CustABAPObjDirectoryEntry
                                     WHERE ABAPObjectCategory = @object_category_total_object
                                       AND abapobjecttype     = @object_type_class
                                       AND abapobject         = @current_class_name )
        INTO @DATA(tab_exists_in_current_package).
    IF tab_exists_in_current_package = abap_false.
      out->write( |Table { dbTable } doesn't exist in current package| ).
      RETURN.
    ENDIF.

    "Do you really want every table to be accessible? Yet it needs to be dynamic and support all tables within your Package
    SELECT * FROM (dbTable) INTO TABLE @<results> UP TO 100 ROWS.
    out->write( |Data for table: { dbTable }| ).
    out->write( <results> ).
  ENDMETHOD.
ENDCLASS.
