"! Service class: reads flight data (demo table SFLIGHT) and calculates statistics.
"! Separation of concerns: no UI logic in here, so it is easy to unit test.
CLASS zcl_jr_flight_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_flight,
        carrid        TYPE sflight-carrid,
        connid        TYPE sflight-connid,
        fldate        TYPE sflight-fldate,
        price         TYPE sflight-price,
        currency      TYPE sflight-currency,
        seatsmax      TYPE sflight-seatsmax,
        seatsocc      TYPE sflight-seatsocc,
        occupancy_pct TYPE p LENGTH 5 DECIMALS 2,
      END OF ty_flight,
      tt_flight       TYPE STANDARD TABLE OF ty_flight WITH DEFAULT KEY,
      tt_carrid_range TYPE RANGE OF sflight-carrid,
      tt_date_range   TYPE RANGE OF sflight-fldate.

    "! Reads flights and enriches them with the occupancy in percent.
    "! @parameter it_carrid | Airline range
    "! @parameter it_date | Flight date range
    "! @parameter rt_flights | Result table
    METHODS get_flights
      IMPORTING it_carrid         TYPE tt_carrid_range OPTIONAL
                it_date           TYPE tt_date_range   OPTIONAL
      RETURNING VALUE(rt_flights) TYPE tt_flight.

    "! Occupancy in percent. Returns 0 if there are no seats (avoids division by zero).
    METHODS calculate_occupancy
      IMPORTING iv_seats_max  TYPE i
                iv_seats_occ  TYPE i
      RETURNING VALUE(rv_pct) TYPE ty_flight-occupancy_pct.
ENDCLASS.


CLASS zcl_jr_flight_service IMPLEMENTATION.

  METHOD get_flights.
    SELECT carrid, connid, fldate, price, currency, seatsmax, seatsocc
      FROM sflight
      WHERE carrid IN @it_carrid
        AND fldate IN @it_date
      ORDER BY carrid, connid, fldate
      INTO CORRESPONDING FIELDS OF TABLE @rt_flights.

    LOOP AT rt_flights ASSIGNING FIELD-SYMBOL(<ls_flight>).
      <ls_flight>-occupancy_pct = calculate_occupancy(
        iv_seats_max = <ls_flight>-seatsmax
        iv_seats_occ = <ls_flight>-seatsocc ).
    ENDLOOP.
  ENDMETHOD.

  METHOD calculate_occupancy.
    IF iv_seats_max <= 0.
      rv_pct = 0.
      RETURN.
    ENDIF.
    rv_pct = iv_seats_occ * 100 / iv_seats_max.
  ENDMETHOD.

ENDCLASS.
