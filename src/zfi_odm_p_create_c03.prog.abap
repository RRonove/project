*&---------------------------------------------------------------------*
*& Include          ZFI_ODM_P_CREATE_C03
*&---------------------------------------------------------------------*
CLASS lcl_screen DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      screen_pai
        IMPORTING VALUE(iv_screen) TYPE sy-dynnr
                  VALUE(iv_ucomm)  TYPE sy-ucomm
                  VALUE(iv_exit)   TYPE xfeld OPTIONAL,
      screen_pbo
        IMPORTING VALUE(iv_screen) TYPE sy-dynnr
                  VALUE(iv_ucomm)  TYPE sy-ucomm,
      setup_screen_0100
      .
ENDCLASS.


CLASS lcl_screen IMPLEMENTATION.
*&---------------------------------------------------------------------*
*& screen_pai
*&---------------------------------------------------------------------*
  METHOD screen_pai .

    IF iv_exit EQ 'X'.
      CASE iv_ucomm.
        WHEN 'BACK' OR 'UP' OR 'CANC'.
          LEAVE TO SCREEN 0.
        WHEN 'EXIT'.
          LEAVE PROGRAM.
        WHEN OTHERS.
      ENDCASE.
      RETURN.
    ENDIF.

    CASE iv_screen.
      WHEN '0100'.
        IF iv_ucomm EQ 'SAVE'.
          lcl_main=>main_save( ).
        ENDIF.

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.  " screen_pai

*&---------------------------------------------------------------------*
*& screen_pbo
*&---------------------------------------------------------------------*
  METHOD screen_pbo .

    CASE iv_screen.
      WHEN '0100'.
        setup_screen_0100( ).


      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.  " screen_pbo

*&---------------------------------------------------------------------*
*& setup_screen_0100
*&---------------------------------------------------------------------*
  METHOD setup_screen_0100 .
    DATA:
      ls_stable    TYPE lvc_s_stbl VALUE 'XX',
      lo_dyndoc_id TYPE REF TO cl_dd_document,
      ls_layout    TYPE lvc_s_layo,
      ls_variant   TYPE disvariant,
      lt_fcat      TYPE lvc_t_fcat.


    SET PF-STATUS 'GUI_0100'.
    SET TITLEBAR  'TITLE_0100'.


    IF go_grid_0100 IS NOT BOUND.

      IF go_handler IS NOT BOUND.
        CREATE OBJECT go_handler.
      ENDIF.

      CREATE OBJECT go_cont_0100
        EXPORTING
          container_name = 'CCONT0100'.
      go_cont_0100->set_name( gc_contname-0100 ).

      CREATE OBJECT go_cont_0100_s
        EXPORTING
          parent  = go_cont_0100
          rows    = 2
          columns = 1.
      go_cont_0100_s->set_name( gc_contname-0100_s ).
      go_cont_0100_s->set_row_height( id = 1
                                      height = 10 ).

      CALL METHOD go_cont_0100_s->get_container
        EXPORTING
          row       = 1
          column    = 1
        RECEIVING
          container = go_cont_0100_t.
      go_cont_0100_t->set_name( gc_contname-0100_t ).

      CALL METHOD go_cont_0100_s->get_container
        EXPORTING
          row       = 2
          column    = 1
        RECEIVING
          container = go_cont_0100_g.
      go_cont_0100_g->set_name( gc_contname-0100_g ).


      IF lo_dyndoc_id IS BOUND.
        CLEAR lo_dyndoc_id.
      ENDIF.

      CREATE OBJECT lo_dyndoc_id.


      CREATE OBJECT go_grid_0100
        EXPORTING
          i_parent = go_cont_0100_g.
      go_grid_0100->set_name( gc_alvname-list ).


      ls_layout = lcl_main=>list_layout_specification( gc_alvname-list ).
      ls_variant = lcl_main=>set_variant( gc_alvname-list ).
      lcl_main=>create_field_catalog(
                      IMPORTING et_fcat = lt_fcat
                      CHANGING  it_data = gt_alv ).
      lcl_main=>modify_fieldcat(
                      EXPORTING iv_alvname = gc_alvname-list
                      CHANGING  it_fcat    = lt_fcat ).

**      IF ra_ozet = 'X'.
        LOOP AT lt_fcat REFERENCE INTO DATA(lr_fcat).
          CASE lr_fcat->fieldname.
            WHEN 'WERKS'.
**              IF p_malz = ' '.
                lr_fcat->no_out = 'X'.
**              ENDIF.
**            WHEN 'PRDHA'.
**              IF p_urun = ' '.
**                lr_fcat->no_out = 'X'.
**              ENDIF.
**            WHEN 'BELNR'.
**              IF p_belg = ' '.
**                lr_fcat->no_out = 'X'.
**              ENDIF.
**            WHEN 'LIFNR'.
**              IF p_satc = ' '.
**                lr_fcat->no_out = 'X'.
**              ENDIF.
          ENDCASE.
        ENDLOOP.
**      ELSE.
**      ENDIF.


      SET HANDLER go_handler->handle_top_of_page  FOR go_grid_0100.
*      SET HANDLER go_handler->handle_toolbar      FOR go_grid_0100.
*      SET HANDLER go_handler->handle_user_command FOR go_grid_0100.
*      SET HANDLER go_handler->handle_double_click FOR go_grid_0100.
*      SET HANDLER go_handler->handle_hotspot_click FOR go_grid_0100.

      CALL METHOD go_grid_0100->set_table_for_first_display
        EXPORTING
*         i_buffer_active               =
          i_bypassing_buffer            = 'X'
*         i_consistency_check           =
*         i_structure_name              =
          is_variant                    = ls_variant
          i_save                        = 'A'
*         i_default                     = 'X'
          is_layout                     = ls_layout
*         is_print                      =
*         it_special_groups             =
*         it_toolbar_excluding          =
*         it_hyperlink                  =
*         it_alv_graphics               =
*         it_except_qinfo               =
*         ir_salv_adapter               =
        CHANGING
          it_outtab                     = gt_alv
          it_fieldcatalog               = lt_fcat
*         it_sort                       =
*         it_filter                     =
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*      go_grid_0100->set_toolbar_interactive( ).

      go_grid_0100->list_processing_events( i_event_name = 'TOP_OF_PAGE'
                                            i_dyndoc_id  = lo_dyndoc_id ).

    ELSE.
      go_grid_0100->refresh_table_display( is_stable      = ls_stable
                                           i_soft_refresh = 'X' ).
    ENDIF.


  ENDMETHOD.  " setup_screen_0100

ENDCLASS. "lcl_screen
