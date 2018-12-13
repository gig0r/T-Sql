CREATE REMOTE SERVICE BINDING [To_B]
    AUTHORIZATION [dbo]
    TO SERVICE N'b_service_inbound'
    WITH USER = [b_service_owner], ANONYMOUS = OFF;

