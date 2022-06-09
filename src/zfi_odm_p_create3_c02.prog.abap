*&---------------------------------------------------------------------*
*& Include          ZFI_ODM_P_CREATE3_C02
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
      handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed
                  e_onf4
                  e_ucomm,
      handle_data_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified
                  et_good_cells
                  sender,
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


  METHOD handle_data_finished.

    LOOP AT et_good_cells INTO DATA(s_cell).
      CASE s_cell-fieldname.
        WHEN 'ODNCKTU'.
          READ TABLE gt_alv ASSIGNING FIELD-SYMBOL(<fs_alv>) INDEX s_cell-row_id.
          IF sy-subrc = 0.
            READ TABLE gt_yetki INTO DATA(ls_yetki) WITH KEY bukrs = <fs_alv>-bukrs
                                                             prdha = <fs_alv>-prdha.
            IF ls_yetki-limit < <fs_alv>-odncktu.
              MESSAGE 'Yetkili Limiti Yetersiz' TYPE 'S' DISPLAY LIKE 'E'.
              <fs_alv>-odncktu = 0.
              go_grid_0100->refresh_table_display( ).
            ELSE.
              READ TABLE gt_alv ASSIGNING <fs_alv> INDEX s_cell-row_id.
              IF sy-subrc = 0.
                IF <fs_alv>-dmbtr < <fs_alv>-odncktu.

                  MESSAGE 'Ödenecek Tutar Toplam Tutardan Büyük Olamaz' TYPE 'S' DISPLAY LIKE 'E'.
                  <fs_alv>-odncktu = <fs_alv>-dmbtr.
                  go_grid_0100->refresh_table_display( ).
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

*&---------------------------------------------------------------------*
*& handle_top_of_page
*& ->e_dyndoc_id  type ref to cl_dd_document
*& ->table_index  type        syindex
*& ->e_sender
*&---------------------------------------------------------------------*
  METHOD handle_top_of_page .
    DATA:
      lv_text  TYPE sdydo_text_element,
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
                                      function EQ cl_gui_alv_grid=>mc_fc_loc_undo .

    CLEAR ls_button.
    ls_button-icon     = icon_system_save.
    ls_button-text     = 'Öneri Oluştur' .
    ls_button-function = 'SAVE'.
    APPEND ls_button TO e_object->mt_toolbar.


  ENDMETHOD.  " handle_toolbar


*&---------------------------------------------------------------------*
*& handle_user_command
*& -> E_UCOMM type sy-ucomm
*& -> sender
*&---------------------------------------------------------------------*
  METHOD handle_user_command .
    DATA: lt_ro TYPE lvc_t_row,
          ls_ro TYPE lvc_s_row.

    CASE e_ucomm.
      WHEN 'SAVE'.
        CLEAR: p_laufi, p_text.

        lcl_main=>kayit_at( ).



    ENDCASE.


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
*& handle_data_changed
*&---------------------------------------------------------------------*
  METHOD handle_data_changed .

**    DATA: ls_modi TYPE lvc_s_modi,
**          ls_alv  LIKE LINE OF gt_alv.
**
**    LOOP AT er_data_changed->mt_good_cells INTO ls_modi.
**
**      CASE ls_modi-fieldname.
**        WHEN 'ODNCKTU'.
**          CLEAR ls_alv.
**
**
**          READ TABLE gt_alv INTO ls_alv INDEX ls_modi-row_id.
**          CHECK sy-subrc = 0.
**          ls_alv-odncktu = ls_modi-value.
**          IF ls_alv-odncktu > ls_alv-dmbtr.
**
**            ls_alv-odncktu = ls_alv-dmbtr.
**            MESSAGE 'Ödenecek Tutar Toplam Tutardan Büyük Olamaz' TYPE 'S' DISPLAY LIKE 'E'.
**
**          ENDIF.
**      ENDCASE.
**    ENDLOOP.


    " Value


  ENDMETHOD.  " handle_double_click

*&---------------------------------------------------------------------*
*& handle_hotspot_click
*&---------------------------------------------------------------------*
  METHOD handle_hotspot_click .

    gv_row = e_row_id.

    CASE e_column_id-fieldname.
      WHEN 'LIFNR' OR 'PRDHA'.
        lcl_main=>popup_hotspot( ).
      WHEN OTHERS.
    ENDCASE.


  ENDMETHOD.  " handle_hotspot_click

ENDCLASS.                    "LCL_EVENT_HANDLER IMPLEMENTATION
