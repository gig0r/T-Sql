CREATE ENDPOINT [a_endpoint]
    AUTHORIZATION [PCV1\O_O] 
    STATE = STARTED
    AS TCP (
            LISTENER_PORT = 4022,
            LISTENER_IP = ALL
           )
    FOR SERVICE_BROKER (
            AUTHENTICATION = CERTIFICATE [a_cert],
            ENCRYPTION = REQUIRED ALGORITHM AES
                       );

