@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy diễn giải bán hàng'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_GETTEXT
  as select distinct from I_JournalEntryItem        as jei

    inner join            I_OperationalAcctgDocItem as oadi on  oadi.CompanyCode        = jei.CompanyCode
                                                            and oadi.AccountingDocument = jei.AccountingDocument
                                                            and oadi.FiscalYear         = jei.FiscalYear
    left outer join            I_ProductDescription      as text on  text.Language = 'E'
                                                            and text.Product  = jei.Product
{
  key jei.CompanyCode,
  key jei.AccountingDocument,
  key jei.FiscalYear,
  key jei.AccountingDocumentItem,
      jei.GLAccount,
      jei.TransactionTypeDetermination,
      jei.Material as jeiMaterial,
      jei.Product  as jeiProduct,
      case
          when jei.Product is not null or jei.Product is not initial
              then text.ProductDescription
          else jei.DocumentItemText
      end          as DienGiai
}
where
  (
       jei.GLAccount like '00511%'
    or jei.GLAccount like '00711%'
  ) and jei.TransactionTypeDetermination = 'MWS'
