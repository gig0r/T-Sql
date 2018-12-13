CREATE ENDPOINT [b_endpoint]
    AUTHORIZATION [myuser] 
    STATE = STARTED
    AS TCP (
            LISTENER_PORT = 4022,
            LISTENER_IP = ALL
           )
    FOR SERVICE_BROKER (
            AUTHENTICATION = CERTIFICATE [b_cert],
            ENCRYPTION = REQUIRED ALGORITHM AES
                       );

