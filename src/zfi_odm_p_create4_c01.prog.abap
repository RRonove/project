*&---------------------------------------------------------------------*
*& Include          ZFI_ODM_P_CREATE4_C01
*&---------------------------------------------------------------------*

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      init,

      at_ss_output,

      at_ss,

      start,

      end,

      get_data,

      process_data,

      list_layout_specification
        IMPORTING
          iv_alvname     TYPE string
        RETURNING
          VALUE(rs_layo) TYPE lvc_s_layo,

      set_variant
        IMPORTING
          iv_alvname        TYPE string
        RETURNING
          VALUE(rs_variant) TYPE disvariant,

      create_field_catalog
        EXPORTING
          et_fcat TYPE lvc_t_fcat
        CHANGING
          it_data TYPE STANDARD TABLE,

      modify_fieldcat
        IMPORTING
          iv_alvname TYPE string
        CHANGING
          it_fcat    TYPE lvc_t_fcat,

      fill_sytletab
        IMPORTING
          iv_enabled      TYPE xfeld
          iv_alvname      TYPE string
        RETURNING
          VALUE(rt_style) TYPE lvc_t_styl,

      display_log
        IMPORTING
          it_return TYPE bapiret2_t,

      add_message
        IMPORTING
          iv_msgty  TYPE symsgty
          iv_msg    TYPE bapi_msg OPTIONAL
          iv_msgid  TYPE symsgid  OPTIONAL
          iv_msgno  TYPE symsgno  OPTIONAL
          iv_msgv1  TYPE clike    OPTIONAL
          iv_msgv2  TYPE clike    OPTIONAL
          iv_msgv3  TYPE clike    OPTIONAL
          iv_msgv4  TYPE clike    OPTIONAL
          iv_index  TYPE i        OPTIONAL
        CHANGING
          it_return TYPE bapiret2_t,

      main_save,
      update
      .

ENDCLASS.




CLASS lcl_main IMPLEMENTATION.
*&---------------------------------------------------------------------*
*& init
*&---------------------------------------------------------------------*
  METHOD init .
    CLEAR:
      d_ok,
      gt_fieldcat[],
      gt_events[],
      gt_excluding[],
      gs_layout,
      gt_alv[].

  ENDMETHOD.  " init

*&---------------------------------------------------------------------*
*& at_ss_output
*&---------------------------------------------------------------------*
  METHOD at_ss_output .

  ENDMETHOD.  " at_ss_output

*&---------------------------------------------------------------------*
*& at_ss
*&---------------------------------------------------------------------*
  METHOD at_ss .

  ENDMETHOD.  " at_ss

*&---------------------------------------------------------------------*
*& start
*&---------------------------------------------------------------------*
  METHOD start .
    get_data( ).
    process_data( ).
  ENDMETHOD.  " start

*&---------------------------------------------------------------------*
*& end
*&---------------------------------------------------------------------*
  METHOD end .
    CALL SCREEN 100.
  ENDMETHOD.  " end

*&---------------------------------------------------------------------*
*& get_data
*&---------------------------------------------------------------------*
  METHOD get_data .


*    SELECT
*      zfi_odm_t_003~belnr,
*      zfi_odm_t_004~lifnr,
*      zfi_odm_t_003~gjahr,
*      zfi_odm_t_003~matnr,
*      zfi_odm_t_003~tasno,
*      zfi_odm_t_003~odcktutar
*       FROM zfi_odm_t_004
*      INNER JOIN zfi_odm_t_003 ON zfi_odm_t_004~tasno EQ zfi_odm_t_003~tasno
*      INTO TABLE @DATA(lt_duzeltme)
*      WHERE zfi_odm_t_004~lifnr IN @s_lifnr
*        AND zfi_odm_t_004~tasno IN @s_tasno
*        AND zfi_odm_t_004~prdha IN @s_prdha.

   " MOVE-CORRESPONDING lt_duzeltme TO gt_alv.

     SELECT * FROM zfi_odm_t_004
       INTO TABLE gt_t004
       WHERE zfi_odm_t_004~lifnr  IN s_lifnr
         AND zfi_odm_t_004~tasno  IN s_tasno
         AND zfi_odm_t_004~prdha  IN s_prdha.

       MOVE-CORRESPONDING gt_t004 TO gt_alv.


  ENDMETHOD.  " get_data

