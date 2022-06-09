*&---------------------------------------------------------------------*
*& Include          ZFI_ODM_P_CREATE3_S01
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-s01.
  PARAMETERS:
    p_bukrs TYPE bkpf-bukrs OBLIGATORY MODIF ID md2 MEMORY ID buk,
    p_keydt TYPE datum OBLIGATORY MODIF ID md2 DEFAULT sy-datum.

  SELECT-OPTIONS:
    s_lifnr FOR bseg-lifnr,
    s_prdha FOR zfi_odm_t_001-prdha.
*    s_budat FOR bkpf-budat.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF SCREEN 200 AS WINDOW TITLE TEXT-001.
  PARAMETERS: p_laufi TYPE laufi,
              p_text  TYPE text_65.
  SELECTION-SCREEN FUNCTION KEY 1.
SELECTION-SCREEN END   OF SCREEN 200.
