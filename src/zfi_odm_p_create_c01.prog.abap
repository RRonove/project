*&---------------------------------------------------------------------*
*& Include          ZFI_ODM_P_CREATE_C01
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
      vergi_hesabi
        IMPORTING
          iv_rbukrs TYPE acdoca-rbukrs
          iv_mwskz  TYPE acdoca-mwskz
          iv_tut    TYPE acdoca-tsl
          iv_rtcur  TYPE acdoca-rtcur
        CHANGING
          lv_vertut TYPE acdoca-tsl,


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

    TYPES: BEGIN OF lty_nomatnr,
             bukrs  TYPE bkpf-bukrs,
             gjahr  TYPE bkpf-gjahr,
             belnr  TYPE bkpf-belnr,
             belnr1 TYPE bkpf-belnr,
             dmbtr  TYPE bseg-dmbtr,
             xblnr  TYPE bkpf-xblnr,
             bktxt  TYPE bkpf-bktxt,
           END OF lty_nomatnr.

    DATA: lt_nomatnr TYPE TABLE OF lty_nomatnr,
          ls_nomatnr TYPE lty_nomatnr.

    DATA: rt_racct TYPE RANGE OF acdoca-racct,
          rs_racct LIKE LINE OF rt_racct.

    DATA: lt_zfi007 TYPE TABLE OF zfi_odm_t_007,
          ls_zfi007 TYPE zfi_odm_t_007.

    SELECT * FROM zfi_odm_t_002
      INTO TABLE @DATA(lt_racct).


    LOOP AT lt_racct INTO DATA(ls_racct).
      CLEAR: rs_racct.
      rs_racct-high   = ' '.
      rs_racct-low    = ls_racct-zracct.
      rs_racct-sign   = 'I'.
      rs_racct-option = 'EQ'.

      COLLECT rs_racct INTO rt_racct.
    ENDLOOP.



    CLEAR gs_t001.
    SELECT
      acdoca~rldnr,
      acdoca~rbukrs,
      acdoca~gjahr,
      acdoca~belnr
       FROM acdoca
       WHERE  rldnr = '0L'
         AND rbukrs     = @p_bukrs
         AND gjahr      = @p_gjahr
         AND belnr      IN @s_belnr
        " AND lifnr      IN @s_lifnr
        " AND lifnr      NE ' '
         AND budat      IN @s_budat
         AND awtyp      NOT IN ('MKPF','VBRK')
         AND xreversed  = @space
         AND xreversing = @space
       "  AND drcrk      = 'S'
         AND augbl      = @space
         AND augdt      = '00000000'
         AND racct      IN @rt_racct
**         AND ( racct LIKE '329%' OR racct = '6020101005' OR racct LIKE '153%'
**               OR racct = '6020101002' OR racct = '6020101001'  )
      INTO TABLE @DATA(lt_key).
    SORT lt_key BY rldnr rbukrs gjahr belnr.
    DELETE ADJACENT DUPLICATES FROM lt_key COMPARING ALL FIELDS.

**    SELECT
**      "acdoca~rldnr,
**      bsik~bukrs,
**      bsik~gjahr,
**      bsik~belnr
**       FROM bsik
**       WHERE  "rldnr = '0L'
**           bukrs     = @p_bukrs
**          AND gjahr      = @p_gjahr
**          AND belnr      IN @s_belnr
**         " AND lifnr      IN @s_lifnr
**          AND budat      IN @s_budat
**         " AND awtyp      NOT IN ('MKPF','VBRK')
**         " AND xreversed  = @space
**         " AND xreversing = @space
**         " AND drcrk      = 'S'
**         " AND augbl      = @space
**         " AND augdt      = '00000000'
***          AND racct      IN @rt_racct
**      INTO TABLE @DATA(lt_key2).
**    SORT lt_key2 BY bukrs gjahr belnr.
**    DELETE ADJACENT DUPLICATES FROM lt_key2 COMPARING ALL FIELDS.