*&---------------------------------------------------------------------*
*& process_data
*&---------------------------------------------------------------------*
  METHOD process_data .


  ENDMETHOD.  " process_data


*&---------------------------------------------------------------------*
*& list_layout_specification
*&---------------------------------------------------------------------*
  METHOD list_layout_specification .
    CLEAR rs_layo.

    rs_layo-box_fname   = 'SELKZ'.
    rs_layo-cwidth_opt  = 'X'.
    rs_layo-zebra       = 'X'.
    rs_layo-stylefname  = 'STYLE'.
    rs_layo-sel_mode    = 'A'.

  ENDMETHOD.  " list_layout_specification


*&---------------------------------------------------------------------*
*& set_variant
*&---------------------------------------------------------------------*
  METHOD set_variant .
    CLEAR rs_variant.

    rs_variant-username = sy-uname.
    rs_variant-report   = sy-repid.

    CASE iv_alvname.
      WHEN gc_alvname-list.
        rs_variant-handle   = 'A100'.

*      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.  " set_variant

*&---------------------------------------------------------------------*
*& create_field_catalog
*&---------------------------------------------------------------------*
  METHOD create_field_catalog .
    DATA:
      lo_columns      TYPE REF TO cl_salv_columns_table,
      lo_aggregations TYPE REF TO cl_salv_aggregations,
      lo_salv_table   TYPE REF TO cl_salv_table,
      lr_table        TYPE REF TO data,
      ls_fcat         TYPE lvc_s_fcat,
      lv_dtext        TYPE scrtext_l.
    FIELD-SYMBOLS:
      <table>         TYPE STANDARD TABLE.


* create unprotected table from import data
    CREATE DATA lr_table LIKE it_data[].
    ASSIGN lr_table->* TO <table>.


*...New ALV Instance ...............................................
    TRY.
        cl_salv_table=>factory(
          EXPORTING
            list_display = abap_false
          IMPORTING
            r_salv_table = lo_salv_table
          CHANGING
            t_table      = <table> ).
      CATCH cx_salv_msg.                                "#EC NO_HANDLER
    ENDTRY.

    lo_columns      = lo_salv_table->get_columns( ).
    lo_aggregations = lo_salv_table->get_aggregations( ).
    et_fcat[]       = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
                            r_columns             = lo_columns
                            r_aggregations        = lo_aggregations ).


    LOOP AT et_fcat INTO ls_fcat.
      CLEAR lv_dtext.

      CASE ls_fcat-fieldname.
        WHEN 'SELKZ'.
          ls_fcat-tech = 'X'.
        WHEN 'ICON'.
          ls_fcat-icon = 'X'.
          lv_dtext = 'Statu'.
        WHEN 'STYLE'.
          ls_fcat-tech = 'X'.
        WHEN 'INFO'.
          ls_fcat-tech = 'X'.
      ENDCASE.

      IF lv_dtext IS NOT INITIAL.
        MOVE lv_dtext TO : ls_fcat-scrtext_l,
                           ls_fcat-scrtext_m,
                           ls_fcat-scrtext_s,
                           ls_fcat-coltext.
      ENDIF.

      MODIFY et_fcat FROM ls_fcat.
    ENDLOOP.


  ENDMETHOD.  " create_field_catalog



