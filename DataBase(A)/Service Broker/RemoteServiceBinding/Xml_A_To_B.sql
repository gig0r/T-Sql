CREATE REMOTE SERVICE BINDING [Xml_A_To_B]
    AUTHORIZATION [dbo]
    TO SERVICE N'B_Service_Xml_In'
    WITH USER = [b_service_owner], ANONYMOUS = OFF;