**    SELECT" bseg~rldnr     ,
**           bseg~bukrs    ,
**           bseg~gjahr     ,
**           bseg~buzei     ,
**           bseg~belnr     ,
**          " bseg~docln     ,
**           bseg~koart     ,
**           bseg~hkont     ,
**           bseg~SHKZG     ,
**           lfa1~lifnr     ,
**           lfa1~name1       ,
**           bseg~matnr     ,
**           bseg~augbl,
**           bseg~augdt,
**           "acdoca~matnr_copa,
**           makt~maktx       ,
**           bseg~werks     ,
**           mara~matkl  ,
**           bseg~menge,
**           bseg~h_waers     ,
**           bseg~h_hwaer ,
**           bseg~h_hwae2    ,
**           bseg~h_hwae3     ,
**           bseg~wrbtr       ,
**           bseg~dmbtr       ,
**           bseg~dmbe2       ,
**           bseg~dmbe3       ,
**           mara~prdha  ,
**           bseg~mwskz
**       FROM bseg
**      LEFT JOIN mara ON mara~matnr EQ bseg~matnr
**      LEFT JOIN makt ON makt~matnr EQ bseg~matnr
**                      AND makt~spras EQ @sy-langu
**      LEFT JOIN lfa1 ON lfa1~lifnr EQ bseg~lifnr
**      INTO TABLE @DATA(lt_acdoca)
**      FOR ALL ENTRIES IN @lt_key
**      WHERE bseg~bukrs =  @lt_key-rbukrs
**        AND bseg~gjahr  = @lt_key-gjahr
**        AND bseg~belnr  = @lt_key-belnr
**        AND NOT EXISTS ( SELECT * FROM zfi_odm_t_001
**                              WHERE  zfi_odm_t_001~bukrs EQ bseg~bukrs
**                                 AND zfi_odm_t_001~belnr EQ bseg~belnr
**                                 AND zfi_odm_t_001~gjahr EQ bseg~gjahr ) .


    SELECT acdoca~rldnr     ,
         acdoca~rbukrs AS bukrs     ,
         acdoca~gjahr     ,
         acdoca~buzei     ,
         acdoca~belnr     ,
         bkpf~bktxt     ,
         acdoca~docln     ,
         acdoca~koart     ,
         acdoca~drcrk     ,
         acdoca~racct AS hkont    ,
         lfa1~lifnr     ,
         lfa1~name1       ,
         acdoca~matnr     ,
         acdoca~matnr_copa,
         acdoca~augbl,
         acdoca~augdt,
         makt~maktx       ,
       "  acdoca~werks     ,
         mara~matkl  ,
         acdoca~rtcur AS h_waers    ,
         acdoca~rhcur AS h_hwaer    ,
         acdoca~rkcur AS h_hwae2    ,
         acdoca~rocur AS h_hwae3   ,
         acdoca~tsl   AS wrbtr     ,
         acdoca~hsl   AS dmbtr   ,
         acdoca~ksl   AS dmbe2    ,
         acdoca~osl   AS dmbe3    ,
         mara~prdha  ,
         acdoca~mwskz
     FROM acdoca
    LEFT JOIN mara    ON mara~matnr  EQ acdoca~matnr
                      OR mara~matnr  EQ acdoca~matnr_copa
    LEFT JOIN makt  ON ( makt~matnr  EQ acdoca~matnr
                     OR makt~matnr   EQ acdoca~matnr_copa )
                    AND makt~spras   EQ @sy-langu
    LEFT JOIN lfa1  ON lfa1~lifnr    EQ acdoca~lifnr
    LEFT JOIN bkpf  ON acdoca~belnr  EQ bkpf~belnr
                   AND acdoca~gjahr  EQ bkpf~gjahr
                   AND acdoca~rbukrs EQ bkpf~bukrs
    INTO TABLE @DATA(lt_acdoca)
    FOR ALL ENTRIES IN @lt_key
    WHERE acdoca~rldnr      =  @lt_key-rldnr
      AND acdoca~rbukrs     =  @lt_key-rbukrs
      AND acdoca~gjahr      =  @lt_key-gjahr
      AND acdoca~belnr      =  @lt_key-belnr
      AND acdoca~xreversed  = @space
      AND acdoca~xreversing = @space
      AND acdoca~awref_rev  = @space
      AND acdoca~bstat      NOT IN ( 'C', 'J' ).
