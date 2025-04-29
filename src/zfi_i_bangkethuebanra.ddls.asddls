@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bảng kê hoá đơn,chứng từ,dịch vụ bán ra'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_I_BANGKETHUEBANRA
  with parameters
    @Environment.systemField:#SYSTEM_DATE
    @EndUserText.label: 'From Date'
    FromDate : vdm_v_key_date,
    @Environment.systemField:#SYSTEM_DATE
    @EndUserText.label: 'To Date'
    ToDate   : vdm_v_key_date
  as select distinct from I_JournalEntry               as je
    inner join            I_OperationalAcctgDocItem    as oadi      on  oadi.CompanyCode        = je.CompanyCode
                                                                    and oadi.AccountingDocument = je.AccountingDocument
                                                                    and oadi.FiscalYear         = je.FiscalYear
    left outer join       I_OperationalAcctgDocTaxItem as taxAmount on  taxAmount.CompanyCode        = je.CompanyCode
                                                                    and taxAmount.AccountingDocument = je.AccountingDocument
                                                                    and taxAmount.FiscalYear         = je.FiscalYear
                                                                    and (
                                                                       taxAmount.TaxCode             = oadi.TaxCode
                                                                       or oadi.TaxCode               = '**'
                                                                       or oadi.TaxCode               = ''
                                                                     )
    left outer join       I_JournalEntryItem           as jei       on  jei.AccountingDocument     = oadi.AccountingDocument
                                                                    and jei.AccountingDocumentItem = oadi.AccountingDocumentItem
                                                                    and jei.CompanyCode            = oadi.CompanyCode
                                                                    and jei.FiscalYear             = oadi.FiscalYear
    left outer join       I_SalesDocumentItem          as sdi       on  jei.SalesDocument     = sdi.SalesDocument
                                                                    and jei.SalesDocumentItem = sdi.SalesDocumentItem
  //             or(
  //               bdib.BillingDocument                                                                = oadi.OriginalReferenceDocument
  //             )
  //           )
  //                                                                    and (
  //                                                                       bdib.BillingDocumentItem    = concat(
  //                                                                         concat(
  //                                                                           '00', oadi.AccountingDocumentItem
  //                                                                         ), '0'
  //                                                                       )
  //                                                                       or bdib.BillingDocumentItem = concat(
  //                                                                         '000', oadi.AccountingDocumentItem
  //                                                                       )
  //                                                                     )

    left outer join       I_ProductText                as matHang   on  matHang.Language = 'E'
                                                                    and matHang.Product  = jei.Product
  //and bdib.SalesDocumentItem = oadi.SalesDocumentItem
  //    left outer join       ZFI_GETNAMECUS_1       as uuTien1   on je.OriginalReferenceDocument = uuTien1.SupplierInvoiceWthnFiscalYear // concat(uuTien1.SupplierInvoice,uuTien1.FiscalYear)
    left outer join       ZFI_GETNAMECUS_NGOAIBANG     as uuTienNB  on  uuTienNB.AccountingDocument     = je.AccountingDocument
                                                                    and uuTienNB.CompanyCode            = je.CompanyCode
                                                                    and uuTienNB.FiscalYear             = je.FiscalYear
                                                                    and uuTienNB.AccountingDocumentItem = oadi.AccountingDocumentItem
    left outer join       ZFI_GETNAMECUS_1             as uuTien1   on  uuTien1.AccountingDocument     = je.AccountingDocument
                                                                    and uuTien1.CompanyCode            = je.CompanyCode
                                                                    and uuTien1.FiscalYear             = je.FiscalYear
//                                                                    and uuTien1.AccountingDocumentItem = oadi.AccountingDocumentItem
    left outer join       ZFI_GETNAMECUS_2             as uuTien2   on  uuTien2.AccountingDocument     = je.AccountingDocument
                                                                    and uuTien2.CompanyCode            = je.CompanyCode
                                                                    and uuTien2.FiscalYear             = je.FiscalYear
//                                                                    and uuTien2.AccountingDocumentItem = oadi.AccountingDocumentItem
    left outer join       ZFI_GETNAMECUS_3             as uuTien3   on  uuTien3.AccountingDocument     = je.AccountingDocument
                                                                    and uuTien3.CompanyCode            = je.CompanyCode
                                                                    and uuTien3.FiscalYear             = je.FiscalYear
