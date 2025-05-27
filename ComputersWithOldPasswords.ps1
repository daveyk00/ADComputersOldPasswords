$outputFilePath = "ComputersWithOldPasswords.txt"
$daysThreshold = 30
$currentDate = Get-Date

# Calculate the date threshold
$dateThreshold = $currentDate.AddDays(-$daysThreshold)

# Import the Active Directory module (ensure RSAT tools are installed)
Import-Module ActiveDirectory

# Query Active Directory for computer accounts
$computers = Get-ADComputer -Filter * -Property Name, PasswordLastSet

# Initialize an array to hold computers with old passwords
$oldPasswordComputers = @()

# Iterate through each computer
foreach ($computer in $computers) {
    # Check if the PasswordLastSet property is older than the threshold
    if ($computer.PasswordLastSet -lt $dateThreshold) {
        # Add the computer name to the array
        $oldPasswordComputers += $computer.Name
    }
}

# Check if any computers were found
if ($oldPasswordComputers.Count -eq 0) {
    # Output a message indicating no computers found
    Write-Output "No computers with passwords older than $daysThreshold days found."
} else {
    # Write the list of computers to the output file
    $oldPasswordComputers | Out-File -FilePath $outputFilePath
}
