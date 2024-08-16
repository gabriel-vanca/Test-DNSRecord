using module './Classes/DNS_SERVER.class.psm1'

Import-Module -Name DnsClient


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

Resolve-DNS google.ro