*      AND NOT EXISTS ( SELECT * FROM zfi_odm_t_001
*                            WHERE  zfi_odm_t_001~bukrs EQ acdoca~rbukrs
*                               AND zfi_odm_t_001~belnr EQ acdoca~belnr
*                               AND zfi_odm_t_001~gjahr EQ acdoca~gjahr ) .

    CHECK lt_acdoca  IS NOT INITIAL.

    TYPES: rty_belnr TYPE RANGE OF bseg-belnr.

    DATA: rs_belnr TYPE LINE OF rty_belnr,
          rt_belnr TYPE rty_belnr.

    DATA: rt_xblnr TYPE RANGE OF bkpf-xblnr,
          rs_xblnr LIKE LINE OF rt_xblnr.

    DATA(lt_acdocop) = lt_acdoca.

    DELETE lt_acdocop WHERE matnr IS INITIAL
                        AND matnr_copa IS INITIAL.

    LOOP AT lt_acdoca INTO DATA(ls_acdoca) WHERE augbl IS NOT INITIAL
                                             AND augdt IS NOT INITIAL.

      rs_belnr-low = ls_acdoca-belnr.
      rs_belnr-option = 'EQ'.
      rs_belnr-sign = 'I'.
      CLEAR rs_belnr-high.
      COLLECT rs_belnr INTO rt_belnr.
    ENDLOOP.


    LOOP AT lt_acdoca INTO ls_acdoca WHERE matnr IS INITIAL
                                       AND matnr_copa IS INITIAL.
      READ TABLE lt_acdocop INTO DATA(ls_acdocop) WITH KEY belnr = ls_acdoca-belnr
                                                           bukrs = ls_acdoca-bukrs
                                                           gjahr = ls_acdoca-gjahr.
      IF sy-subrc IS NOT INITIAL.
        IF ls_acdoca-bktxt IS NOT INITIAL.
          CLEAR ls_nomatnr.
          MOVE-CORRESPONDING ls_acdoca TO ls_nomatnr.

          APPEND ls_nomatnr TO lt_nomatnr.
          CLEAR rs_xblnr.
          rs_xblnr-high   = ' '.
          rs_xblnr-low    = ls_acdoca-bktxt.
          rs_xblnr-option = 'EQ'.
          rs_xblnr-sign   = 'I'.
          COLLECT rs_xblnr INTO rt_xblnr.
        ELSEIF ls_acdoca-bktxt IS INITIAL.
          MOVE-CORRESPONDING ls_acdoca TO ls_zfi007.
          COLLECT ls_zfi007 INTO lt_zfi007.
        ENDIF.
      ENDIF.
    ENDLOOP.

    SELECT bkpf~bukrs, bkpf~belnr, bkpf~gjahr,
      bseg~menge, bkpf~xblnr, bkpf~bktxt
      FROM bkpf
      INNER JOIN bseg  ON bkpf~bukrs EQ bseg~bukrs
                      AND bkpf~gjahr EQ bseg~gjahr
                      AND bkpf~belnr EQ bseg~belnr
      INTO TABLE @DATA(lt_bkpf)
      WHERE bkpf~aworg_rev  = @space
        AND bkpf~awref_rev  = @space
        AND bkpf~xreversing = @space
        AND bkpf~xreversed  = @space
        AND bkpf~stblg      = @space
        AND bkpf~stjah      = @space
        AND bkpf~xblnr     IN @rt_xblnr.

    IF rt_belnr IS NOT INITIAL.
      DELETE lt_acdoca WHERE belnr IN rt_belnr.
    ENDIF.

    DATA: lt_data TYPE TABLE OF ty_data,
          ls_data TYPE ty_data.
    DATA: lv_vertut  TYPE bset-fwste.
    DATA: lv_hsl_tot TYPE acdoca-hsl.
    DATA: lv_osl_tot TYPE acdoca-osl.
    DATA: lv_tsl_tot TYPE acdoca-tsl.
    DATA: lv_ksl_tot TYPE acdoca-ksl.
    DATA: lv_fark TYPE acdoca-hsl.
    "DATA: lv_kontrol TYPE acdoca-hsl.

    REFRESH lt_acdocop.

