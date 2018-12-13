CREATE SERVICE [A_Service_Xml_Out]
    AUTHORIZATION [a_service_owner]
    ON QUEUE [dbo].[Xml_Out_Queue]
    ([xml_contract]);


GO
GRANT SEND
    ON SERVICE::[A_Service_Xml_Out] TO [b_service_owner];

