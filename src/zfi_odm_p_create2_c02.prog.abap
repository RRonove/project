*&---------------------------------------------------------------------*
*& Include          ZFI_ODM_P_CREATE2_C02
*&---------------------------------------------------------------------*

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS :
      handle_top_of_page FOR EVENT top_of_page OF cl_gui_alv_grid
        IMPORTING e_dyndoc_id
                  table_index
                  sender,
      handle_toolbar     FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object
                  e_interactive
                  sender,
      handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm
                  sender,
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row
                  e_column
                  es_row_no
                  sender ,
      handle_hotspot_click FOR EVENT  hotspot_click OF   cl_gui_alv_grid
        IMPORTING e_row_id
                  e_column_id
                  es_row_no
                  sender  .
ENDCLASS.                    "lcl_event_handler DEFINITION




*----------------------------------------------------------------------*
*       CLASS LCL_EVENT_HANDLER IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.


*&---------------------------------------------------------------------*
*& handle_top_of_page
*& ->e_dyndoc_id  type ref to cl_dd_document
*& ->table_index  type        syindex
*& ->e_sender
*&---------------------------------------------------------------------*
  METHOD handle_top_of_page .
    DATA:
      lv_text TYPE sdydo_text_element,
      lv_datec TYPE char10,
      lv_timec TYPE char10.
    lv_text = sy-title.
    e_dyndoc_id->add_text( text = lv_text sap_style = e_dyndoc_id->heading ) .
    e_dyndoc_id->new_line( ).


*    lv_text = | Kullanıcı adı: { sy-uname } Tarih: { sy-datum DATE = USER } Saat: { sy-uzeit TIME = USER } |.
    WRITE sy-datum TO lv_datec DD/MM/YYYY.
    WRITE sy-uzeit TO lv_timec USING EDIT MASK '__:__:__'.
    CONCATENATE 'Kullanıcı adı:' sy-uname 'Tarih:' lv_datec 'Saat:' lv_timec
           INTO lv_text SEPARATED BY space.
    e_dyndoc_id->add_text( text = lv_text ).

    e_dyndoc_id->new_line( ).
*    lv_text = | Şirket kodu: { p_bukrs } Şirket adı: { gs_t001-butxt } |.
    CONCATENATE 'Şirket kodu: ' gs_t001-bukrs 'Şirket adı:' gs_t001-butxt
           INTO lv_text SEPARATED BY space.
    e_dyndoc_id->add_text( text = lv_text ).


    e_dyndoc_id->merge_document( ).

    e_dyndoc_id->display_document(
    EXPORTING
      parent = go_cont_0100_t
    EXCEPTIONS
      html_display_error = 1
      OTHERS = 2 ).
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.  " handle_top_of_page


*&---------------------------------------------------------------------*
*& handle_toolbar
*& -> E_OBJECT Type Ref To CL_ALV_EVENT_TOOLBAR_SET
*& -> E_INTERACTIVE  Type  CHAR01
*& -> SENDER
*&---------------------------------------------------------------------*
  METHOD handle_toolbar .
    DATA:
      ls_button TYPE stb_button.


    DELETE e_object->mt_toolbar WHERE function EQ cl_gui_alv_grid=>mc_fc_loc_append_row    OR
                                      function EQ cl_gui_alv_grid=>mc_fc_loc_copy          OR
                                      function EQ cl_gui_alv_grid=>mc_fc_loc_copy_row      OR
                                      function EQ cl_gui_alv_grid=>mc_fc_loc_cut           OR
                                      function EQ cl_gui_alv_grid=>mc_fc_loc_delete_row    OR
                                      function EQ cl_gui_alv_grid=>mc_fc_loc_insert_row    OR
                                      function EQ cl_gui_alv_grid=>mc_fc_loc_move_row      OR
                                      function EQ cl_gui_alv_grid=>mc_fc_loc_paste         OR
                                      function EQ cl_gui_alv_grid=>mc_fc_loc_paste_new_row OR
                                      function eq cl_gui_alv_grid=>mc_fc_loc_undo .

*          CLEAR ls_button.
*          ls_button-icon     = icon_add_row.
*          ls_button-text     = 'Satır ekle' .
*          ls_button-function = '&INS_ROW'.
*          APPEND ls_button TO e_object->mt_toolbar.


  ENDMETHOD.  " handle_toolbar


*&---------------------------------------------------------------------*
*& handle_user_command
*& -> E_UCOMM type sy-ucomm
*& -> sender
*&---------------------------------------------------------------------*
  METHOD handle_user_command .


  ENDMETHOD.  " handle_user_command

*&---------------------------------------------------------------------*
*& handle_double_click
*& -->  E_ROW     TYPE LVC_S_ROW
*& -->  E_COLUMN  TYPE LVC_S_COL
*& -->  ES_ROW_NO TYPE LVC_S_ROID
*& -->  SENDER    TYPE REF TO CL_GUI_ALV_GRID
*&---------------------------------------------------------------------*
  METHOD handle_double_click .

  ENDMETHOD.  " handle_double_click

*&---------------------------------------------------------------------*
*& handle_hotspot_click
*&---------------------------------------------------------------------*
  METHOD handle_hotspot_click .


  ENDMETHOD.  " handle_hotspot_click

ENDCLASS.                    "LCL_EVENT_HANDLER IMPLEMENTATION
