CREATE PROCEDURE [dbo].[service_broker_get]
AS
SELECT
     'sys.conversation_endpoints' AS [desc],
     [conversation_handle],
     [is_initiator],
     [state_desc],
     [far_service],
     [far_broker_instance],
     [outbound_session_key_identifier] AS [ok],
     [inbound_session_key_identifier] AS [ik]
FROM sys.conversation_endpoints;

SELECT
      'sys.transmission_queue' AS [desc],
      [conversation_handle],
      [to_service_name],
      [to_broker_instance],
      [from_service_name],
      [message_type_name],
      [transmission_status],
      CONVERT(VARCHAR(MAX), [message_body]) AS [msg],
      CONVERT(NVARCHAR(MAX), [message_body]) AS [msg2]
FROM sys.transmission_queue;

SELECT
      'sys.dm_broker_connections' AS [desc],
      [connection_id],
      [state_desc],
      [connect_time],
      [principal_name],
      [remote_user_name],
      [last_activity_time],
      [is_accept],
      [login_state_desc],
      [peer_certificate_id],
      [encryption_algorithm_desc],
      [total_sends],
      [total_receives]
FROM sys.dm_broker_connections;

SELECT
      'service_to_certs_relations' AS [desc],
      USER_NAME(s.[principal_id]) AS [service_owner],
      s.[name] AS [service_name],
      c.[name] AS [cert_name],
      USER_NAME(c.[principal_id]) AS [cert_owner],
      c.[certificate_id] AS [cert_id],
      c.[pvt_key_encryption_type_desc],
      c.[is_active_for_begin_dialog],
      IIF(c.[issuer_name] <> c.[subject], CONCAT('issuer:', c.[issuer_name], CHAR(32), 'subject:', c.[subject]), c.[subject]) AS [comment],
      c.[start_date],
      c.[expiry_date],
      c.[pvt_key_last_backup_date]
FROM sys.services s
    JOIN sys.certificates c ON c.[principal_id] = s.[principal_id];

SELECT
      'remote_service_bindings' AS [desc],
      USER_NAME([remote_principal_id]) AS [remote_login],
      *
FROM sys.remote_service_bindings;