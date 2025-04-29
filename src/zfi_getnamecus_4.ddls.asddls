@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy tên người mua ưu tiên 4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_GETNAMECUS_4
  as select distinct from I_OperationalAcctgDocItem  as oadi
    left outer join       I_JournalEntryItem         as jei        on  jei.AccountingDocument     = oadi.AccountingDocument
                                                                   and jei.AccountingDocumentItem = oadi.AccountingDocumentItem
                                                                   and jei.CompanyCode            = oadi.CompanyCode
                                                                   and jei.FiscalYear             = oadi.FiscalYear
    left outer join       I_SalesDocument            as sd         on jei.SalesDocument = sd.SalesDocument
    left outer join       I_Customer                 as customer   on customer.Customer = jei.Customer
    left outer join       I_Customer                 as customerso on customerso.Customer = sd.SoldToParty
    left outer join       I_Address_2                as addr       on addr.AddressID = customer.AddressID
    left outer join       I_Address_2                as addrso     on addrso.AddressID = customerso.AddressID
    left outer join       I_CustomerAccountGroupText as cagt       on  cagt.CustomerAccountGroup = customer.CustomerAccountGroup
                                                                   and cagt.Language             = 'E'
    left outer join       I_CustomerAccountGroupText as cagtso     on  cagtso.CustomerAccountGroup = customerso.CustomerAccountGroup
                                                                   and cagtso.Language             = 'E'

{
  key oadi.CompanyCode,
  key oadi.AccountingDocument,
  key oadi.FiscalYear,
  key oadi.AccountingDocumentItem,
      oadi.FinancialAccountType,
      case
            when concat_with_space(customer.BusinessPartnerName2,concat_with_space(customer.BusinessPartnerName3,customer.BusinessPartnerName4,1),1) = ''
             then customer.BusinessPartnerName1
         else concat_with_space(customer.BusinessPartnerName2,concat_with_space(customer.BusinessPartnerName3,customer.BusinessPartnerName4,1),1)
            end             as name_tmp1,

      case
            when concat_with_space(customerso.BusinessPartnerName2,concat_with_space(customerso.BusinessPartnerName3,customerso.BusinessPartnerName4,1),1) = ''
             then customerso.BusinessPartnerName1
         else concat_with_space(customerso.BusinessPartnerName2,concat_with_space(customerso.BusinessPartnerName3,customerso.BusinessPartnerName4,1),1)
            end             as name_tmp2,

      case
        when jei.Customer is not initial
            then $projection.name_tmp1
        else
             $projection.name_tmp2
      end                   as name4,
      //      '' as name4,


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
       end                  as Diachi_tpm1,

      case
      when addrso.StreetName = '' and addrso.DistrictName <> '' and addrso.CityName <> ''
         then concat(addrso.DistrictName,concat_with_space(',',addrso.CityName,1))
      when addrso.DistrictName = '' and addrso.StreetName <> '' and addrso.CityName <> ''
         then concat(addrso.StreetName,concat_with_space(',',addrso.CityName,1))
      when addrso.CityName = '' and addrso.StreetName <> '' and addrso.DistrictName <> ''
         then concat(addrso.StreetName,concat_with_space(',',addrso.DistrictName,1))
      when addrso.StreetName = '' and addrso.DistrictName = ''
         then addrso.CityName
      when addrso.StreetName = '' and addrso.CityName = ''
         then addrso.DistrictName
      when addrso.DistrictName = '' and addrso.CityName = ''
         then addrso.StreetName
      else
          concat(addrso.StreetName,concat_with_space(',',concat(addrso.DistrictName,concat_with_space(',',addrso.CityName,1)),1))
      end                   as Diachi4_tmp2,

      case
      when jei.Customer is not initial
         then $projection.Diachi_tpm1
      else
          $projection.Diachi4_tmp2
      end                   as Diachi4,

      //      '' as Diachi4,

      customer.TaxNumber1   as Tax4_tmp1,
      customerso.TaxNumber1 as Tax4_tmp2,
      case
      when jei.Customer is not initial
         then $projection.Tax4_tmp1
      else
          $projection.Tax4_tmp2
      end                   as Tax4,

      case
      when jei.Customer is not initial
        then cagt.CustomerAccountGroup
      else
          cagtso.CustomerAccountGroup
      end                   as AccountGroup4

}
where
  oadi.FinancialAccountType <> 'D'
