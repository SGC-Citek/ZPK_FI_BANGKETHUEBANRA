@EndUserText.label: 'Search help for AccountGroup'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_ACCOUNTGROUP_SH as select from I_CustomerAccountGroupText
{
    key CustomerAccountGroup,
    key Language,
    AccountGroupName
}where Language = 'E' and CustomerAccountGroup like 'ZB%'
