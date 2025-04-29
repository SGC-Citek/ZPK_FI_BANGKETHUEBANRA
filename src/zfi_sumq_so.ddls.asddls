@EndUserText.label: 'Sum Quantity SO'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_SUMQ_SO as select from I_SalesDocumentItem as sdi
{
    key sdi.SalesDocument,
    key sdi.SalesDocumentItem,
    key sdi.Product,
    sdi.SalesDocumentItemText,
    sdi.OrderQuantityUnit,
     @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
//    cast(
    sum(sdi.OrderQuantity)
//    as abap.dec(12,2)) 
    as SoLuong
    
}group by SalesDocument, SalesDocumentItem, Product
,OrderQuantityUnit
,SalesDocumentItemText
