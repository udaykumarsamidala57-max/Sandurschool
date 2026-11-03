# Sandurschool

## Database environment variables

The application reads database settings from environment variables. Copy the names and URLs from `.env.example` into your deployment provider's variable settings. Set the passwords there; do not commit them or put them in `.env.example`.

For a local PowerShell session, set the values before starting the application:

```powershell
$env:SRS_DB_URL = 'jdbc:mysql://altaria.proxy.rlwy.net:53217/website?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&tcpKeepAlive=true'
$env:SRS_DB_USER = 'root'
$env:SRS_DB_PASSWORD = 'your-database-password'

# Only needed by code that calls DBUtil2:
$env:HR_DB_URL = 'jdbc:mysql://shuttle.proxy.rlwy.net:26985/HR?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&tcpKeepAlive=true'
$env:HR_DB_USER = 'root'
$env:HR_DB_PASSWORD = 'your-HR-database-password'
```

These PowerShell values apply only to that session. Add the corresponding variables to the hosting service for deployed runs.
