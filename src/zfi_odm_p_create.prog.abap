*&---------------------------------------------------------------------*
*& Report ZFI_ODM_P_CREATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfi_odm_p_create.


INCLUDE zfi_odm_p_create_t01. "top
INCLUDE zfi_odm_p_create_s01. "selection screen
INCLUDE zfi_odm_p_create_c01. "main
INCLUDE zfi_odm_p_create_c02. "event handler
INCLUDE zfi_odm_p_create_c03. "screen
INCLUDE zfi_odm_p_create_m01. "module pbo/pai

INITIALIZATION.
  lcl_main=>init( ).

AT SELECTION-SCREEN OUTPUT.
  lcl_main=>at_ss_output( ).

AT SELECTION-SCREEN.
  lcl_main=>at_ss( ).

START-OF-SELECTION.
  lcl_main=>start( ).


END-OF-SELECTION.
  lcl_main=>end( ).
