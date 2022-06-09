*&---------------------------------------------------------------------*
*& Report ZFI_ODM_P_CREATE3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFI_ODM_P_CREATE3.



INCLUDE ZFI_ODM_P_CREATE3_T01."top
INCLUDE ZFI_ODM_P_CREATE3_S01."selection screen
INCLUDE ZFI_ODM_P_CREATE3_C01."main
INCLUDE ZFI_ODM_P_CREATE3_C02."event handler
INCLUDE ZFI_ODM_P_CREATE3_C03."screen
INCLUDE ZFI_ODM_P_CREATE3_M01."module pbo/pai

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
