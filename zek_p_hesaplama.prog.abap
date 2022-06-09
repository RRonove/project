*&---------------------------------------------------------------------*
*& Report ZEK_P_HESAPLAMA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zek_p_hesaplama.
WRITE 'Hello World'.
DATA tarih LIKE sy-datum.
WRITE :/,tarih.
DATA zaman TYPE t.
WRITE :/,zaman.
tarih = sy-datum.
zaman = sy-uzeit.
WRITE :/ tarih , zaman.
