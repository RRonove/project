*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFI_ODM_T_002...................................*
DATA:  BEGIN OF STATUS_ZFI_ODM_T_002                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFI_ODM_T_002                 .
CONTROLS: TCTRL_ZFI_ODM_T_002
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZFI_ODM_T_002                 .
TABLES: ZFI_ODM_T_002                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
