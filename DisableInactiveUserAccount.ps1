Import-Module ActiveDirectory

# Set the number of days since last logon

$DaysInactive = 5
$InactiveDate = (Get-Date).Adddays(-($DaysInactive))

# Specify the OU Path 

$OUpath = 'ou=USER_IT,dc=TESTREE,dc=COM'
  
#-------------------------------
# FIND INACTIVE USERS
#-------------------------------


# Get AD Users that haven't logged on in xx days
$Users = Get-ADUser -SearchBase $OUpath -Filter { LastLogonDate -lt $InactiveDate -and Enabled -eq $true } -Properties LastLogonDate | Select-Object @{ Name="Username"; Expression={$_.SamAccountName} }, Name, LastLogonDate, DistinguishedName


#----------------------------------------------------
# INACTIVE USER MANAGEMENT FOR DISABLING USER ACCOUNT
#----------------------------------------------------


# Disable Inactive Users
ForEach ($Item in $Users){
  $DistName = $Item.DistinguishedName
  Disable-ADAccount -Identity $DistName
  Get-ADUser -Filter { DistinguishedName -eq $DistName } | Select-Object @{ Name="Username"; Expression={$_.SamAccountName} }, Name, Enabled
}

