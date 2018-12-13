CREATE SERVICE [B_Service_Xml_In]
    AUTHORIZATION [b_service_owner]
    ON QUEUE [dbo].[Xml_In_Queue]
    ([xml_contract]);


GO
GRANT SEND
    ON SERVICE::[B_Service_Xml_In] TO [a_service_owner];

