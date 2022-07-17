*&---------------------------------------------------------------------*
*& Report ZRC_P_ODEV7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrc_p_odev7.

INCLUDE zrc_p_odev7_top.
INCLUDE zrc_p_odev7_class.
INCLUDE zrc_p_odev7_pbo.
INCLUDE zrc_p_odev7_pai.
INCLUDE zrc_p_odev7_frm.


START-OF-SELECTION.

PERFORM set_fc.
PERFORM set_lay.








    CALL SCREEN 0100.