**    lt_acdocop = lt_acdoca.
**
**    LOOP AT lt_acdoca REFERENCE INTO DATA(lr_acc) WHERE matnr IS INITIAL
**                                                    AND matnr_copa IS INITIAL
**                                                    AND koart NE 'K'.
**      LOOP AT lt_bkpf INTO DATA(ls_bkpf) WHERE xblnr = lr_acc->bktxt.
**        LOOP AT lt_acdocop INTO ls_acdocop WHERE belnr = ls_bkpf-belnr.
**          IF ls_acdocop-matnr IS NOT INITIAL.
**            lr_acc->matnr = ls_acdocop-matnr.
**            lr_acc->maktx = ls_acdocop-maktx.
**          ELSEIF ls_acdocop-matnr_copa IS NOT INITIAL.
**            lr_acc->matnr = ls_acdocop-matnr_copa.
**            lr_acc->maktx = ls_acdocop-maktx.
**          ENDIF.
**        ENDLOOP.
**      ENDLOOP.
**
**    ENDLOOP.



    LOOP AT lt_key INTO DATA(ls_key).

      READ TABLE lt_acdoca INTO DATA(ls_acdoca_k) WITH KEY belnr = ls_key-belnr
                                                         bukrs = ls_key-rbukrs
                                                         gjahr = ls_key-gjahr
                                                         "rldnr = ls_key-rldnr
                                                         koart = 'K'.




      IF ls_acdoca_k-lifnr IS NOT INITIAL
        AND ls_acdoca_k-lifnr IN s_lifnr
        AND ls_acdoca_k-drcrk EQ 'H'.


        ls_acdoca_k-wrbtr = ls_acdoca_k-wrbtr * -1.
        ls_acdoca_k-dmbtr = ls_acdoca_k-dmbtr * -1.
        ls_acdoca_k-dmbe2 = ls_acdoca_k-dmbe2 * -1.
        ls_acdoca_k-dmbe3 = ls_acdoca_k-dmbe3 * -1.

        CLEAR: lv_hsl_tot,
                lv_tsl_tot,
                lv_ksl_tot,
                lv_osl_tot.


        LOOP AT lt_acdoca INTO DATA(ls_acdoca_329) WHERE belnr  = ls_key-belnr
                                                    AND  bukrs  = ls_key-rbukrs
                                                    AND  gjahr  = ls_key-gjahr
                                                    AND  hkont  IN rt_racct.
          "  AND  rldnr    = ls_key-rldnr
          "  AND  ( hkont(3) = '329' OR hkont = '6020101005' OR hkont(3) = '153'
          "         OR hkont = '6020101002' OR hkont = '6020101001'   ) .



          CLEAR lv_vertut.
          lcl_main=>vergi_hesabi(
            EXPORTING
              iv_rbukrs = ls_acdoca_329-bukrs
              iv_mwskz  = ls_acdoca_329-mwskz
              iv_tut    = ls_acdoca_329-dmbtr
              iv_rtcur  = ls_acdoca_329-h_hwaer
            CHANGING
              lv_vertut = lv_vertut
          ).

          ls_acdoca_329-dmbtr = lv_vertut + ls_acdoca_329-dmbtr.


          CLEAR lv_vertut.
          lcl_main=>vergi_hesabi(
            EXPORTING
              iv_rbukrs = ls_acdoca_329-bukrs
              iv_mwskz  = ls_acdoca_329-mwskz
              iv_tut    = ls_acdoca_329-wrbtr
              iv_rtcur  = ls_acdoca_329-h_waers
            CHANGING
              lv_vertut = lv_vertut
          ).

          ls_acdoca_329-wrbtr = lv_vertut + ls_acdoca_329-wrbtr.

          CLEAR lv_vertut.
          lcl_main=>vergi_hesabi(
            EXPORTING
              iv_rbukrs = ls_acdoca_329-bukrs
              iv_mwskz  = ls_acdoca_329-mwskz
              iv_tut    = ls_acdoca_329-dmbe3
              iv_rtcur  = ls_acdoca_329-h_hwae3
            CHANGING
              lv_vertut = lv_vertut
          ).

          ls_acdoca_329-dmbe3 = lv_vertut + ls_acdoca_329-dmbe3.

          CLEAR lv_vertut.
          lcl_main=>vergi_hesabi(
            EXPORTING
              iv_rbukrs = ls_acdoca_329-bukrs
              iv_mwskz  = ls_acdoca_329-mwskz
              iv_tut    = ls_acdoca_329-dmbe2
              iv_rtcur  = ls_acdoca_329-h_hwae2
            CHANGING
              lv_vertut = lv_vertut
          ).

          ls_acdoca_329-dmbe2 = lv_vertut + ls_acdoca_329-dmbe2.


          APPEND INITIAL LINE TO gt_alv REFERENCE INTO DATA(lr_alv).

          lr_alv->lifnr   = ls_acdoca_k-lifnr.
          lr_alv->name1   = ls_acdoca_k-name1.
          lr_alv->belnr   = ls_acdoca_329-belnr.
          lr_alv->bukrs   = ls_acdoca_329-bukrs.
          lr_alv->dmbe2   = ls_acdoca_329-dmbe2.
          lr_alv->dmbe3   = ls_acdoca_329-dmbe3.
          lr_alv->dmbtr   = ls_acdoca_329-dmbtr.
          lr_alv->wrbtr   = ls_acdoca_329-wrbtr.
          lr_alv->gjahr   = ls_acdoca_329-gjahr.
          lr_alv->waers   = ls_acdoca_329-h_waers.
          lr_alv->maktx   = ls_acdoca_329-maktx.
          lr_alv->hkont   = ls_acdoca_329-hkont.
          lr_alv->matkl   = ls_acdoca_329-matkl.
          "lr_alv->werks   = ls_acdoca_329-werks.
          " lr_alv->menge   = ls_acdoca_329-menge.
          lr_alv->prdha   = ls_acdoca_329-prdha(4).
          lr_alv->mwskz   = ls_acdoca_329-mwskz.

          IF ls_acdoca_329-matnr IS NOT INITIAL.
            lr_alv->matnr   = ls_acdoca_329-matnr.
          ELSE.
            lr_alv->matnr   = ls_acdoca_329-matnr_copa.
          ENDIF.



          lv_tsl_tot = ls_acdoca_329-wrbtr + lv_tsl_tot.
          lv_hsl_tot = ls_acdoca_329-dmbtr + lv_hsl_tot.
          lv_ksl_tot = ls_acdoca_329-dmbe2 + lv_ksl_tot.
          lv_osl_tot = ls_acdoca_329-dmbe3 + lv_osl_tot.


        ENDLOOP.




        IF lv_hsl_tot  NE ls_acdoca_k-dmbtr.
