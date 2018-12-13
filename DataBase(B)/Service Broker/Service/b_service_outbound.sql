CREATE SERVICE [b_service_outbound]
    AUTHORIZATION [b_service_owner]
    ON QUEUE [dbo].[Outbound]
    ([test_contract]);

