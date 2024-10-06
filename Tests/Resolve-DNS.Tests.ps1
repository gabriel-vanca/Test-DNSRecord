# using module '../Resolve-DNS/Resolve-DNS.psd1'

Import-Module -Name '../Resolve-DNS/Resolve-DNS.psd1' 

# Resolve-DNS google.ro

Resolve-DNS -recordName bbc.co.uk -Type A -DNSProvider Google

# Resolve-DNS -recordName bbc.co.uk -Type CNAME -DNSProvider GoogleSecondary

# Resolve-DNS -recordName bbc.co.uk -Type CNAME -DNSProvider Quad9Primary