*          lr_alv->dmbtr = lr_alv->dmbtr - ( lv_hsl_tot - ls_acdoca_k-dmbtr ).
          lv_fark = ( ls_acdoca_k-dmbtr + lv_hsl_tot  ) .
          LOOP AT gt_alv REFERENCE INTO lr_alv WHERE lifnr = ls_acdoca_k-lifnr
                                                 AND belnr = ls_acdoca_329-belnr
                                                 AND matnr = ls_acdoca_329-matnr
                                                 AND bukrs = ls_acdoca_329-bukrs.

            IF lv_hsl_tot NE 0.
              lr_alv->dmbtr = lr_alv->dmbtr / lv_hsl_tot * lv_fark + lr_alv->dmbtr.
            ENDIF.




          ENDLOOP.
          CLEAR lv_fark.
        ENDIF.

        IF lv_tsl_tot  NE ls_acdoca_k-wrbtr.
*          lr_alv->wrbtr = lr_alv->wrbtr - ( lv_tsl_tot - ls_acdoca_k-wrbtr ).
          lv_fark = ( ls_acdoca_k-wrbtr + lv_tsl_tot  ) .
          LOOP AT gt_alv REFERENCE INTO lr_alv WHERE lifnr = ls_acdoca_k-lifnr
                                                 AND belnr = ls_acdoca_329-belnr
                                                 AND matnr = ls_acdoca_329-matnr
                                                 AND bukrs = ls_acdoca_329-bukrs.
            IF lv_tsl_tot NE 0.
              lr_alv->wrbtr = lr_alv->wrbtr / lv_tsl_tot * lv_fark + lr_alv->wrbtr.
            ENDIF.

          ENDLOOP.
          CLEAR lv_fark.
        ENDIF.

        IF lv_osl_tot NE ls_acdoca_k-dmbe3.
