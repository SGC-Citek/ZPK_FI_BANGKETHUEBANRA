CLASS zcl_get_long_text_fi DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
      INTERFACES if_sadl_exit_calc_element_read .
    DATA: g_entity TYPE string.
    CONSTANTS: gc_comm_scenario TYPE if_com_management=>ty_cscn_id VALUE 'ZCORE_CS_SAP',
               gc_service_id    TYPE if_com_management=>ty_cscn_outb_srv_id VALUE 'Z_API_SAP_REST'.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GET_LONG_TEXT_FI IMPLEMENTATION.


 METHOD if_sadl_exit_calc_element_read~calculate.
    IF g_entity = 'ZFI_I_BANGKETHUEBANRA'.
      DATA: lt_thueban TYPE STANDARD TABLE OF ZFI_I_BANGKETHUEBANRA WITH DEFAULT KEY
*            lt_thuebannonull TYPE STANDARD TABLE OF ZFI_I_BANGKETHUEBANRA WITH DEFAULT KEY
            .
      lt_thueban = CORRESPONDING #( it_original_data ).
*      Loop at lt_thueban into data(ls_thuebantemp) WHERE BillingDocument is not INITIAL.
*        APPEND ls_thuebantemp to lt_thuebannonull.
*      ENDLOOP.
      DATA(lt_note) = CORRESPONDING zcore_cl_get_long_text=>ty_billing( lt_thueban DISCARDING DUPLICATES ).
      DATA(lt_noteheadertext) = zcore_cl_get_long_text=>get_multi_billing_header_text( it_billing = lt_note ).

*       Loop at lt_noteheadertext ASSIGNING FIELD-SYMBOL(<ls_noteheadertext>).
*        <ls_noteheadertext>-billing_document = |{ <ls_noteheadertext>-billing_document ALPHA = IN }|.
*       ENDLOOP.

      LOOP AT lt_thueban REFERENCE INTO DATA(ls_thueban).
*      if ( ls_thueban->BillingDocument is not INITIAL ).
        READ TABLE lt_noteheadertext REFERENCE INTO DATA(ls_note)
        WITH KEY billing_document  = ls_thueban->BillingDocumentNote
                 long_text_id = 'Z002'
                 language = 'EN'.
*     ELSE.
*        READ TABLE lt_noteheadertext REFERENCE INTO ls_note
*        WITH KEY billing_document  = ls_thueban->DocumentReferenceID
*                 long_text_id = 'Z002'
*                 language = 'EN'.
*     ENDIF.
        IF sy-subrc = 0.
            ls_thueban->GhiChu  = ls_note->long_text.
        ENDIF.
      ENDLOOP.

      ct_calculated_data = CORRESPONDING #( lt_thueban ).
    ENDIF.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    g_entity = iv_entity.
  ENDMETHOD.
ENDCLASS.
