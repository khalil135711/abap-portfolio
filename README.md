# SAP ABAP Portfolio

Small collection of ABAP examples written as a junior SAP ABAP developer.
Focus: clean code, modern ABAP syntax (7.40+), separation of logic and UI, unit tests.

## Contents (`/src`)

| Object | Type | What it shows |
|---|---|---|
| `ZCL_JR_FLIGHT_SERVICE` | Class | Service class: Open SQL with ranges, inline declarations, field symbols |
| `ZCL_JR_FLIGHT_SERVICE` (local test class) | ABAP Unit | Tests for the occupancy calculation incl. edge case (division by zero) |
| `ZJR_FLIGHT_REPORT` | Report | Selection screen (`SELECT-OPTIONS`) + SALV ALV grid |
| `ZJR_BASICS_DEMO` | Report | Internal tables, `VALUE`, `FILTER`, `REDUCE`, string templates, exceptions |
| `ZJR_BAPI_DEMO` | Report | Calling a standard BAPI and evaluating the `RETURN` table |
| `ZJR_I_FLIGHT` | CDS view entity | CDS with `CASE`, `division`, currency annotation |

## Requirements

- SAP system with ABAP 7.50 or higher (CDS view entity needs 7.55+ / S/4HANA or ABAP Platform 2020+)
- Demo data in flight model tables (`SFLIGHT`) – generate with report `SAPBC_DATA_GENERATOR`

## Installation with abapGit

1. Install [abapGit](https://abapgit.org) in your system
2. Create a package, e.g. `$ZJR_PORTFOLIO`
3. In abapGit: **New Online** -> enter this repository URL -> select the package -> **Create Online Repo**
4. **Pull** and activate all objects

## Run

- Transaction `SE38` -> `ZJR_FLIGHT_REPORT` -> F8
- Unit tests: in ADT or SE24 on `ZCL_JR_FLIGHT_SERVICE` -> *Run as ABAP Unit Test* (Ctrl+Shift+F10)

## Conventions

- Prefix `ZJR_` / `ZCL_JR_` for custom objects
- `lv_` local var, `ls_` structure, `lt_` table, `lo_` object, `mt_` / `mo_` member attributes
- ABAP Doc comments (`"!`) on public methods

## Author

<YOUR NAME> - Junior SAP ABAP Developer
