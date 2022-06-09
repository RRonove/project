*&---------------------------------------------------------------------*
*& Include          ZFI_ODM_P_CREATE4_S01
*&---------------------------------------------------------------------*


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.

  SELECT-OPTIONS: s_lifnr FOR zfi_odm_t_004-lifnr,
                  s_tasno FOR zfi_odm_t_004-tasno,
                  s_prdha FOR zfi_odm_T_004-prdha.
  PARAMETERS:     p_laufi TYPE laufi,
                  p_text  TYPE text_65.

SELECTION-SCREEN END OF BLOCK b1.
