*&---------------------------------------------------------------------*
*& Report ZJR_BAPI_DEMO
*&---------------------------------------------------------------------*
*& Calls the standard BAPI_COMPANYCODE_GETLIST and prints the result.
*& Demonstrates: function module call, error handling via RETURN table.
*&---------------------------------------------------------------------*
REPORT zjr_bapi_demo.

START-OF-SELECTION.

  DATA lt_companycodes TYPE STANDARD TABLE OF bapi0002_2 WITH DEFAULT KEY.
  DATA lt_return       TYPE STANDARD TABLE OF bapiret2   WITH DEFAULT KEY.

  CALL FUNCTION 'BAPI_COMPANYCODE_GETLIST'
    TABLES
      companycode_list = lt_companycodes
      return           = lt_return.

  " Check for error messages (type E or A)
  LOOP AT lt_return INTO DATA(ls_return) WHERE type CA 'EA'.
    WRITE / |Error: { ls_return-message }|.
    RETURN.
  ENDLOOP.

  LOOP AT lt_companycodes INTO DATA(ls_cc).
    WRITE / |{ ls_cc-comp_code }  { ls_cc-comp_name }|.
  ENDLOOP.

  IF lt_companycodes IS INITIAL.
    WRITE / 'No company codes found.'.
  ENDIF.
