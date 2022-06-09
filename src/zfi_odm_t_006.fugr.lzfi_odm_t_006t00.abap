*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFI_ODM_T_006...................................*
DATA:  BEGIN OF STATUS_ZFI_ODM_T_006                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFI_ODM_T_006                 .
CONTROLS: TCTRL_ZFI_ODM_T_006
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZFI_ODM_T_006                 .
TABLES: ZFI_ODM_T_006                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
