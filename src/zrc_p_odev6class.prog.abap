*&---------------------------------------------------------------------*
*& Report ZRC_P_ODEV6CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrc_p_odev6class.

INCLUDE zrc_p_odev6class_top.
INCLUDE zrc_p_odev6class_cls.
INCLUDE zrc_p_odev6class_pbo.
INCLUDE zrc_p_odev6class_pai.

AT SELECTION-SCREEN.

  CREATE OBJECT lo_mail.
  IF sy-ucomm = 'BT1'.
    lo_mail->mail_list( ).
  ENDIF.


START-OF-SELECTION.

  CREATE OBJECT go_list.
  go_list->build_url( ).
  go_list->get_data( ).
  go_list->str_to_xstr( ).
  go_list->send_mail( ).
  go_list->build_fieldcatlog( ).
  go_list->display_alv( ).
