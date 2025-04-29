@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy tên đối tượng có thuế ngoại bảng'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_GETNAMECUS_NGOAIBANG as select distinct from I_OperationalAcctgDocItem as oadi
left outer join I_BillingDocument as bd on bd.BillingDocument = oadi.OriginalReferenceDocument
left outer join       I_Customer                as bpC on bpC.Customer =bd.PayerParty
    left outer join       I_Supplier                as bpS on bpS.Supplier = bd.PayerParty
{
  key oadi.CompanyCode,
  key oadi.AccountingDocument,
  key oadi.FiscalYear,
  key oadi.AccountingDocumentItem,
      case when concat_with_space(bpC.BusinessPartnerName2,concat_with_space(bpC.BusinessPartnerName3,bpC.BusinessPartnerName4,1),1) is null
                  then bpC.BusinessPartnerName1
                  else concat_with_space(bpC.BusinessPartnerName2,concat_with_space(bpC.BusinessPartnerName3,bpC.BusinessPartnerName4,1),1)
      end as NameC,
      case when concat_with_space(bpS.BusinessPartnerName2,concat_with_space(bpS.BusinessPartnerName3,bpS.BusinessPartnerName4,1),1) is null
                  then bpS.BusinessPartnerName1
                  else concat_with_space(bpS.BusinessPartnerName2,concat_with_space(bpS.BusinessPartnerName3,bpS.BusinessPartnerName4,1),1)
      end as NameSup,
      case when $projection.NameC is null
          then $projection.NameSup
          else $projection.NameC
      end as Name,
      //    add.TaxJurisdiction,
      //    oadi._busi
      //    bp.TaxNumber1 as Tax1,
      case
          when bpC.TaxNumber1 is null
          then bpS.TaxNumber1
          else bpC.TaxNumber1
      end as Tax,
      bd.PayerParty as Sup_Cus
}
where
  (
         oadi.GLAccount  like  'E%'
    
  )
