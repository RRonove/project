*&---------------------------------------------------------------------*
*& Report ZRC_P_ODEV8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrc_p_odev8.

INCLUDE zrc_p_odev8_top.
INCLUDE zrc_p_odev8_cls.
INCLUDE zrc_p_odev8_pbo.
INCLUDE zrc_p_odev8_pai.
INCLUDE zrc_p_odev8_frm.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR  p_file .
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = p_file.



START-OF-SELECTION.




  CALL SCREEN 0100.