//                                                                    and uuTien3.AccountingDocumentItem = oadi.AccountingDocumentItem
    left outer join       ZFI_GETNAMECUS_4             as uuTien4   on  uuTien4.AccountingDocument     = je.AccountingDocument
                                                                    and uuTien4.CompanyCode            = je.CompanyCode
                                                                    and uuTien4.FiscalYear             = je.FiscalYear
//                                                                    and uuTien4.AccountingDocumentItem = oadi.AccountingDocumentItem

    left outer join       ZFI_TAXCODE                  as taxCode   on taxCode.Taxcode = taxAmount.TaxCode

    left outer join       I_CompanyCode                as compc     on compc.CompanyCode = je.CompanyCode
    left outer join       I_OrganizationAddress        as compadd   on compadd.AddressID = compc.AddressID
    left outer join       I_Customer                   as cus       on cus.Customer = oadi.Customer
    left outer join       I_Address_2                  as addr      on addr.AddressID = cus.AddressID
    left outer join       I_BillingDocumentItemBasic   as bdib      on  bdib.BillingDocument = oadi.BillingDocument
                                                                    and bdib.TaxCode         = taxAmount.TaxCode
    left outer join       I_BillingDocumentItemBasic   as bdibbj    on  bdibbj.BillingDocument = je.DocumentReferenceID
                                                                    and bdibbj.TaxCode         = taxAmount.TaxCode   
    left outer join       I_ProductGroupText_2         as prdtgr     on prdtgr.ProductGroup = bdib.ProductGroup
    left outer join       I_ProductGroupText_2         as prdtgrso     on prdtgrso.ProductGroup = sdi.ProductGroup                                                                                                                               
    left outer join       ZFI_SUMQ_BILLING             as sumq      on  sumq.BillingDocument = oadi.BillingDocument
                                                                    and sumq.TaxCode         = taxAmount.TaxCode
                                                                    and sumq.BillingQuantityUnit = bdib.BillingQuantityUnit
                                                                    and sumq.BillingDocumentItemText = bdib.BillingDocumentItemText
                                                                    and sumq.Product = bdib.Product
  //                                                                    and sumq.Product         = oadi.Product
    left outer join       ZFI_SUMQ_BILLING             as sumqbje   on  sumqbje.BillingDocument = je.DocumentReferenceID
                                                                    and sumqbje.TaxCode         = taxAmount.TaxCode
  //                                                                    and sumqbje.Product         = oadi.Product
    left outer join       ZFI_SUMQ_SO                  as sumqso    on  sumqso.SalesDocument     = sdi.SalesDocument
                                                                    and sumqso.SalesDocumentItem = sdi.SalesDocumentItem
                                                                    and sumqso.SalesDocumentItemText = sdi.SalesDocumentItemText
                                                                    and sumqso.Product = sdi.Product
    left outer join       I_UnitOfMeasure              as uombl     on uombl.UnitOfMeasure = bdib.BillingQuantityUnit
  //    left outer join       I_UnitOfMeasure              as uomblbj   on uomblbj.UnitOfMeasure = bdibbj.BillingQuantityUnit
    left outer join       I_UnitOfMeasure              as uomso     on uomso.UnitOfMeasure = sdi.OrderQuantityUnit

