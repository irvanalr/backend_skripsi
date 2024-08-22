## api token 
URL = http://localhost:3000/login  
Method = GET  
Headers =  
mobile-app : mobile-application  
Content-Type : application/json  
Accept : application/json  
# Request = -  

# Response :  

## STATUS CODE (500/Internal Server Error)

### SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!
```json
{
    {
    "timestamp": "2024-07-14T09:35:54.166Z",
    "status": 0,
    "message": "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
    }
}
```

## STATUS CODE (404/Not Found)

### TOKEN TIDAK DI TEMUKAN 
```json
{
    {
    "timestamp": "2024-07-14T09:35:54.166Z",
    "status": 0,
    "message": "Token tidak ditemukan",
    }
}
```

### Response (SUCCESS/200) :
```json
{
    {
    "timestamp": "2024-07-14T09:35:54.166Z",
    "status": 1,
    "message": "SUCCESS",
    "token": "token"
    }
}
```