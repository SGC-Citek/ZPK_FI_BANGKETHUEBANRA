@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum Quantity Billing'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_SUMQ_BILLING as select from      I_BillingDocumentItemBasic   as bdib     
//left outer join       I_BillingDocumentItemBasic   as bdibbj      on  bdibbj.BillingDocument = je.DocumentReferenceID
{
    key bdib.BillingDocument,
    key bdib.Product,
    key bdib.TaxCode,  
//    case
//        when cast(sum(bdib.BillingQuantity)as abap.dec(12,2)) <> 0
//            then cast(sum(bdib.BillingQuantity)as abap.dec(12,2))
//        else
//            cast(sum(bdibbj.BillingQuantity)as abap.dec(12,2))
//        end as SoLuong
     bdib.BillingDocumentItemText,
     bdib.BillingQuantityUnit,
     @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
//     cast(
     (sum(bdib.BillingQuantity))
//     as abap.dec(12,2)) 
     as SoLuong
    
}
group by bdib.BillingDocument,bdib.Product,bdib.TaxCode
,BillingQuantityUnit
,BillingDocumentItemText

