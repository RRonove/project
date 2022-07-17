*&---------------------------------------------------------------------*
*& Report ZRC_P_ODEV9
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrc_p_odev9.


INCLUDE zrc_p_odev9_top.
INCLUDE zrc_p_odev9_cls.
INCLUDE zrc_p_odev9_pbo.
INCLUDE zrc_p_odev9_pai.
INCLUDE zrc_p_odev9_frm.

INITIALIZATION.

  PERFORM dropdown.


AT SELECTION-SCREEN OUTPUT.


  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'ID1'.
        IF p_gkayit = 'X'.
          screen-active = 1.
          MODIFY SCREEN.
        ELSE.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
      WHEN 'ID2'.
        IF p_tkayit = 'X'.
          screen-active = 1.
          MODIFY SCREEN.
        ELSE.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
    ENDCASE.


    CASE screen-group1.
      WHEN 'ID1'.
        IF p_gkayit = 'X'.
          screen-active = 1.
          MODIFY SCREEN.
        ELSE.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
      WHEN 'ID2'.
        IF p_tkayit = 'X'.
          screen-active = 1.
          MODIFY SCREEN.
        ELSE.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
    ENDCASE.

  ENDLOOP.



AT SELECTION-SCREEN.
  IF sy-ucomm  = 'BT1'.
    PERFORM sablon.
  ENDIF.








AT SELECTION-SCREEN ON VALUE-REQUEST FOR  p_file .

  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = p_file.












START-OF-SELECTION.

  PERFORM set_lay.
  PERFORM set_fc.


  CALL SCREEN 0100.
