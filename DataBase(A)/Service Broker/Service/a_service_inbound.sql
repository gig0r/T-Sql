CREATE SERVICE [a_service_inbound]
    AUTHORIZATION [a_service_owner]
    ON QUEUE [dbo].[Inbound]
    ([test_contract]);