{
         @Search.defaultSearchElement: true
         @Consumption.valueHelpDefinition: [{ entity : { name: 'I_CompanyCodeStdVH', element: 'CompanyCode'},
         distinctValues : true
         }]
  key    je.CompanyCode,
  key    je.FiscalYear,
  key    je.AccountingDocument, // số chứng từ
  key    oadi.AccountingDocumentItem,
  key    taxAmount.TaxCode,
         oadi.SalesDocument,
         taxAmount.TransactionTypeDetermination,
         je._CompanyCode.CompanyCodeName, //bc2
         je._CompanyCode.VATRegistration, //bc3
         je.DocumentReferenceID, //bc7  // Số hóa đơn
         je.DocumentDate                                                            as NgayPhatHanh, //bc8 // Ngày hóa đơn
         case
         //            when uuTienNB.Name <>''
         //                then uuTienNB.Name
             when uuTien1.Name1 <> ''
                 then uuTien1.Name1
             when uuTien2.name2 <> ''
                 then uuTien2.name2
             when uuTien3.name3 <> ''
                 then uuTien3.name3
             else
                  uuTien4.name4
         //Lây đối tượng từ billing
         //             when concat_with_space(bdib._ShipToParty.BusinessPartnerName2,concat_with_space(bdib._ShipToParty.BusinessPartnerName3,bdib._ShipToParty.BusinessPartnerName4,1),1) = ''
         //                 then bdib._ShipToParty.BusinessPartnerName1
         //             else concat_with_space(bdib._ShipToParty.BusinessPartnerName2,concat_with_space(bdib._ShipToParty.BusinessPartnerName3,bdib._ShipToParty.BusinessPartnerName4,1),1)

         end                                                                        as TenNguoiMua,
         uuTien1.Name1,
         uuTien2.name2,
         //         uuTien3.name3,
         uuTien4.name4,
         //         uuTien5.name5,
         case
         //            when uuTienNB.Tax <> ''
         //                then uuTienNB.Tax
             when uuTien1.Tax1 <> ''
                 then uuTien1.Tax1
             when uuTien2.Tax2 <> ''
                 then uuTien2.Tax2
             when uuTien3.Tax3 <> ''
                 then uuTien3.Tax3
             else
                  uuTien4.Tax4
         //             when bdib._ShipToParty.TaxNumber1 <>''
         //                then bdib._ShipToParty.TaxNumber1
         end                                                                        as MSTNguoiMua,
         case
             when uuTien1.Diachi1 <> ''
                 then uuTien1.Diachi1
             when uuTien2.Diachi2 <> ''
                 then uuTien2.Diachi2
             when uuTien3.Diachi3 <> ''
                 then uuTien3.Diachi3
             else
                 uuTien4.Diachi4
         end                                                                        as Diachi,
         @Search.defaultSearchElement: true
         @Consumption.valueHelpDefinition: [{ entity : { name: 'ZFI_ACCOUNTGROUP_SH', element: 'CustomerAccountGroup'},
         distinctValues : true
         }]
         case
             when uuTien1.AccountGroup1 <> ''
                 then uuTien1.AccountGroup1
             when uuTien2.AccountGroup2 <> ''
                 then uuTien2.AccountGroup2
             when uuTien3.AccountGroup3 <> ''
                 then uuTien3.AccountGroup3
             else
                 uuTien4.AccountGroup4
         end                                                                        as AccountGroup,
         //         case
         //            when uuTienNB.Sup_Cus <> ''
         //                then uuTienNB.Sup_Cus
         //             when uuTien1.Sup_Cus <> ''
         //                 then uuTien1.Sup_Cus
         //             when uuTien2.Sup_Cus <> ''
         //                 then uuTien2.Sup_Cus
         //             when uuTien3.Sup_Cus <> ''
         //                 then uuTien3.Sup_Cus
         //             when bdib.ShipToParty <>''
         //                then bdib.ShipToParty
         //         end                                                                        as Sup_Cus,
         @EndUserText.label: 'Posting Period'
         je.FiscalPeriod,
         @Search.defaultSearchElement: true
         je.PostingDate, // ngày chứng từ
         je.AccountingDocCreatedByUser                                              as UserName, //bc21
         taxAmount.DebitCreditCode,
         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         case
            when taxAmount.TaxCode like 'XX'
                then cast('0' as abap.curr( 23, 2 ))
            else taxAmount.TaxBaseAmountInCoCodeCrcy
         end                                                                        as TaxBaseAmountInCoCodeCrcy, //bc11
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         taxAmount.TaxBaseAmountInTransCrcy as TaxBaseAmountInTransCrcy,
         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         taxAmount.TaxAmountInCoCodeCrcy                                            as GTGT, //bc12
         oadi.TaxType,
         taxCode.Value,
         taxCode.Taxgroup,
         taxCode.Rtype,
         //         case
         //            when (oadi.FinancialAccountType = 'D' or oadi.FinancialAccountType = 'K') and oadi.DocumentItemText <> ''
         //                then oadi.DocumentItemText
         //            when (oadi.FinancialAccountType <> 'D' or oadi.FinancialAccountType <> 'K') and oadi.DocumentItemText <> '' and (oadi.GLAccount like '0011%' or oadi.GLAccount like 'E%')
         //                then oadi.DocumentItemText
         //            when je.AccountingDocumentHeaderText <>''
         //                then je.AccountingDocumentHeaderText
         //         end                                                                        as DienGiai,

         //         case
         //            when matHang.ProductName <> ''
         //                then matHang.ProductName
         //            else         bdib.BillingDocumentItemText
         //         end as MatHang,
         case
             when bdib.BillingDocumentItemText <> ''
                 then bdib.BillingDocumentItemText
         //             when bdibbj.BillingDocumentItemText <> ''
         //                 then bdibbj.BillingDocumentItemText
             else
                 sdi.SalesDocumentItemText
             end                                                                    as MatHang,
         case
             when bdib.Product <> ''
                 then bdib.Product
         //             when bdibbj.Product <> ''
         //                then bdibbj.Product
             else
                 sdi.Product
             end                                                                    as Product,
         
         case
             when prdtgr.ProductGroupName <> ''
                 then prdtgr.ProductGroupName
             else
                 prdtgrso.ProductGroupName
             end                                                                    as ProductGroupName,
         
         
         case
            when bdib.BillingDocument is null and je.DocumentReferenceID  like '00%'
                then je.DocumentReferenceID
            else bdib.BillingDocument
         end                                                                        as BillingDocumentNote,

         bdib.BillingDocument,
//         bdib.BillingDocumentItem,
         bdib.TaxCode                                                               as TaxCode2,
         //         case
         //            when jei.Quantity <> 0
         //                then cast(jei.Quantity as abap.dec(12,2))
         //            else
         //                cast(bdib.BillingQuantity as abap.dec(12,2))
         //         end as SoLuong,
         bdib.BillingQuantityUnit,
         case
            when sumq.SoLuong <> 0
                then sumq.BillingQuantityUnit
//                     when sumqbje.SoLuong <> 0
//                         then
         //                    sumqbje.SoLuong
                     else
                         sumqso.OrderQuantityUnit
         end                                                                        as Unit,         
         @Semantics.quantity.unitOfMeasure: 'Unit'
         case
            when sumq.SoLuong <> 0
                then sumq.SoLuong
//                     when sumqbje.SoLuong <> 0
//                         then
         //                    sumqbje.SoLuong
                     else
                         sumqso.SoLuong
         end                                                                        as SoLuong,
//         sumq.SoLuong                                                               as SL1,
//         sumqbje.SoLuong                                                            as SL2,
         ////         case
         //            when jei.BaseUnit <> ' '
         //                then uomje.UnitOfMeasure_E
         //            else
         //                uombl.UnitOfMeasure_E
         //        end as DVT,
         case
            when uombl.UnitOfMeasure_E <> ''
                then uombl.UnitOfMeasure_E
         //            when uomblbj.UnitOfMeasure_E <> ''
         //                then uomblbj.UnitOfMeasure_E
            else
                uomso.UnitOfMeasure_E
         end                                                                        as DVT,
         uombl.UnitOfMeasure_E                                                      as unit1,
         uomso.UnitOfMeasure_E                                                      as unit2,
         taxAmount.CompanyCodeCurrency,
         taxAmount.TransactionCurrency,
         je._User.UserDescription,
         je.LastChangeDate,
         je.AccountingDocumentCreationDate,
         //         case when oadi.FinancialAccountType <> 'D' and oadi.GLAccount not like '00333%'
         //            then oadi._ProfitCenter._Text.ProfitCenterName
         //         end                                                                        as ProfitCenter,
         @Search.defaultSearchElement: true
         @Consumption.valueHelpDefinition: [{ entity : { name: 'ZFI_GLACCOUNT_SH', element: 'GLAccount'},
         distinctValues : true
         }]
         oadi.GLAccount,
         concat_with_space( compadd.AddresseeName1,
         concat_with_space( compadd.AddresseeName2,
         concat_with_space( compadd.AddresseeName3,compadd.AddresseeName4 ,1),1),1) as Company, //cong ty
         @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GET_LONG_TEXT_FI'
         cast('' as abap.char( 1000 ))                                              as GhiChu,
         oadi.DocumentItemText,
         je.AccountingDocumentHeaderText,
         @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CALCULATE_DATA'
         cast('' as abap.char( 1000 ))                                              as GLAccount_DT
}
where
  (
        je.PostingDate                         >= $parameters.FromDate
    and je.PostingDate                         <= $parameters.ToDate
    and taxAmount.TaxBaseAmountInTransCrcy     <> 0
    and taxAmount.TransactionTypeDetermination =  'MWS'
    and je.IsReversed                          =  ''
    and je.IsReversed                          is initial
    and je.IsReversal                          =  ''
    and je.IsReversal                          is initial
    and je.ReversalReason                      <> '01'
    //    and oadi.TaxType   = 'V'
  )
