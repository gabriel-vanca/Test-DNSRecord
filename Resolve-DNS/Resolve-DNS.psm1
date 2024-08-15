function Resolve-DNS {

    <#

    .SYNOPSIS
        A simple wrapper for the function Resolve-DNSName to perform DNS queries against specific DNS Servers. The parameters enable you to select from a list of Pubic DNS servers to test DNS resolution for a domain. The DNSProvider switch parameter can also be used to select your internal DNS servers and to test against the domains own Name Servers.

    .DESCRIPTION
        A simple wrapper for the function Resolve-DNSName to perform DNS queries against specific DNS Servers and a dynamic list of internal DNS Servers. This in no way replaces Resolve-DNSName but provides some simple enhanced queries that do not require you to remember the names or IP Addresses of the Name Servers that you wish to query. This tool does not include all of the functionality of Resolve-DNSName but will speed up everyday DNS queries and diagnostics.

        The parameters enable you to select from a list of Pubic DNS servers to test DNS resolution for a domain. The DNSProvider switch parameter can also be used to select you internal DNS servers and to test against the domains own Name Servers.

        The DNSProvider Switch utilises external servers and queries to populate the switch with the relevant internal/external/zone servers to perform the query. Further information can be found in the parameter section.

        The internalDNS_SERVERS option for the DNSProviders switch performs an AD query to determine the hostname of the Domain Controllers, performs a DNS query against each Domain Controller and displays the results.

        The list of popular Public DNS Servers was taken from the article - https://www.lifewire.com/free-and-public-dns-servers-2626062 which also provides some useful information regarding DNS and why you might select different public dns servers for your name resolution.

    .PARAMETER recordName
        This is a string and which should container either a fully qualified domain name (FQDN) or an IP address (IPv4 or IPv6)

        e.g. example.com or 151.101.0.81

    .PARAMETER Type
        You can specify any record type using tab complete. If this parameter is not defined, it defaults to performing an A record DNS query.

        The following are contained in a ValidateSet so you can cycle through the record types or manually enter the record type you require.

        You can tab complete through a complete list of dns record types or you can enter the record type manually.

        Commonly used record types                  Less commonly used record types:
        A (Host address)                            AFSDB (AFS Data Base location)
        AAAA (IPv6 host address)                    ATMA (Asynchronous Transfer Mode address)
        ALIAS (Auto resolved alias)                 CAA (Certification Authority Authorization)
        CNAME (Canonical name for an alias)         CERT (Certificate / CRL)
        MX (Mail eXchange)                          DHCID (DHCP Information)
        NS (Name Server)                            DNAME (Non-Terminal DNS Name Redirection)
        PTR (Pointer)                               HINFO (Host information)
        SOA (Start Of Authority)                    ISDN (ISDN address)
        SRV (location of service)                   LOC (Location information)
        TXT (Descriptive text)                      MB, MG, MINFO, MR (mailbox records)
                                                    NAPTR (Naming Authority Pointer)
        Records types used for DNSSEC               NSAP (NSAP address)
        DNSKEY (DNSSEC public key)                  RP (Responsible person)
        DS (Delegation Signer)                      RT (Route through)
        NSEC (Next Secure)                          TLSA (Transport Layer Security Authentication)
        NSEC3 (Next Secure v. 3)                    X25 (X.25 PSDN address)
        NSEC3PARAM (NSEC3 Parameters)
        RRSIG (RRset Signature)

    .PARAMETER DNSProvider
        The DNSProvider Switch utilises the external servers and settings detailed below.

        The parameter is not mandatory and if not selected will default to using Google's Primary and Secondary public DNS servers.

        todo
        The switch options are defined as follows:-
        InternalDNSserver          = Performs an AD query to determine the hostname of the Domain Controllers
        DNSZoneNameServers         = Performs a query against the recordname to determine the NameServers for the zone

    .EXAMPLE
        Resolve-DNS

        cmdlet Resolve-DNS at command pipeline position 1
        Supply values for the following parameters:
        (Type !? for Help.)
        recordName[0]: !?
        Please enter DNS record name to be tested. Expectd format is either a fully qualified domain name (FQDN) or an IP address (IPv4 or IPv6) e.g. example.com or
        151.101.0.81)
        recordName[0]: example.com
        recordName[1]:

        Name                                           Type   TTL   Section    IPAddress
        ----                                           ----   ---   -------    ---------
        example.com                                    A      19451 Answer     93.184.216.34
        example.com                                    A      19954 Answer     93.184.216.34

        This example shows Resolve-DNS without any options. As recordname is a mandatory field, you are prompted to enter a FQDN or an IP.

    .EXAMPLE
        Resolve-DNS -recordName example.com -Type A -DNSProvider GooglePrimary

        Name                                           Type   TTL   Section    IPAddress
        ----                                           ----   ---   -------    ---------
        example.com                                    A      20182 Answer     93.184.216.34

        This example shows an 'A' record query against Google's Primary Public DNS server.

    .EXAMPLE
        Resolve-DNS -recordName bbc.co.uk -Type CNAME -DNSProvider GooglePrimary -Verbose
        VERBOSE: bbc.co.uk
        VERBOSE: Checking Google Primary...

        Name                        Type TTL   Section    PrimaryServer               NameAdministrator           SerialNumber
        ----                        ---- ---   -------    -------------               -----------------           ------------
        bbc.co.uk                   SOA  899   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800

        This example displays the output with the verbose option enabled. The function performs the search and details which DNS Provider is being queried.

    .EXAMPLE
        Resolve-DNS -recordName bbc.co.uk -Type CNAME -DNSProvider InternalDNSserver -Verbose

        VERBOSE: bbc.co.uk
        VERBOSE: Checking DANTOOINE.domain.leigh-services.com...
        Name                        Type TTL   Section    PrimaryServer               NameAdministrator           SerialNumber
        ----                        ---- ---   -------    -------------               -----------------           ------------
        bbc.co.uk                   SOA  899   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800

        This example displays the output with the verbose option enabled. The function performs the search and details which DNS Provider is being queried. The InternalDNSserver DNS Provider, performs an AD query and uses the internal AD Servers for DNS resolution.

    .INPUTS
    #todo
    You can pipe objects to these perameters.

    - recordName [string - The expected format is a fully qualified domain name or an IP address]

    - Type ['A', 'AAAA', 'ALIAS', 'CNAME', 'MX', 'NS', 'PTR', 'SOA', 'SRV', 'TXT', 'DNSKEY', 'DS', 'NSEC', 'NSEC3', 'NSEC3PARAM', 'RRSIG', 'AFSDB', 'ATMA', 'CAA', 'CERT', 'DHCID', 'DNAME', 'HINFO', 'ISDN', 'LOC', 'MB', 'MG', 'MINFO', 'MR', 'NAPTR', 'NSAP', 'RP', 'RT', 'TLSA', 'X25']

    - DNSProvider ['GooglePrimary', 'GoogleSecondary', 'Quad9Primary', 'Quad9Secondary', 'OpenDNSHomePrimary', 'OpenDNSHomeSecondary', 'CloudflarePrimary', 'CloudflareSecondary', 'CleanBrowsingPrimary', 'CleanBrowsingSecondary', 'AlternateDNSPrimary', 'AlternateDNSSecondary', 'AdGuardDNSPrimary', 'AdGuardDNSSecondary', 'InternalDNSserver', 'DNSZoneNameServers', 'AllPublic']

    .OUTPUTS
    #todo
        System.String. The output returned from Resolve-DNS is a string

    .NOTES
        Author:     Gabriel Vanca
        GitHub:     https://github.com/gabriel-vanca
        GitHubGist: https://gists.github.com/gabriel-vanca
        
        Work partially based on an earlier PowerShell module
            written by Luke Leigh: https://github.com/BanterBoy/Test-DNSRecord

    .LINK
        Resolve-DNSName - https://docs.microsoft.com/en-us/powershell/module/dnsclient/resolve-dnsname
        DnsClient       - https://learn.microsoft.com/en-us/powershell/module/dnsclient
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default')]

    [OutputType([Microsoft.DnsClient.Commands.DnsRecord[]])]

    param (
        [Parameter(Mandatory = $True,
            HelpMessage = 'Please enter DNS record name to be resolved. Expected format is either a fully qualified domain name (FQDN) or an IP address (IPv4 or IPv6) e.g. example.com or 151.101.0.81',
            Position = 0,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $True)]
        [Alias('name')]
        [string[]] $recordName,

        [Parameter(Mandatory = $False,
            HelpMessage = "Select DNS record type. Defaults to 'A' record lookups. You can tab complete (Shift+TAB) through the list. A complete list of DNS Record Types is available.",
            Position = 1,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.DnsClient.Commands.RecordType] $Type = 'A',

        [Parameter(Mandatory = $False,
            HelpMessage = "Force 'All' records option if DNS provider does not natively support it. If type is not 'All', this switch has no effect.",
            Position = 2,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $True)]
        [Alias('F', 'AllDnsTypes')]
        [Switch] $Force,

        [Parameter(Mandatory = $False,
            HelpMessage = 'Select the DNS server to perform the DNS query against. This is a tab complete list. Please check the help for more details. Get-Help Resolve-DNS -Parameter DNSProvider',
            ParameterSetName = 'ExternalDNSProvider',
            Position = 3,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet([DNS_Server])]
        [string] $DnsProvider = 'Cloudflare',

        [Parameter(Mandatory = $False,
            HelpMessage = "Enter name of the method to contact the previously selected DNS provider that you want to use. For example 'IPv4' for unencrypted HTTP method.",
            ParameterSetName = 'ExternalDNSProvider',
            Position = 4,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('IPv4')]
        [ValidateScriptAttribute({
                return ([DNS_Server]::DNS_SERVERS[$DnsProvider].Keys.Contains($_))
            })]
        [Alias('Protocol')]
        [string] $DnsRequestMethod = 'IPv4',

        [Parameter(Mandatory = $False,
            HelpMessage = "Enter name of the specific DNS server partaining to the previously selected DNS provider that you want to use. For example 'Primary', 'Secondary', 'All'",
            ParameterSetName = 'ExternalDNSProvider',
            Position = 5,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [ValidateScriptAttribute({
                return (('All' -eq $_) -or
                        ([DNS_Server]::DNS_SERVERS[$DnsProvider][$DnsRequestMethod].Keys.Contains($_)))
            })]
        [ArgumentCompletions('All', 'Primary', 'Secondary')]
        [string] $SubProvider = 'Primary',

        [Parameter(Mandatory = $False,
            HelpMessage = 'Attempt resolution via all external DNS providers.',
            ParameterSetName = 'AllExternalDNSProvider',
            Position = 3,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $True)]
        [Alias('AllExternal')]
        [Switch] $AllExternalProviders,

        [Parameter(Mandatory = $False,
            HelpMessage = 'Attempt all external DNS providers, including DNS servers deemed a possible cyber risk.',
            ParameterSetName = 'AllExternalDNSProvider',
            Position = 4,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $True)]
        [Switch] $IgnoreCyberRisk,

        [Parameter(Mandatory = $False,
            HelpMessage = 'Switch to Internal DNS Server. Automatic detection will be attempted.',
            ParameterSetName = 'InternalDNSProvider',
            Position = 3,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $True)]
        [Switch] $LocalDNS,

        [Parameter(Mandatory = $False,
            HelpMessage = 'Skips the hosts file when resolving this query.',
            Position = 6,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $True)]
        [Switch] $NoHostsFile,

        [Parameter(Mandatory = $False,
            HelpMessage = 'If multiple DNS servers return the same result, do not remove duplicates or centralise in one line.',
            Position = 7,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $True)]
        [Switch] $AllowDuplicates
    )

    class DNS_Server : System.Management.Automation.IValidateSetValuesGenerator {

        [String]$Id
        [String]$Record
        [String]$Type

        hidden [String]$Ip 

        [string[]] GetValidValues() {
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


        DNS_Server([String]$Id, [String]$Record, [String]$Type) {
            $this.Id = $Id
            $this.Record = $Record
            $this.Type = $Type

            $this.Ip = $this.DNS_SERVERS[$Id]
        }

        [Object[]] Resolve() {
            [Object[]]$result = @()


            if ([string]::IsNullOrWhiteSpace($this.Id)) {
                Write-Verbose -Message 'Checking Google Primary...'
                $result += Resolve-DnsName -Name $this.Record -Type $this.Type -Server $this.DNS_SERVERS.GooglePrimary -ErrorAction Stop

                Write-Verbose -Message 'Checking Google Secondary...'
                $result += Resolve-DnsName -Name $this.Record -Type $this.Type -Server $this.DNS_SERVERS.GoogleSecondary -ErrorAction Stop

                return $result
            }

            switch ($this.Id) {
                InternalDNSserver {
                    $internalDNS = (Get-ADDomainController -Filter { Name -like '*' }).HostName

                    foreach ($PSItem in $internalDNS) {
                        $result += Resolve-DnsName -Name $this.Record -Type $this.Type -Server $PSItem -DnsOnly -ErrorAction Stop
                        Write-Verbose -Message "Checking $PSItem..."
                    }
                    return $result
                }
                DNSZoneNameServers {
                    $query = Resolve-DnsName -Name $this.Record -Type NS | Where-Object NameHost
                    $GlueServers = $query.NameHost

                    foreach ($PSItem in $GlueServers) {
                        $result += Resolve-DnsName -Name $this.Record -Type $this.Type -Server $PSItem -DnsOnly -ErrorAction Stop
                        Write-Verbose -Message "Checking $PSItem..."
                    }
                    return $result
                }
            }

            $result = Resolve-DnsName -Name $this.Record -Type $this.Type -Server $this.Ip -DnsOnly -ErrorAction Stop
            Write-Verbose -Message "Checking $($this.Id)..."
            return $result
        }
    }

    foreach ($record in $recordName) {
        try {
            $server = [DNS_Server]::new($DNSProvider, $record, $Type)
            Write-Output $server.Resolve()
        } catch {
            Write-Error 'An error occurred:'
            Write-Error $_
        }
    }
}

Import-Module -Name DnsClient
