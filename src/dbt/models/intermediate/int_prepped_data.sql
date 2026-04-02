SELECT A.ID 
    , FIRST_NAME
    , LAST_NAME
    , birthdate
    , BOOKING_REFERENCE
    , HOTEL
    , BOOKING_DATE
    , COST
FROM {{ref('int_customer')}}  A
JOIN {{ref('int_combined_bookings')}} B
on A.ID = B.ID