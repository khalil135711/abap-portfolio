*&---------------------------------------------------------------------*
*& Report ZJR_BASICS_DEMO
*&---------------------------------------------------------------------*
*& ABAP basics cheat sheet in runnable form (ABAP 7.40+ syntax):
*& inline declarations, internal tables, string templates, VALUE/FOR,
*& REDUCE, class-based exceptions.
*&---------------------------------------------------------------------*
REPORT zjr_basics_demo.

CLASS lcl_demo DEFINITION FINAL.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_employee,
        id     TYPE i,
        name   TYPE string,
        dept   TYPE string,
        salary TYPE p LENGTH 8 DECIMALS 2,
      END OF ty_employee,
      tt_employee TYPE STANDARD TABLE OF ty_employee WITH DEFAULT KEY.

    METHODS run.
  PRIVATE SECTION.
    METHODS build_data RETURNING VALUE(rt_emp) TYPE tt_employee.
    METHODS divide
      IMPORTING a TYPE i b TYPE i
      RETURNING VALUE(r) TYPE f
      RAISING   cx_sy_zerodivide.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.

  METHOD run.
    DATA(lt_emp) = build_data( ).

    " 1) Loop + string template
    LOOP AT lt_emp INTO DATA(ls_emp).
      WRITE / |{ ls_emp-id }: { ls_emp-name } ({ ls_emp-dept }) - { ls_emp-salary NUMBER = USER }|.
    ENDLOOP.

    " 2) Read table with key + sy-subrc check
    READ TABLE lt_emp INTO DATA(ls_found) WITH KEY name = 'Alice'.
    IF sy-subrc = 0.
      WRITE / |Found: { ls_found-name }|.
    ENDIF.

    " 3) Table expression (throws exception if not found -> use OPTIONAL)
    DATA(ls_opt) = VALUE #( lt_emp[ id = 99 ] OPTIONAL ).
    IF ls_opt IS INITIAL.
      WRITE / 'Employee 99 does not exist'.
    ENDIF.

    " 4) Filter / sort / delete duplicates
    DATA(lt_it) = FILTER #( lt_emp WHERE dept = 'IT' ).
    SORT lt_it BY salary DESCENDING.
    WRITE / |IT employees: { lines( lt_it ) }|.

    " 5) REDUCE: sum of all salaries
    DATA(lv_total) = REDUCE decfloat34( INIT s = CONV decfloat34( 0 )
                                        FOR e IN lt_emp
                                        NEXT s = s + e-salary ).
    WRITE / |Total salary: { lv_total }|.

    " 6) Exception handling
    TRY.
        WRITE / |10 / 4 = { divide( a = 10 b = 4 ) }|.
        WRITE / |10 / 0 = { divide( a = 10 b = 0 ) }|.
      CATCH cx_sy_zerodivide INTO DATA(lx).
        WRITE / |Error: { lx->get_text( ) }|.
    ENDTRY.
  ENDMETHOD.

  METHOD build_data.
    rt_emp = VALUE #(
      ( id = 1 name = 'Alice' dept = 'IT'      salary = '4500.00' )
      ( id = 2 name = 'Bob'   dept = 'Finance' salary = '4100.00' )
      ( id = 3 name = 'Carol' dept = 'IT'      salary = '5200.00' ) ).
  ENDMETHOD.

  METHOD divide.
    IF b = 0.
      RAISE EXCEPTION TYPE cx_sy_zerodivide.
    ENDIF.
    r = a / b.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  NEW lcl_demo( )->run( ).
