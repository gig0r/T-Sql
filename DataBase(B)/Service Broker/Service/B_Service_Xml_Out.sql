CREATE SERVICE [B_Service_Xml_Out]
    AUTHORIZATION [b_service_owner]
    ON QUEUE [dbo].[Xml_Out_Queue]
    ([xml_contract]);


GO
GRANT SEND
    ON SERVICE::[B_Service_Xml_Out] TO [a_service_owner];

