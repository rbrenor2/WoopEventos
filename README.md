# WoopEventos
### Summary
WoopEventos is an RSVP management app developed for a bank institution in southern Brazil. The app allows users to explore charity events, organic food fairs, and other public events sponsored by the bank. Users can favorite events they are interested in and check in if they plan to attend.
The app consumes a REST API provided by the client (this open version uses a mock API). It follows the MVVM pattern, with views built in view code using Swift.

### API
#### List events
GET http://5f5a8f24d44d640016169133.mockapi.io/api/events
#### Event details
GET http://5f5a8f24d44d640016169133.mockapi.io/api/events/1
#### Check in
POST http://5f5a8f24d44d640016169133.mockapi.io/api/checkin
- body example:
```{ "eventId": "1", "name": "Otávio", "email": "otavio_souza@..." }```