*&---------------------------------------------------------------------*
*& modify_fieldcat
*&---------------------------------------------------------------------*
  METHOD modify_fieldcat .
    DATA:
      ls_fcat  TYPE lvc_s_fcat,
      lv_dtext TYPE lvc_s_fcat-scrtext_m.


    LOOP AT it_fcat INTO ls_fcat.

      CLEAR lv_dtext.

      CASE iv_alvname.
        WHEN gc_alvname-list.
          CASE ls_fcat-fieldname.
            WHEN 'BUKRS'.
              ls_fcat-key = 'X'.
            WHEN 'ODCKTUTAR'.
              ls_fcat-edit = 'X'.

          ENDCASE.


      ENDCASE.

      IF lv_dtext IS NOT INITIAL.
        MOVE lv_dtext TO : ls_fcat-scrtext_l,
                           ls_fcat-scrtext_m,
                           ls_fcat-scrtext_s,
                           ls_fcat-coltext.
      ENDIF.

      MODIFY it_fcat FROM ls_fcat.
    ENDLOOP.


  ENDMETHOD.  " modify_fieldcat

*&---------------------------------------------------------------------*
*& fill_sytletab
*&---------------------------------------------------------------------*
  METHOD fill_sytletab .
    DATA: lt_styl  TYPE lvc_t_styl,
          ls_styl  TYPE lvc_s_styl,
          lv_style TYPE lvc_style.

    CLEAR:
      lt_styl,
      lv_style.

    CASE iv_enabled.
      WHEN 'X'.
        lv_style = cl_gui_alv_grid=>mc_style_enabled.
      WHEN ''.
        lv_style = cl_gui_alv_grid=>mc_style_disabled.
    ENDCASE.


    CASE iv_alvname.
      WHEN gc_alvname-list.
*        INSERT VALUE #( fieldname = 'FIELD1' style = lv_style ) INTO TABLE lt_styl.
*        INSERT VALUE #( fieldname = 'FIELD2' style = lv_style ) INTO TABLE lt_styl.


      WHEN OTHERS.
    ENDCASE.


    rt_style = lt_styl.

  ENDMETHOD.  " fill_sytletab

*&---------------------------------------------------------------------*
*& display_log
*&---------------------------------------------------------------------*
  METHOD display_log .
    CHECK it_return[] IS NOT INITIAL.

    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = it_return[].
  ENDMETHOD.  " display_log

*&---------------------------------------------------------------------*
*& add_message
*&---------------------------------------------------------------------*
  METHOD add_message .
    DATA:
      ls_bapiret2 TYPE bapiret2.


    CLEAR
      ls_bapiret2.

    IF iv_msg IS NOT INITIAL.
      MESSAGE ID '00' TYPE 'S' NUMBER '001'
            WITH iv_msg+000(050)
                 iv_msg+050(050)
                 iv_msg+100(050)
                 iv_msg+150(050)
            INTO ls_bapiret2-message.
    ELSEIF iv_msgid IS NOT INITIAL AND
           iv_msgno IS NOT INITIAL.
      MESSAGE ID iv_msgid TYPE 'S' NUMBER iv_msgno
            WITH iv_msgv1 iv_msgv2 iv_msgv3 iv_msgv4 INTO ls_bapiret2-message.
    ELSE.
      RETURN.
    ENDIF.

    ls_bapiret2-type         = iv_msgty.
    ls_bapiret2-id           = sy-msgid.
    ls_bapiret2-number       = sy-msgno.
    ls_bapiret2-message_v1   = sy-msgv1.
    ls_bapiret2-message_v2   = sy-msgv2.
    ls_bapiret2-message_v3   = sy-msgv3.
    ls_bapiret2-message_v4   = sy-msgv4.
    ls_bapiret2-row          = iv_index.
    APPEND ls_bapiret2 TO it_return.

  ENDMETHOD.  " add_message

