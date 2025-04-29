@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy tên người mua ưu tiên 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_GETNAMECUS_2
as select distinct from I_OperationalAcctgDocItem as oadi
left outer join I_Customer as customer on customer.Customer = oadi.Customer
left outer join I_Address_2 as addr  on addr.AddressID = customer.AddressID  
left outer join I_CustomerAccountGroupText as cagt on cagt.CustomerAccountGroup = customer.CustomerAccountGroup
                                                      and  cagt.Language = 'E'
{
    key oadi.CompanyCode,
    key oadi.AccountingDocument,
    key oadi.FiscalYear,
    key oadi.AccountingDocumentItem,
    oadi.AlternativePayeePayer,
    
    case 
        when concat_with_space(customer.BusinessPartnerName2,concat_with_space(customer.BusinessPartnerName3,customer.BusinessPartnerName4,1),1) = ''
         then customer.BusinessPartnerName1
     else concat_with_space(customer.BusinessPartnerName2,concat_with_space(customer.BusinessPartnerName3,customer.BusinessPartnerName4,1),1)
        end  as name2,

        customer.TaxNumber1 as Tax2,                                                                                                                                                  
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
        end as Diachi2,    
    oadi.AlternativePayeePayer as Sup_Cus,
    cagt.CustomerAccountGroup as AccountGroup2
}
//where((oadi.Supplier <> '') and (oadi.AlternativePayeePayer <> '') and (oadi.FinancialAccountType = 'K'))
//where (oadi.AlternativePayeePayer <> '' ) 
//
where (customer.IsOneTimeAccount = '' and oadi.AddressAndBankIsSetManually = '' ) and 
 (oadi.FinancialAccountType = 'D')
