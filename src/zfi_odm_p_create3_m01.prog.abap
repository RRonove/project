*&---------------------------------------------------------------------*
*& Include          ZFI_ODM_P_CREATE3_M01
*&---------------------------------------------------------------------*



*&---------------------------------------------------------------------*
*& Module STATUS OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status OUTPUT.

 lcl_screen=>screen_pbo( EXPORTING iv_screen = sy-dynnr
                                   iv_ucomm  = sy-ucomm ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command INPUT.

 lcl_screen=>screen_pai( EXPORTING iv_exit   = abap_true
                                   iv_screen = sy-dynnr
                                   iv_ucomm  = sy-ucomm ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command INPUT.

 lcl_screen=>screen_pai( EXPORTING iv_exit   = abap_false
                                   iv_screen = sy-dynnr
                                   iv_ucomm  = sy-ucomm ).

ENDMODULE.
