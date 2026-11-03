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


## Website URLs (one project, many sites)

| URL (Eclipse) | Loads | Database variables |
|---|---|---|
| `/PInventory/srs/` | Sandur Residential School site | `SRS_DB_URL`, `SRS_DB_USER`, `SRS_DB_PASSWORD` |
| `/PInventory/sanpoly/` | Sanpoly site | `SANPOLY_DB_URL`, `SANPOLY_DB_USER`, `SANPOLY_DB_PASSWORD` |
| `/PInventory/admin/` | Admin panel (page builder, news, events) | branch of the logged-in user |
| `/PInventory/` | redirects to `/srs/` | |

Old links such as `/PInventory/homepage?slug=...` still open the SRS site.
Sites (name, address, logo, database key) are listed in `src/main/webapp/WEB-INF/sites.properties`.
Routing is done by `com.site.SiteFilter`; admin servlets are in `com.admin`, mapped under `/admin/`.
