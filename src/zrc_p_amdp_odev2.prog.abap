*&---------------------------------------------------------------------*
*& Report zrc_p_amdp_odev2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrc_p_amdp_odev2.

INCLUDE zrc_p_amdp_odev2_top.
INCLUDE zrc_p_amdp_odev2_screen.
INCLUDE zrc_p_amdp_odev2_class.
INCLUDE zrc_p_amdp_odev2_module.


INITIALIZATION.
  CREATE OBJECT go_checkbox.


AT SELECTION-SCREEN OUTPUT.
go_checkbox->buton_ekle( ).

*  go_checkbox->checkbox_list( ).

AT SELECTION-SCREEN.

go_checkbox->buton_check( ).
*  go_datas->get_data( ).


START-OF-SELECTION.

  CALL SCREEN 0100.
