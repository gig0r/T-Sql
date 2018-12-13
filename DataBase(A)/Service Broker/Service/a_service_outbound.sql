CREATE SERVICE [a_service_outbound]
    AUTHORIZATION [a_service_owner]
    ON QUEUE [dbo].[Outbound]
    ([test_contract]);


GO
GRANT SEND
    ON SERVICE::[a_service_outbound] TO [b_service_owner];

