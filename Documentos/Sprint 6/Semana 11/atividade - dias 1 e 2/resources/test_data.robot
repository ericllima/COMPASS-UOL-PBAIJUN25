*** Variables ***
# ------- Payloads estáveis para Bookings -------
&{BOOKING_DATES}              checkin=2025-09-01    checkout=2025-09-05
&{BOOKING_DATA}               firstname=Rillary    lastname=Uchoa
...                           totalprice=350       depositpaid=${True}
...                           bookingdates=${BOOKING_DATES}    additionalneeds=Breakfast

&{UPDATED_BOOKING_DATES}      checkin=2025-09-02    checkout=2025-09-06
&{UPDATED_BOOKING}            firstname=Rillary    lastname=Uchoa
...                           totalprice=420       depositpaid=${False}
...                           bookingdates=${UPDATED_BOOKING_DATES}    additionalneeds=Late checkout
