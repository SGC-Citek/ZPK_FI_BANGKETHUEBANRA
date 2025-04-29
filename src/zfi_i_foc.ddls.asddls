@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy thông tin hàng FOC'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_FOC
  as select distinct from I_BillingDocument          as bd
    inner join            I_BillingDocumentItemBasic as bdi     on  bdi.BillingDocument         =    bd.BillingDocument
                                                                and bd.DistributionChannel      like '80'
                                                                and (bd.Division                 like '03' or  bd.Division                 like '04')
                                                                and bd.CancelledBillingDocument =    ''
                                                                and bd.AccountingDocument       =    ''
                                                                and bd.BillingDocumentIsCancelled = ''
  //                                             and bdi.BillingDocumentItem = bd.Billing
    left outer join       ZFI_TAXCODE                as taxCode on taxCode.Taxcode = bdi.TaxCode
  association [0..1] to I_Customer as _PayerParty on $projection.Sup_Cus = _PayerParty.Customer
{
  key bd.BillingDocument                       as AccountingDocument,
  key bdi.BillingDocumentItem,
  key bd.CompanyCode,
      bd.FiscalYear,
      bd.DocumentReferenceID,
      bd.BillingDocumentDate,
      bd.PayerParty                            as Sup_Cus,
      case when concat_with_space(bd._PayerParty.BusinessPartnerName2,concat_with_space(bd._PayerParty.BusinessPartnerName3,bd._PayerParty.BusinessPartnerName4,1),1) = ''
                   then bd._PayerParty.BusinessPartnerName1
               else concat_with_space(bd._PayerParty.BusinessPartnerName2,concat_with_space(bd._PayerParty.BusinessPartnerName3,bd._PayerParty.BusinessPartnerName4,1),1)

      end                                      as TenNguoiMua,
      bd._PayerParty.TaxNumber1                as MSTNguoiMua,
      bdi.BillingDocumentItemText              as MatHang,
      bdi.TaxCode,
      bdi._ProfitCenter._Text.ProfitCenterName as ProfitCenter,
      bd.CreatedByUser                         as UserName,
      bd.LastChangeDate,
      ''                                       as DienGiai,
      bd.BillingDocumentDate                   as NgayPhatHanh,
      bd.CreationDate                          as AccountingDocumentCreationDate,
      bd.CreationDate                          as PostingDate,
      bd._CreatedByUser.UserDescription,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast('0' as abap.curr( 23, 2 ))          as TaxBaseAmountInTransCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast('0' as abap.curr( 23, 2 ))          as GTGT,
      bd.TransactionCurrency,
      ''                                       as GLAccount,
      taxCode.Value,
      taxCode.Taxgroup,
      taxCode.Rtype,
      _PayerParty
}
