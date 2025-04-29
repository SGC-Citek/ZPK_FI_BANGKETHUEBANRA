CLASS zcl_calculate_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
    DATA: g_entity TYPE string.
    DATA: gt_data TYPE TABLE OF zfi_i_bangkethuebanra,
          gt_tmp  LIKE gt_data,
          gs_tmp  TYPE zfi_i_bangkethuebanra.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CALCULATE_DATA IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    IF g_entity = 'ZFI_I_BANGKETHUEBANRA'.
      gt_data = CORRESPONDING #( it_original_data ).

      SORT gt_data BY accountingdocument accountingdocumentitem.
      SELECT DISTINCT *
      FROM @gt_data AS data
      WHERE glaccount LIKE '511%' OR glaccount LIKE '711%'
      ORDER BY accountingdocument ,accountingdocumentitem
      INTO TABLE @gt_tmp.

*      DATA(lt_data) = gt_data.
*      SORT lt_data BY accountingdocument.
*      DELETE ADJACENT DUPLICATES FROM lt_data COMPARING accountingdocument.

      LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
        READ TABLE gt_tmp INTO DATA(gs_tmp) WITH KEY accountingdocument = <fs_data>-accountingdocument BINARY SEARCH.
        IF sy-subrc = 0.
            <fs_data>-glaccount_dt = gs_tmp-glaccount.
        ENDIF.
      ENDLOOP.
      UNASSIGN: <fs_data>.
      ct_calculated_data = CORRESPONDING #( gt_data ).

    ENDIF.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    g_entity = iv_entity.
  ENDMETHOD.
ENDCLASS.
