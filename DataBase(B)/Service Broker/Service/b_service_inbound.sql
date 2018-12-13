CREATE SERVICE [b_service_inbound]
    AUTHORIZATION [b_service_owner]
    ON QUEUE [dbo].[Inbound]
    ([test_contract]);


GO
GRANT SEND
    ON SERVICE::[b_service_inbound] TO [a_service_owner];

