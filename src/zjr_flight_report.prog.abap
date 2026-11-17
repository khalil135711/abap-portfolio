*&---------------------------------------------------------------------*
*& Report ZJR_FLIGHT_REPORT
*&---------------------------------------------------------------------*
*& Flight report with selection screen and SALV ALV grid.
*& Demonstrates: selection screen, service class, modern Open SQL,
*& CL_SALV_TABLE, exception handling.
*&---------------------------------------------------------------------*
REPORT zjr_flight_report.

TABLES sflight.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_carrid FOR sflight-carrid,
                  s_fldate FOR sflight-fldate.
SELECTION-SCREEN END OF BLOCK b1.

CLASS lcl_app DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS run.
  PRIVATE SECTION.
    DATA mt_flights TYPE zcl_jr_flight_service=>tt_flight.
    METHODS load_data.
    METHODS display_alv.
ENDCLASS.

CLASS lcl_app IMPLEMENTATION.

  METHOD run.
    load_data( ).
    IF mt_flights IS INITIAL.
      MESSAGE 'No flights found for your selection' TYPE 'S' DISPLAY LIKE 'W'.
      RETURN.
    ENDIF.
    display_alv( ).
  ENDMETHOD.

  METHOD load_data.
    DATA(lo_service) = NEW zcl_jr_flight_service( ).
    mt_flights = lo_service->get_flights(
      it_carrid = s_carrid[]
      it_date   = s_fldate[] ).
  ENDMETHOD.

  METHOD display_alv.
    TRY.
        cl_salv_table=>factory(
          IMPORTING r_salv_table = DATA(lo_alv)
          CHANGING  t_table      = mt_flights ).

        lo_alv->get_functions( )->set_all( abap_true ).
        lo_alv->get_columns( )->set_optimize( abap_true ).
        lo_alv->get_display_settings( )->set_striped_pattern( abap_true ).
        lo_alv->get_display_settings( )->set_list_header( 'Flight overview' ).

        lo_alv->get_columns( )->get_column( 'OCCUPANCY_PCT' )->set_long_text( 'Occupancy %' ).
        lo_alv->display( ).

      CATCH cx_salv_msg INTO DATA(lx_msg).
        MESSAGE lx_msg->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
      CATCH cx_salv_not_found INTO DATA(lx_nf).
        MESSAGE lx_nf->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  NEW lcl_app( )->run( ).
