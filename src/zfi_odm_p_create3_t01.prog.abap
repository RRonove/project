*&---------------------------------------------------------------------*
*& Include          ZFI_ODM_P_CREATE3_T01
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Tables                                                               *
*----------------------------------------------------------------------*
TABLES: sscrfields, bkpf, bseg, zfi_odm_t_001, zfi_odm_t_003, zfi_odm_t_004.

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
    " icon  TYPE icon_d,
    " info  TYPE lvc_emphsz,
    style TYPE lvc_t_styl,
  END OF ty_alv,


  BEGIN OF ty_data,
    bukrs    TYPE bkpf-bukrs,
    belnr    TYPE bkpf-belnr,
    gjahr    TYPE bkpf-gjahr,
    zfbdt    TYPE bseg-zfbdt,
    zbd1t    TYPE bseg-zbd1t,
    zbd2t    TYPE bseg-zbd2t,
    zbd3t    TYPE bseg-zbd3t,
    netdt    TYPE bseg-netdt,
    lifnr    TYPE bseg-lifnr,
    prdha    TYPE mara-prdha,
    tasno    TYPE zfi_odm_t_003-tasno,
    name1    TYPE lfa1-name1,
    matnr    TYPE bseg-matnr,
    maktx    TYPE makt-maktx,
    dmbtr    TYPE bseg-dmbtr,
    stok_deg TYPE acdoca_m_extract-hsl,
    odncktu  TYPE bseg-dmbtr,
    gecvade  TYPE bseg-dmbtr,
    pst10    TYPE bseg-dmbtr,
    pst09    TYPE bseg-dmbtr,
    pst08    TYPE bseg-dmbtr,
    pst07    TYPE bseg-dmbtr,
    pst06    TYPE bseg-dmbtr,
    pst05    TYPE bseg-dmbtr,
    pst04    TYPE bseg-dmbtr,
    pst03    TYPE bseg-dmbtr,
    pst02    TYPE bseg-dmbtr,
    pst01    TYPE bseg-dmbtr,
    gelvade  TYPE bseg-dmbtr,
    ara01    TYPE bseg-dmbtr,
    ara02    TYPE bseg-dmbtr,
    ara03    TYPE bseg-dmbtr,
    ara04    TYPE bseg-dmbtr,
    ara05    TYPE bseg-dmbtr,
    ara06    TYPE bseg-dmbtr,
    ara07    TYPE bseg-dmbtr,
    ara08    TYPE bseg-dmbtr,
    ara09    TYPE bseg-dmbtr,
    ara10    TYPE bseg-dmbtr,
    dmbe2    TYPE bseg-dmbe2,
    dmbe3    TYPE bseg-dmbe3,
    "  status   TYPE zfi_odm_t_003-status,
    " stok_mik   TYPE acdoca_m_extract-VMSL,
    odtutar  TYPE zfi_odm_t_003-odcktutar,
  END OF ty_data.

TYPES: BEGIN OF ty_detay_yedek,
         bukrs     TYPE zfi_odm_t_001-bukrs,
         belnr     TYPE zfi_odm_t_001-belnr,
         gjahr     TYPE zfi_odm_t_001-gjahr,
         zfbdt     TYPE bseg-zfbdt,
         netdt     TYPE bseg-netdt,
         zbd1t     TYPE bseg-zbd1t,
         zbd2t     TYPE bseg-zbd2t,
         zbd3t     TYPE bseg-zbd3t,
         lifnr     TYPE zfi_odm_t_001-lifnr,
         name1     TYPE lfa1-name1,
         matnr     TYPE zfi_odm_t_001-matnr,
         maktx     TYPE makt-maktx,
         dmbtr     TYPE zfi_odm_t_001-dmbtr,
         dmbe2     TYPE zfi_odm_t_001-dmbe2,
         dmbe3     TYPE zfi_odm_t_001-dmbe3,
         prdha     TYPE zfi_odm_t_001-prdha,
         menge     TYPE zfi_odm_t_001-menge,
         status    TYPE zfi_odm_t_004-status,
         tamam     TYPE zfi_odm_t_003-tamam,
         odcktutar TYPE zfi_odm_t_004-odcktutar,
       END OF ty_detay_yedek.

TYPES: BEGIN OF ty_yetki,
         bukrs      TYPE zfi_odm_t_005-bukrs,
         prdha      TYPE zfi_odm_t_005-prdha,
         limit      TYPE zfi_odm_t_006-limit,
         oneriyetki TYPE zfi_odm_t_005-oneriyetki,
         onayyetki  TYPE zfi_odm_t_005-onayyetki,
       END OF ty_yetki.




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
  d_repname LIKE sy-repid,
  gv_row    TYPE i,
  gv_check  TYPE char1.
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
  gt_alv   TYPE TABLE OF ty_list,
  gt_eksik TYPE TABLE OF zfi_odm_t_003,
  gt_yetki TYPE TABLE OF ty_yetki.


DATA: gt_detay_yedek TYPE TABLE OF ty_detay_yedek,
      gs_detay_yedek TYPE ty_detay_yedek.

DATA: gt_zfiodmt001 TYPE TABLE OF zfi_odm_t_001,
      gt_zfiodmt003 TYPE TABLE OF zfi_odm_t_003,
      gs_zfiodmt003 TYPE  zfi_odm_t_003,
      gt_zfiodmt004 TYPE TABLE OF zfi_odm_t_004,
      gs_zfiodmt004 TYPE zfi_odm_t_004.

DATA:
  gt_fieldcat  TYPE lvc_t_fcat,
  gt_heading   TYPE slis_t_listheader,
  gt_events    TYPE TABLE OF slis_alv_event,
  gt_excluding TYPE slis_t_extab,
  gt_messtab   TYPE TABLE OF bapiret2..

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