*          lr_alv->dmbe3 = lr_alv->dmbe3 - ( lv_osl_tot - ls_acdoca_k-dmbe3 ).
          lv_fark = ( ls_acdoca_k-dmbe3 + lv_osl_tot  ) .
          LOOP AT gt_alv REFERENCE INTO lr_alv WHERE lifnr = ls_acdoca_k-lifnr
                                                 AND belnr = ls_acdoca_329-belnr
                                                 AND matnr = ls_acdoca_329-matnr
                                                 AND bukrs = ls_acdoca_329-bukrs.

            IF lv_osl_tot NE 0.
              lr_alv->dmbe3 = lr_alv->dmbe3 / lv_osl_tot * lv_fark + lr_alv->dmbe3.
            ENDIF.

          ENDLOOP.
          CLEAR lv_fark.
        ENDIF.

        IF lv_ksl_tot NE ls_acdoca_k-dmbe2.
*          lr_alv->dmbe2 = lr_alv->dmbe2 - ( lv_ksl_tot - ls_acdoca_k-dmbe2 ).
          lv_fark = ( ls_acdoca_k-dmbe2 + lv_ksl_tot  ) .
          LOOP AT gt_alv REFERENCE INTO lr_alv WHERE lifnr = ls_acdoca_k-lifnr
                                                 AND belnr = ls_acdoca_329-belnr
                                                 AND matnr = ls_acdoca_329-matnr
                                                 AND bukrs = ls_acdoca_329-bukrs.

            IF lv_ksl_tot NE 0.
              lr_alv->dmbe2 = lr_alv->dmbe2 / lv_ksl_tot * lv_fark + lr_alv->dmbe2.
            ENDIF.

          ENDLOOP.
          CLEAR lv_fark.
        ENDIF.

      ENDIF.
    ENDLOOP.

    DATA: lt_zzz TYPE TABLE OF zfi_odm_t_001.
    DATA: ls_zzz TYPE zfi_odm_t_001.


    DATA: lt_alv_ozet TYPE TABLE OF ty_data,
          ls_alv_ozet TYPE ty_data.

    DATA: lv_belnr TYPE zfi_odm_t_001-belnr,
          lv_matnr TYPE zfi_odm_t_001-matnr,
          lv_prdha TYPE zfi_odm_t_001-prdha,
          lv_lifnr TYPE zfi_odm_t_001-lifnr.



    LOOP AT gt_alv INTO DATA(ls_alv).

      MOVE-CORRESPONDING ls_alv TO ls_zzz.
      COLLECT ls_zzz INTO lt_zzz.

    ENDLOOP.

    "  MODIFY  zfi_odm_t_001 FROM TABLE lt_zzz.





  ENDMETHOD.  " get_data

*&---------------------------------------------------------------------*
*& process_data
*&---------------------------------------------------------------------*
  METHOD process_data .


  ENDMETHOD.  " process_data

*&---------------------------------------------------------------------*
*& vergi_hesabi
*&---------------------------------------------------------------------*
  METHOD vergi_hesabi .

    DATA: lt_mwdat TYPE TABLE OF rtax1u15.


    CALL FUNCTION 'CALCULATE_TAX_FROM_NET_AMOUNT'
      EXPORTING
        i_bukrs           = iv_rbukrs
        i_mwskz           = iv_mwskz
        i_waers           = iv_rtcur
        i_wrbtr           = iv_tut
      IMPORTING
*       E_FWNAV           =
*       E_FWNVV           =
        e_fwste           = lv_vertut
*       E_FWAST           =
      TABLES
        t_mwdat           = lt_mwdat
      EXCEPTIONS
        bukrs_not_found   = 1
        country_not_found = 2
        mwskz_not_defined = 3
        mwskz_not_valid   = 4
        ktosl_not_found   = 5
        kalsm_not_found   = 6
        parameter_error   = 7
        knumh_not_found   = 8
        kschl_not_found   = 9
        unknown_error     = 10
        account_not_found = 11
        txjcd_not_valid   = 12
        OTHERS            = 13.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.




  ENDMETHOD.  " vergi_hesabi


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
