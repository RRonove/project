*&---------------------------------------------------------------------*
*& Include          ZFI_ODM_P_CREATE2_C01
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

      main_save
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

    TYPES: BEGIN OF lty_stok_key,
             lifnr TYPE bseg-lifnr,
             matnr TYPE bseg-matnr,
             prdha TYPE mara-prdha,
             belnr TYPE bseg-belnr,
           END OF lty_stok_key.

    DATA: lt_stok_key TYPE TABLE OF lty_stok_key,
          ls_stok_key TYPE lty_stok_key.


    DATA: lv_vmsl_top TYPE acdoca_m_extract-vmsl,
          lv_hsl_top  TYPE acdoca_m_extract-hsl.

    DATA: lt_alv_data TYPE TABLE OF ty_data,
          ls_alv_data TYPE ty_data.


    DATA: lrt_belnr TYPE RANGE OF bseg-belnr,
          lrt_matnr TYPE RANGE OF bseg-matnr,
          lrt_lifnr TYPE RANGE OF bseg-lifnr,
          lrt_prdha TYPE RANGE OF mara-prdha.

    DATA: lv_zbd1t TYPE bseg-zbd1t,
          lv_zfbdt TYPE bseg-zfbdt,
          lv_netdt TYPE bseg-zfbdt,
          lv_day   TYPE i,
          lv_aralk TYPE char3.


    SELECT zfi_odm_t_001~bukrs,
           zfi_odm_t_001~belnr,
           zfi_odm_t_001~gjahr,
           bseg~zfbdt,
           bseg~zbd1t,
           bseg~zbd2t,
           bseg~zbd3t,
           zfi_odm_t_001~lifnr,
           "zfi_odm_t_001~werks,
           lfa1~name1         ,
           zfi_odm_t_001~matnr,
           makt~maktx,
           zfi_odm_t_001~dmbtr,
           zfi_odm_t_001~dmbe2,
           zfi_odm_t_001~dmbe3,
           zfi_odm_t_001~prdha,
           zfi_odm_t_001~menge
           "zfi_odm_t_001~status,
           "zfi_odm_t_001~odtutar
      FROM zfi_odm_t_001
      LEFT JOIN lfa1 ON lfa1~lifnr EQ zfi_odm_t_001~lifnr
      LEFT JOIN makt ON makt~matnr EQ zfi_odm_t_001~matnr
                     AND makt~spras EQ @sy-langu
      INNER JOIN bseg ON bseg~belnr EQ zfi_odm_t_001~belnr
                     AND bseg~bukrs EQ zfi_odm_t_001~bukrs
                     AND bseg~gjahr EQ zfi_odm_t_001~gjahr
                     AND bseg~koart EQ 'K'
       INTO TABLE @DATA(lt_detay)
      WHERE zfi_odm_t_001~bukrs  = @p_bukrs
*        AND zfi_odm_t_001~gjahr  = @p_gjahr
        AND zfi_odm_t_001~lifnr IN @s_lifnr
        AND zfi_odm_t_001~belnr IN @s_belnr
        AND NOT EXISTS ( SELECT * FROM zfi_odm_t_003
                            WHERE  zfi_odm_t_003~belnr EQ zfi_odm_t_001~belnr
                               AND zfi_odm_t_003~gjahr EQ zfi_odm_t_001~gjahr ) .


    LOOP AT lt_detay INTO DATA(ls_detayy).
      CLEAR: ls_stok_key.

      IF p_belg IS INITIAL.
        CLEAR: ls_detayy-belnr.
      ENDIF.


      IF p_satc IS INITIAL.
        CLEAR: ls_detayy-lifnr.
      ENDIF.

      MOVE-CORRESPONDING ls_detayy TO ls_stok_key.
      COLLECT ls_stok_key INTO lt_stok_key.
    ENDLOOP.






    SELECT
           itab~lifnr,
           "acdoca_m_extract~rldnr,
         "  acdoca_m_extract~rbukrs     ,
        "   acdoca_m_extract~fiscyearper,
           itab~matnr      ,
           itab~belnr      ,
           itab~prdha      ,
           "acdoca_m_extract~bwkey AS werks,
          SUM( acdoca_m_extract~vmsl ) AS vmsl     ,
          SUM( acdoca_m_extract~hsl ) AS hsl
      FROM acdoca_m_extract
      INNER JOIN @lt_stok_key AS itab ON itab~matnr EQ acdoca_m_extract~matnr
      WHERE rbukrs      = @p_bukrs
        AND fiscyearper = '9999999'
      GROUP BY itab~lifnr,  itab~matnr, itab~belnr, itab~prdha
       INTO TABLE @DATA(lt_acdoca_stok).




    LOOP AT lt_detay INTO DATA(ls_detay) .
      CLEAR: lv_vmsl_top, lv_hsl_top, lv_zbd1t, lv_zfbdt .

      MOVE-CORRESPONDING ls_detay TO ls_alv_data.
      READ TABLE lt_acdoca_stok INTO DATA(ls_acdoca_stok) WITH KEY
                                          matnr = ls_detay-matnr.
      "werks = ls_detay-werks.

      IF ls_acdoca_stok-vmsl IS NOT INITIAL.
        ls_alv_data-stok_deg = ls_detay-menge / ls_acdoca_stok-vmsl * ls_acdoca_stok-hsl.
      ENDIF.

      IF p_malz IS INITIAL.
        CLEAR: ls_alv_data-matnr, ls_alv_data-maktx.
      ENDIF.

      IF p_belg IS INITIAL.
        CLEAR: ls_alv_data-belnr.
      ENDIF.

      IF p_urun IS INITIAL.
        CLEAR: ls_alv_data-prdha.
      ENDIF.

      IF p_satc IS INITIAL.
        CLEAR: ls_alv_data-lifnr, ls_alv_data-name1.
      ENDIF.

      lv_zbd1t = ls_alv_data-zbd1t + ls_alv_data-zbd2t + ls_alv_data-zbd3t.
      lv_zfbdt = ls_alv_data-zfbdt.

      CALL FUNCTION 'RELATIVE_DATE_CALCULATE'
        EXPORTING
          days        = lv_zbd1t
