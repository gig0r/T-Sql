CREATE SERVICE [A_Service_Xml_In]
    AUTHORIZATION [a_service_owner]
    ON QUEUE [dbo].[Xml_In_Queue]
    ([xml_contract]);


GO
GRANT SEND
    ON SERVICE::[A_Service_Xml_In] TO [b_service_owner];

