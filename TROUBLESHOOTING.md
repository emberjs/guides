# Troubleshooting

## Common problems

### 1. Bundle command fails to install on OS X El Capitan
`bundle` command fails to install successfully on OS X 10.11 (El Capitan). gem `eventmachine` fails to install.

El Capitan no longer includes Open SSL headers by default. OpenSSL must be install manually (via homebrew or similar).

Solution:
```
brew install openssl
```  
OR
```
brew link openssl --force

```