*&---------------------------------------------------------------------*
*& main_save
*&---------------------------------------------------------------------*
  METHOD main_save .
    DATA:
      lv_valid  TYPE xfeld,
      lt_rows   TYPE lvc_t_row,
      ls_rows   TYPE lvc_s_row,
      ls_stable TYPE lvc_s_stbl VALUE 'XX'.

    DATA: lt_alv_duz TYPE TABLE OF zfi_odm_t_003,
          ls_alv_duz TYPE zfi_odm_t_003.

    DATA: lv_toptu  TYPE bseg-dmbtr.

    CLEAR ls_alv_duz.
    REFRESH lt_alv_duz.

    go_grid_0100->check_changed_data( IMPORTING e_valid = lv_valid ).
    CHECK lv_valid EQ abap_true.

    go_grid_0100->get_selected_rows( IMPORTING et_index_rows = lt_rows ).
    DELETE lt_rows WHERE rowtype NE space.
    CHECK lt_rows[] IS NOT INITIAL.

    CLEAR:
      gt_messtab[].
    CLEAR: lv_toptu.


    LOOP AT lt_rows INTO ls_rows.
      READ TABLE gt_alv INTO gs_alv INDEX ls_rows-index.
      MOVE-CORRESPONDING gs_alv TO ls_alv_duz.
      APPEND ls_alv_duz TO lt_alv_duz.
      LOOP AT gt_t004 REFERENCE INTO DATA(lr_t004)
                                WHERE tasno = ls_alv_duz-tasno
                                  AND lifnr = gs_alv-lifnr.
        lr_t004->odcktutar = lr_t004->odcktutar - ls_alv_duz-odcktutar.
      ENDLOOP.
      MODIFY gt_alv FROM gs_alv INDEX ls_rows-index.
    ENDLOOP.

    UPDATE zfi_odm_t_004 FROM TABLE gt_t004.
    DELETE zfi_odm_t_003 FROM TABLE lt_alv_duz.


    go_grid_0100->refresh_table_display( EXPORTING i_soft_refresh = 'X'
                                                   is_stable      = ls_stable ).

    lcl_main=>display_log( gt_messtab ).
  ENDMETHOD.  " main_save

  METHOD update.

    DATA:
      lv_valid  TYPE xfeld,
      lt_rows   TYPE lvc_t_row,
      ls_rows   TYPE lvc_s_row,
      ls_stable TYPE lvc_s_stbl VALUE 'XX',
      lv_fark   TYPE bseg-dmbtr.

    DATA: lt_alv_duz TYPE TABLE OF zfi_odm_t_003,
          ls_alv_duz TYPE zfi_odm_t_003.

    CLEAR ls_alv_duz.
    REFRESH lt_alv_duz.

    go_grid_0100->check_changed_data( IMPORTING e_valid = lv_valid ).
    CHECK lv_valid EQ abap_true.

    go_grid_0100->get_selected_rows( IMPORTING et_index_rows = lt_rows ).
    DELETE lt_rows WHERE rowtype NE space.
    CHECK lt_rows[] IS NOT INITIAL.

    CLEAR:
      gt_messtab[].



    LOOP AT lt_rows INTO ls_rows.
      READ TABLE gt_alv INTO gs_alv INDEX ls_rows-index.
      MOVE-CORRESPONDING gs_alv TO ls_alv_duz.
      APPEND ls_alv_duz TO lt_alv_duz.
      LOOP AT gt_t004 REFERENCE INTO DATA(lr_t004)
                                WHERE tasno = ls_alv_duz-tasno
                                  AND lifnr = gs_alv-lifnr.
       " lr_t004->odcktutar = lr_t004->odcktutar - ls_alv_duz-odcktutar.
      ENDLOOP.
      MODIFY gt_alv FROM gs_alv INDEX ls_rows-index.
    ENDLOOP.

    MODIFY zfi_odm_t_003 FROM TABLE lt_alv_duz.

    go_grid_0100->refresh_table_display( EXPORTING i_soft_refresh = 'X'
                                                   is_stable      = ls_stable ).

    lcl_main=>display_log( gt_messtab ).







  ENDMETHOD.


ENDCLASS.
