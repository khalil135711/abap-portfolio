"! ABAP Unit tests for ZCL_JR_FLIGHT_SERVICE (logic only, no database access)
CLASS ltc_flight_service DEFINITION FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_jr_flight_service.

    METHODS setup.
    METHODS occupancy_half_full  FOR TESTING.
    METHODS occupancy_full       FOR TESTING.
    METHODS occupancy_no_seats   FOR TESTING.
ENDCLASS.


CLASS ltc_flight_service IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD occupancy_half_full.
    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->calculate_occupancy( iv_seats_max = 200 iv_seats_occ = 100 )
      exp = CONV zcl_jr_flight_service=>ty_flight-occupancy_pct( '50.00' )
      msg = 'Half full flight should be 50 %' ).
  ENDMETHOD.

  METHOD occupancy_full.
    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->calculate_occupancy( iv_seats_max = 150 iv_seats_occ = 150 )
      exp = CONV zcl_jr_flight_service=>ty_flight-occupancy_pct( '100.00' )
      msg = 'Full flight should be 100 %' ).
  ENDMETHOD.

  METHOD occupancy_no_seats.
    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->calculate_occupancy( iv_seats_max = 0 iv_seats_occ = 0 )
      exp = CONV zcl_jr_flight_service=>ty_flight-occupancy_pct( '0.00' )
      msg = 'No seats must not cause a division by zero' ).
  ENDMETHOD.

ENDCLASS.
