*&---------------------------------------------------------------------*
*& Include          ZFI_ODM_P_CREATE2_S01
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-s01.
  PARAMETERS:
    p_bukrs TYPE bkpf-bukrs OBLIGATORY MODIF ID md2 MEMORY ID buk,
*    p_gjahr TYPE bkpf-gjahr OBLIGATORY MODIF ID md2.
    p_keydt TYPE sy-datum OBLIGATORY  MODIF ID md2 DEFAULT sy-datum .

  SELECT-OPTIONS:
    s_lifnr FOR bseg-lifnr,
    s_belnr FOR bkpf-belnr.

  "SELECTION-SCREEN SKIP.
  SELECTION-SCREEN ULINE.
  SELECTION-SCREEN COMMENT /1(50) TEXT-001.
  PARAMETERS:
    p_urun AS CHECKBOX MODIF ID md1 USER-COMMAND us1,
    p_satc AS CHECKBOX MODIF ID md1 USER-COMMAND us1,
    p_malz AS CHECKBOX MODIF ID md1 USER-COMMAND us1,
    p_belg AS CHECKBOX MODIF ID md1 USER-COMMAND us1.
  SELECTION-SCREEN ULINE.


SELECTION-SCREEN END OF BLOCK b1.