*         MONTHS      = '0'
          start_date  = lv_zfbdt
*         YEARS       = '0'
        IMPORTING
          result_date = lv_netdt.
      .

      ls_alv_data-netdt = lv_netdt.
      lv_day = ls_alv_data-netdt - p_keydt.
      IF lv_day <= 0.
        " ls_alv_data-odgrk = ls_alv_data-dmbtr - ls_alv_data-dmbtr - ls_alv_data-odtutar.
        IF lv_day BETWEEN -30 AND 0.
          ls_alv_data-pst01 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
          lv_aralk = 'G01'.
        ELSEIF lv_day BETWEEN -60 AND -31.
          ls_alv_data-pst02 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
          lv_aralk = 'G02'.
        ELSEIF lv_day BETWEEN -90 AND -61.
          ls_alv_data-pst03 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
          lv_aralk = 'G03'.
        ELSEIF lv_day BETWEEN -120 AND -91.
          ls_alv_data-pst04 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
          lv_aralk = 'G04'.
        ELSEIF lv_day BETWEEN -150 AND -121.
          ls_alv_data-pst05 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
          lv_aralk = 'G05'.
        ELSEIF lv_day BETWEEN -180 AND -151.
          ls_alv_data-pst06 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
          lv_aralk = 'G06'.
        ELSEIF lv_day BETWEEN -210 AND -181.
          ls_alv_data-pst07 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
          lv_aralk = 'G07'.
        ELSEIF lv_day BETWEEN -240 AND -211.
          ls_alv_data-pst08 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
          lv_aralk = 'G08'.
        ELSEIF lv_day BETWEEN -270 AND -241.
          ls_alv_data-pst09 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
          lv_aralk = 'G09'.
        ELSE.
          ls_alv_data-pst10 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
          lv_aralk = 'G10'.
        ENDIF.
      ELSEIF lv_day BETWEEN 1 AND 30.
        ls_alv_data-ara01 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
        lv_aralk = 'F01'.
      ELSEIF lv_day BETWEEN 31 AND 60.
        ls_alv_data-ara02 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
        lv_aralk = 'F02'.
      ELSEIF lv_day BETWEEN 61 AND 90.
        ls_alv_data-ara03 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
        lv_aralk = 'F03'.
      ELSEIF lv_day BETWEEN 91 AND 120.
        ls_alv_data-ara04 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
        lv_aralk = 'F04'.
      ELSEIF lv_day BETWEEN 121 AND 150.
        ls_alv_data-ara05 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
        lv_aralk = 'F05'.
      ELSEIF lv_day BETWEEN 151 AND 180.
        ls_alv_data-ara06 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
        lv_aralk = 'F06'.
      ELSEIF lv_day BETWEEN 181 AND 210.
        ls_alv_data-ara07 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
        lv_aralk = 'F07'.
      ELSEIF lv_day BETWEEN 211 AND 240.
        ls_alv_data-ara08 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
        lv_aralk = 'F08'.
      ELSEIF lv_day BETWEEN 241 AND 270.
        ls_alv_data-ara09 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
        lv_aralk = 'F09'.
      ELSE.
        ls_alv_data-ara10 = ls_alv_data-dmbtr - ls_alv_data-odtutar.
        lv_aralk = 'F10'.
      ENDIF.

      IF p_belg = ' '.
        CLEAR ls_alv_data-netdt.
      ENDIF.


      CLEAR: ls_alv_data-zbd1t, ls_alv_data-zbd2t, ls_alv_data-zbd3t, ls_alv_data-zfbdt.

      COLLECT ls_alv_data INTO lt_alv_data.

      CLEAR: ls_acdoca_stok, ls_alv_data .
    ENDLOOP.


    LOOP AT lt_alv_data INTO ls_alv_data.

      REFRESH: lrt_matnr, lrt_belnr, lrt_lifnr, lrt_prdha.

      IF p_malz = 'X'.
        lrt_matnr = VALUE #( ( sign = 'I' option = 'EQ' low = ls_alv_data-matnr  ) ).
      ENDIF.

      IF p_satc = 'X'.
        lrt_lifnr = VALUE #( ( sign = 'I' option = 'EQ' low = ls_alv_data-lifnr  ) ).
      ENDIF.

      IF p_belg = 'X'.
        lrt_belnr = VALUE #( ( sign = 'I' option = 'EQ' low = ls_alv_data-belnr  ) ).
      ENDIF.

      IF p_urun = 'X'.
        lrt_prdha = VALUE #( ( sign = 'I' option = 'EQ' low = ls_alv_data-prdha  ) ).
      ENDIF.




      LOOP AT lt_acdoca_stok INTO ls_acdoca_stok WHERE belnr IN lrt_belnr
                                                   AND matnr IN lrt_matnr
                                                   AND lifnr IN lrt_lifnr
                                                   AND prdha IN lrt_prdha.

        ls_alv_data-stok_deg = ls_alv_data-stok_deg + ls_acdoca_stok-hsl.


      ENDLOOP.
      MODIFY lt_alv_data FROM ls_alv_data.
    ENDLOOP.

    MOVE-CORRESPONDING lt_alv_data TO gt_alv.






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
        WHEN 'ODNCTUTAR'.
          ls_fcat-edit = 'X'.
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
            WHEN 'MATNR' OR 'MAKTX' OR 'MWSKZ'.
              IF p_malz = ' '.
                ls_fcat-no_out = 'X'.
              ENDIF.
            WHEN 'PRDHA'.
              IF p_urun = ' '.
                ls_fcat-no_out = 'X'.
              ENDIF.
            WHEN 'BELNR' OR 'NETDT'.
              IF p_belg = ' '.
                ls_fcat-no_out = 'X'.
              ENDIF.
            WHEN 'LIFNR' OR 'NAME1'.
              IF p_satc = ' '.
                ls_fcat-no_out = 'X'.
              ENDIF.
            WHEN 'PST01'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '1-30'.
            WHEN 'PST02'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '31-60'.
            WHEN 'PST03'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '61-90'.
            WHEN 'PST04'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '91-120'.
            WHEN 'PST05'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '121-150'.
            WHEN 'PST06'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '151-180'.
            WHEN 'PST07'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '181-210'.
            WHEN 'PST08'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '211-240'.
            WHEN 'PST09'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '241-270'.
            WHEN 'PST10'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '270 +'.

            WHEN 'ARA01'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '-30-0'.
            WHEN 'ARA02'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '-60-31'.
            WHEN 'ARA03'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '-90-61'.
            WHEN 'ARA04'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '-120-91'.
            WHEN 'ARA05'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '-150-121'.
            WHEN 'ARA06'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '-180-151'.
            WHEN 'ARA07'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '-210-181'.
            WHEN 'ARA08'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '-240-211'.
            WHEN 'ARA09'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '-270-241'.
            WHEN 'ARA10'.
              ls_fcat-scrtext_s =
              ls_fcat-scrtext_m =
              ls_fcat-scrtext_l =
              ls_fcat-reptext =
              ls_fcat-coltext =
              ls_fcat-seltext = '-270'.
            WHEN 'ZFBDT'.
              ls_fcat-no_out = 'X'.
            WHEN 'ZBD1T'.
              ls_fcat-no_out = 'X'.
            WHEN 'ZBD2T'.
              ls_fcat-no_out = 'X'.
            WHEN 'ZBD3T'.
              ls_fcat-no_out = 'X'.
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

    go_grid_0100->check_changed_data( IMPORTING e_valid = lv_valid ).
    CHECK lv_valid EQ abap_true.

    go_grid_0100->get_selected_rows( IMPORTING et_index_rows = lt_rows ).
    DELETE lt_rows WHERE rowtype NE space.
    CHECK lt_rows[] IS NOT INITIAL.

    CLEAR:
      gt_messtab[].

    LOOP AT lt_rows INTO ls_rows.
      READ TABLE gt_alv INTO gs_alv INDEX ls_rows-index.

      "---


      MODIFY gt_alv FROM gs_alv INDEX ls_rows-index.
    ENDLOOP.

    go_grid_0100->refresh_table_display( EXPORTING i_soft_refresh = 'X'
                                                   is_stable      = ls_stable ).

    lcl_main=>display_log( gt_messtab ).
  ENDMETHOD.  " main_save

ENDCLASS.
