## api token 
URL = http://localhost:3000/login  
Method = GET  
Headers =  
mobile-app : mobile-application  
Content-Type : application/json  
Accept : application/json  
Authorization : token_api  
mobile-logout : token_login  
# Request = -  

# Response

## STATUS CODE (403/FORBIDDEN)

### Token tidak ditemukan dalam header Authorization
```json
{
  "timestamp": "2024-07-16T10:00:00Z",
  "status": 0,
  "message": "Token tidak ditemukan dalam header Authorization"
}
```

## STATUS CODE (401/unauthorized)

### Token tidak valid atau kadaluarsa
```json
{
  "timestamp": "2024-07-16T10:00:00Z",
  "status": 0,
  "message": "Token tidak valid atau kadaluarsa"
}
```

## STATUS CODE (500/Internal Server Error)

### SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!
```json
{
  "timestamp": "2024-07-16T10:00:00Z",
  "status": 0,
  "message": "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!"
}
```

## STATUS CODE (404/Not Found)

### TOKEN TIDAK DI TEMUKAN 
```json
{
  "timestamp": "2024-07-16T10:00:00Z",
  "status": 0,
  "message": "Token tidak ditemukan"
}

```

### DATA TIDAK DITEMUKAN !!!
```json
{
  "timestamp": "2024-07-16T10:00:00Z",
  "status": 0,
  "message": "Data tidak ditemukan !!!"
}

```

## STATUS CODE (200/OK)
```json
{
    "timestamp": "2024-07-16T06:45:26.851Z",
    "status": 1,
    "message": "Logout berhasil"
}
```