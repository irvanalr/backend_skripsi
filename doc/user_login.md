# user login 

URL = http://localhost:3000/login  
Method = POST  
Headers =  
mobile-app : mobile-application  
Content-Type : application/json  
Accept : application/json  
Authorization : token_api    
# Request    
```json 
{
    "username" : "username",
    "password" : "password"
}
```

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

### Akun Anda Tidak Aktif, Silahkan Hubungi Administrator !!!

```json
{
  "timestamp": "2024-07-16T10:00:00Z",
  "status": 0,
  "message": "Akun Anda Tidak Aktif, Silahkan Hubungi Administrator !!!"
}
```

### ANDA SUDAH LOGIN DI PERANGKAT LAIN, LAPORKAN HAL MENCURIGAKAN JIKA BUKAN ANDA !!!

```json
{
  "timestamp": "2024-07-16T10:00:00Z",
  "status": 0,
  "message": "ANDA SUDAH LOGIN DI PERANGKAT LAIN, LAPORKAN HAL MENCURIGAKAN JIKA BUKAN ANDA !!!"
}

```

### Akun Anda Telah Di Non-Aktifkan Karena Terlalu Banyak Percobaan Login Gagal. Silahkan Hubungi Administrator !!!

```json
{
  "timestamp": "2024-07-16T10:00:00Z",
  "status": 0,
  "message": "Akun Anda Telah Di Non-Aktifkan Karena Terlalu Banyak Percobaan Login Gagal. Silahkan Hubungi Administrator !!!"
}

```

### Username Atau Password salah silahkan coba lagi !!!

```json
{
  "timestamp": "2024-07-16T10:00:00Z",
  "status": 0,
  "message": "Username Atau Password salah silahkan coba lagi !!!"
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
    "timestamp": "2024-07-16T06:44:47.855Z",
    "status": 1,
    "message": "SUCCESS",
    "name": "name",
    "token": "tokens"
}
```