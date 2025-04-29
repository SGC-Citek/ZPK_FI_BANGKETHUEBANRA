@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy tên người mua ưu tiên 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_GETNAMECUS_1
  as select distinct from I_OperationalAcctgDocItem as oadi
    left outer join       I_Customer                as bpC on bpC.Customer = oadi.AlternativePayeePayer
     left outer join I_Address_2 as addr  on addr.AddressID = bpC.AddressID   
     left outer join I_CustomerAccountGroupText as cagt on cagt.CustomerAccountGroup = bpC.CustomerAccountGroup
                                                      and  cagt.Language = 'E'
{
  key oadi.CompanyCode,
  key oadi.AccountingDocument,
  key oadi.FiscalYear,
  key oadi.AccountingDocumentItem,
      case when concat_with_space(bpC.BusinessPartnerName2,concat_with_space(bpC.BusinessPartnerName3,bpC.BusinessPartnerName4,1),1) = ''
                  then bpC.BusinessPartnerName1
                  else concat_with_space(bpC.BusinessPartnerName2,concat_with_space(bpC.BusinessPartnerName3,bpC.BusinessPartnerName4,1),1)
      end as Name1,      
      //    add.TaxJurisdiction,
      //    oadi._busi
      //    bp.TaxNumber1 as Tax1,

     bpC.TaxNumber1 as Tax1,
     case
        when addr.StreetName = '' and addr.DistrictName <> '' and addr.CityName <> ''
           then concat(addr.DistrictName,concat_with_space(',',addr.CityName,1))
        when addr.DistrictName = '' and addr.StreetName <> '' and addr.CityName <> ''
           then concat(addr.StreetName,concat_with_space(',',addr.CityName,1))
        when addr.CityName = '' and addr.StreetName <> '' and addr.DistrictName <> ''
           then concat(addr.StreetName,concat_with_space(',',addr.DistrictName,1))
        when addr.StreetName = '' and addr.DistrictName = ''
           then addr.CityName
        when addr.StreetName = '' and addr.CityName = ''
           then addr.DistrictName
        when addr.DistrictName = '' and addr.CityName = ''
           then addr.StreetName
        else
            concat(addr.StreetName,concat_with_space(',',concat(addr.DistrictName,concat_with_space(',',addr.CityName,1)),1))
        end as Diachi1,
      oadi.AlternativePayeePayer,
      oadi.AlternativePayeePayer as Sup_Cus,
      cagt.CustomerAccountGroup as AccountGroup1
}
where
  (
    (
         oadi.AlternativePayeePayer <> ''
    )
    and(
         oadi.FinancialAccountType  =  'D'     
    )
  )
