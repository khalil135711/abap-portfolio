@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight with occupancy (demo CDS view)'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZJR_I_FLIGHT
  as select from sflight
{
  key carrid                                              as Carrier,
  key connid                                              as Connection,
  key fldate                                              as FlightDate,
      @Semantics.amount.currencyCode: 'Currency'
      price                                               as Price,
      currency                                            as Currency,
      seatsmax                                            as SeatsMax,
      seatsocc                                            as SeatsOccupied,
      case when seatsmax > 0
           then division( seatsocc * 100, seatsmax, 2 )
           else cast( 0 as abap.dec(5,2) )
      end                                                 as OccupancyPct
}
