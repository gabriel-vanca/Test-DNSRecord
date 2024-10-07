class DNS_Server : System.Management.Automation.IValidateSetValuesGenerator
{

    [String] $Record
    [String] $Type

    hidden [Object] $DNS_Provider = $null
    hidden [System.Net.DnsEndPoint[]] $NameServerRecords = $null
    hidden [System.Net.IPAddress[]] $DNS_Provider_IPs = $null

    [string[]] GetValidValues()
    {
        return ([DNS_Server]::DNS_SERVERS.keys)
    }

    static $DNS_SERVERS = ([System.Collections.Hashtable]([ordered]@{
                Google            = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '8.8.8.8'
                        Secondary = '8.8.4.4'
                    }
                    CyberRisk = $False
                }
                Cloudflare        = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary           = '1.1.1.1'
                        Secondary         = '1.0.0.1'
                        SecurityPrimary   = '1.1.1.2'
                        SecuritySecondary = '1.0.0.2'
                        FamilyPrimary     = '1.1.1.3'
                        FamilySecondary   = '1.0.0.3'
                    }
                    CyberRisk = $False
                }
                Quad9             = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '9.9.9.9'
                        Secondary = '149.112.112.112'
                    }
                    CyberRisk = $False
                }
                AdGuard           = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '94.140.14.14'
                        Secondary = '94.140.15.15'
                    }
                    CyberRisk = $False
                }
                OpenDNSHome       = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '208.67.222.222'
                        Secondary = '208.67.220.220'
                    }
                    CyberRisk = $False
                }
                CleanBrowsing     = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '185.228.168.9'
                        Secondary = '185.228.169.9'
                    }
                    CyberRisk = $False
                }
                AlternateDNS      = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '76.76.19.19'
                        Secondary = '76.223.122.150'
                    }
                    CyberRisk = $False
                }
                DNSWATCH          = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '84.200.69.80'
                        Secondary = '84.200.70.40'
                    }
                    CyberRisk = $False
                }
                Comodo            = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '8.26.56.26'
                        Secondary = '8.20.247.20'
                    }
                    CyberRisk = $False
                }
                CenturyLinkLevel3 = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '205.171.3.66'
                        Secondary = '205.171.202.166'
                    }
                    CyberRisk = $False
                }
                SafeDNS           = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '195.46.39.39'
                        Secondary = '195.46.39.40'
                    }
                    CyberRisk = $False
                }
                OpenNIC           = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '172.98.193.42'
                        Secondary = '66.70.228.164'
                    }
                    CyberRisk = $False
                }
                Dyn               = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '216.146.35.35'
                        Secondary = '216.146.36.36'
                    }
                    CyberRisk = $False
                }
                FreeDNS           = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '45.33.97.5'
                        Secondary = '37.235.1.177'
                    }
                    CyberRisk = $False
                }
                Yandex            = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '77.88.8.8'
                        Secondary = '77.88.8.1'
                    }
                    CyberRisk = $True
                }
                UncensoredDNS     = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '91.239.100.100'
                        Secondary = '89.233.43.71'
                    }
                    CyberRisk = $False
                }
                Neustar           = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '64.6.64.6'
                        Secondary = '64.6.65.6'
                    }
                    CyberRisk = $False
                }
                FourthEstate      = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '45.77.165.194'
                        Secondary = '45.32.36.36'
                    }
                    CyberRisk = $False
                }
                Gcore             = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '2.56.220.2'
                        Secondary = '95.85.95.85'
                    }
                    CyberRisk = $False
                }
                DNSFilter         = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '103.247.36.36'
                        Secondary = '103.247.37.37'
                    }
                    CyberRisk = $False
                }
                CiscoUmbrella     = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '208.67.220.220'
                        Secondary = '208.67.222.222'
                    }
                    CyberRisk = $False
                }
                Verisign          = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary   = '64.6.64.6'
                        Secondary = '64.6.65.6'
                    }
                    CyberRisk = $False
                }
                HurricaneElectric = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary = '74.82.42.42'
                    }
                    CyberRisk = $False
                }
                puntCAT           = [ordered]@{
                    IPv4      = [ordered]@{
                        Primary = '109.69.8.51'
                    }
                    CyberRisk = $False
                }
            }))

    # GetValidValues() cannot be static and needs to instantiate the class with zero parameters
    DNS_Server()
    {
    }

    DNS_Server([String]$DNS_Provider_Id, [String]$Record, [String]$Type) 
    {

        Set-Variable $this.Record -Option Constant -Value $Record
        Set-Variable $this.Type -Option Constant -Value $Type
        Set-Variable $this.DNS_Provider -Option Constant -Value (GetDNSProvider ($DNS_Provider_Id))

        if ($DNS_Provider_Id -eq 'DNSZoneNameServers')
        {
            Set-Variable $this.NameServerRecords -Option Constant -Value (GetNameServerRecords ($Record)) 
            Set-Variable $this.DNS_Provider_IPs -Option Constant -Value $null
        }
        else
        {
            Set-Variable $this.DNS_Provider_IPs -Option Constant -Value (GetDNSProviderIPs ($this.DNS_Provider))
            Set-Variable $this.NameServerRecords -Option Constant -Value $null
        }
               
    }

    hidden [Object] GetDNSProvider([String] $DNS_Provider_Id) 
    {

        [Object] $_DNS_Provider = $null

        switch ($DNS_Provider_Id)
        {
            InternalDNSserver
            {
                $_DNS_Provider = $this.DNS_SERVERS.InternalDNSserver
                break
            }

            DNSZoneNameServers
            {
                $_DNS_Provider = $this.DNS_SERVERS.DNSZoneNameServers
                break
            }

            { [string]::IsNullOrWhiteSpace($_) }
            {
                $_DNS_Provider = $this.DNS_SERVERS.Google
                break
            }

            default
            {

                if (-not $this.DNS_SERVERS.ContainsKey($DNS_Provider_Id))
                {
                    throw "Invalid DNS Provider Id: $DNS_Provider_Id"
                }

                $_DNS_Provider = $this.DNS_SERVERS[$DNS_Provider_Id]
                break
            }
        }

        return $_DNS_Provider
    }


    hidden [System.Net.IPAddress[]] GetDNSProviderIPs([Object] $_DNS_Provider)
    {
        [System.Net.IPAddress[]] $_DNS_Provider_IPs = @()

        switch ($_DNS_Provider)
        {
            'InternalDNSserver'
            {
                $internalDNS = (Get-ADDomainController -Filter { Name -like '*' }).HostName
                $_DNS_Provider_IPs = $internalDNS
                break
            }

            'DNSZoneNameServers'
            {
                Write-Verbose -Message 'Nothing to do here. This should never be reached.'
                break
            }

            default
            {
                $_DNS_Provider_IPs = $this.DNS_Provider.IPv4.Values
                break
            }
        }

        return $_DNS_Provider_IPs
    }

    hidden [System.Net.DnsEndPoint[]] GetNameServerRecords([String] $_Record)
    {
        [System.Net.DnsEndPoint[]] $_NameServerRecords = @()

        if ([string]::IsNullOrWhiteSpace($_Record))
        {
            throw 'Record cannot be null or empty for DNSZoneNameServers processing'
        }
        
        $nameHostServers = (Resolve-DnsName -Name $_Record -Type NS | Where-Object NameHost).NameHost
        
        foreach ($PSItem in $nameHostServers)
        {
            $_NameServerRecords += New-Object System.Net.DnsEndPoint -ArgumentList $PSItem, 53
        }

        return $_NameServerRecords
    }


    [Object[]] Resolve()
    {

        [Object[]]$result = @()

        switch ($this.DNS_Provider_Id)
        {

            InternalDNSserver
            {
                $internalDNS = (Get-ADDomainController -Filter { Name -like '*' }).HostName

                foreach ($PSItem in $internalDNS)
                {
                    $result += Resolve-DnsName -Name $this.Record -Type $this.Type -Server $PSItem -DnsOnly -ErrorAction Stop
                    Write-Verbose -Message "Checking $PSItem..."
                }
                break
            }

            DNSZoneNameServers
            {
                $query = Resolve-DnsName -Name $this.Record -Type NS | Where-Object NameHost
                $GlueServers = $query.NameHost

                foreach ($PSItem in $GlueServers)
                {
                    $result += Resolve-DnsName -Name $this.Record -Type $this.Type -Server $PSItem -DnsOnly -ErrorAction Stop
                    Write-Verbose -Message "Checking $PSItem..."
                }
                break
            }

            default
            {
                $result = Resolve-DnsName -Name $this.Record -Type $this.Type -Server $this.DNS_Provider_Ip -DnsOnly -ErrorAction Stop
                Write-Verbose -Message "Checking $($this.DNS_Provider_Id)..."
                break
            }
        }

        return $result
    }
}

