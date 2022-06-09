*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFI_ODM_T_005...................................*
DATA:  BEGIN OF STATUS_ZFI_ODM_T_005                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFI_ODM_T_005                 .
CONTROLS: TCTRL_ZFI_ODM_T_005
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZFI_ODM_T_005                 .
TABLES: ZFI_ODM_T_005                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
