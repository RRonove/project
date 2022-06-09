*&---------------------------------------------------------------------*
*& Include          ZFI_ODM_P_CREATE4_T01
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Tables                                                               *
*----------------------------------------------------------------------*
TABLES: sscrfields, zfi_odm_t_004, zfi_odm_t_003 .

*----------------------------------------------------------------------*
* Data Definition  *---------------------------------------------------*
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Type-pools
*----------------------------------------------------------------------*
TYPE-POOLS: slis.

*----------------------------------------------------------------------*
* Includes
*----------------------------------------------------------------------*
INCLUDE <icon>.

*----------------------------------------------------------------------*
* Class definition deferred
*----------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION DEFERRED.

*----------------------------------------------------------------------*
* TYPES
*----------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_alv,
    selkz TYPE selkz,
    "  icon  TYPE icon_d,
    "  info  TYPE lvc_emphsz,
    style TYPE lvc_t_styl,
  END OF ty_alv,

  BEGIN OF ty_data,
    lifnr     TYPE zfi_odm_t_004-lifnr,
    tasno     TYPE zfi_odm_t_004-tasno,
    prdha     TYPE zfi_odm_t_004-prdha,
    odtutar   TYPE zfi_odm_t_004-odtutar,
    odcktutar TYPE zfi_odm_t_004-odcktutar,
    laufi     TYPE zfi_odm_t_004-laufi,
    text      TYPE zfi_odm_t_004-text,
    keydt     TYPE zfi_odm_t_004-keydt,
    uname     TYPE zfi_odm_t_004-uname,
    islemtar  TYPE zfi_odm_t_004-islemtar,
    uzeit     TYPE zfi_odm_t_004-uzeit,
  END OF ty_data
  .

TYPES BEGIN OF ty_list.
INCLUDE TYPE ty_alv.
INCLUDE TYPE ty_data.
TYPES END OF ty_list.

*----------------------------------------------------------------------*
* Field-Symbols
*----------------------------------------------------------------------*

FIELD-SYMBOLS:
  <fs1> TYPE any.

*----------------------------------------------------------------------*
* Variables
*----------------------------------------------------------------------*
DATA:
  d_ok,
  gv_count  TYPE i,
  d_repname LIKE sy-repid.



*----------------------------------------------------------------------*
* Constants
*----------------------------------------------------------------------*
CONSTANTS:
  BEGIN OF gc_selmode,
    default TYPE lvc_s_layo-sel_mode VALUE '',
  END OF gc_selmode,
  BEGIN OF gc_alvname,
    list TYPE string VALUE 'LIST',
  END OF gc_alvname,
  BEGIN OF gc_contname,
    0100   TYPE string VALUE 'CCONT0100',
    0100_s TYPE string VALUE 'CCONT0100_S',
    0100_t TYPE string VALUE 'CCONT0100_T',
    0100_g TYPE string VALUE 'CCONT0100_G',
  END OF gc_contname.

*----------------------------------------------------------------------*
* Structures
*----------------------------------------------------------------------*
DATA:
  gs_alv  TYPE ty_list,
  gs_t001 TYPE t001.

DATA:
  gs_styletab TYPE lvc_s_styl,
  gs_layout   TYPE lvc_s_layo,
  gs_fieldcat TYPE lvc_s_fcat,
  gs_variant  TYPE disvariant.

*----------------------------------------------------------------------*
* Internal Tables
*----------------------------------------------------------------------*

DATA:
  gt_alv  TYPE TABLE OF ty_list,
  gt_t004 TYPE TABLE OF zfi_odm_t_004.

DATA:
  gt_fieldcat  TYPE lvc_t_fcat,
  gt_heading   TYPE slis_t_listheader,
  gt_events    TYPE TABLE OF slis_alv_event,
  gt_excluding TYPE slis_t_extab,
  gt_messtab   TYPE TABLE OF bapiret2.

*----------------------------------------------------------------------*
* Ranges
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Objects
*----------------------------------------------------------------------*
DATA:
  go_cont_0100   TYPE REF TO cl_gui_custom_container,
  go_cont_0100_s TYPE REF TO cl_gui_splitter_container,
  go_cont_0100_t TYPE REF TO cl_gui_container,
  go_cont_0100_g TYPE REF TO cl_gui_container,
  go_grid_0100   TYPE REF TO cl_gui_alv_grid,
  go_handler     TYPE REF TO lcl_event_handler.
