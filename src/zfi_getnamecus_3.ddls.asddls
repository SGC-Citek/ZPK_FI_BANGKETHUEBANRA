@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy tên người mua ưu tiên 3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_GETNAMECUS_3  as select distinct from I_OperationalAcctgDocItem as oadi
  //inner join I_OperationalAcctgDocTaxItem as oadti on oadti.AccountingDocument = oadi.AccountingDocument
  //                                                and oadti.CompanyCode = oadi.CompanyCode
  //                                                and oadti.FiscalYear  = oadi.FiscalYear
  //                                                and oadti.TaxItem = oadi.TaxItemGroup
    left outer join       I_Customer                as cus on cus.Customer           = oadi.Customer
//                                                                and(
//                                                                  supplier.IsOneTimeAccount    is null
//                                                                  or supplier.IsOneTimeAccount is initial
//                                                                )
//                                                                )
 left outer join       I_OneTimeAccountCustomer                as customer on customer.CompanyCode = oadi.CompanyCode
                                                                            and customer.AccountingDocument = oadi.AccountingDocument
                                                                            and customer.FiscalYear = oadi.FiscalYear
                                                                            and customer.AccountingDocumentItem = oadi.AccountingDocumentItem
left outer join I_CustomerAccountGroupText as cagt on cagt.CustomerAccountGroup = cus.CustomerAccountGroup
                                                      and  cagt.Language = 'E'                                                                           

{
  key oadi.CompanyCode,
  key oadi.AccountingDocument,
  key oadi.FiscalYear,
  key oadi.AccountingDocumentItem,
      oadi.FinancialAccountType,
     
      concat_with_space(customer.BusinessPartnerName1,
      concat_with_space(customer.BusinessPartnerName2,
      concat_with_space(customer.BusinessPartnerName3,
      customer.BusinessPartnerName4,1),1),1)  as nameCustomer,

      $projection.nameCustomer       as name3,
      

      customer.TaxID1  as Tax3,
     case
        when customer.StreetAddressName = ''
           then customer.CityName
        when customer.CityName = ''
           then customer.StreetAddressName     
        else
            concat(customer.StreetAddressName,concat_with_space(',',customer.CityName,1))
        end as Diachi3,
      oadi.Customer,
      oadi.TaxCode,
      case
        when oadi.Supplier is null or oadi.Supplier is initial
            then oadi.Customer
        else oadi.Supplier
     end as Sup_Cus,
     cagt.CustomerAccountGroup as AccountGroup3
}
where ( cus.IsOneTimeAccount <> '' or oadi.AddressAndBankIsSetManually <> '' ) and
//where
     (oadi.FinancialAccountType = 'D')
