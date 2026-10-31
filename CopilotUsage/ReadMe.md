# Copilot Usage

Microsoft 365 Copilot usage data provides administrators with insights into license utilization and user activity across Copilot services. This information can be used to monitor adoption, identify active and inactive licenses, and support license optimization.

## Get Copilot Usage with Graph Reports

Microsoft Graph Reports provides endpoints for retrieving Microsoft 365 Copilot usage data at the user level. These APIs allow administrators to programmatically collect usage information for reporting and analysis. The corresponding endpoints are available through Microsoft Graph.

- [copilotReportRoot: getMicrosoft365CopilotUserCountSummary](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/reports/copilotreportroot-getmicrosoft365copilotusercountsummary?pivots=graph-v1&WT.mc_id=AZ-MVP-4030574)
- [copilotReportRoot: getMicrosoft365CopilotUserCountTrend](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/reports/copilotreportroot-getmicrosoft365copilotusercounttrend?pivots=graph-v1&WT.mc_id=AZ-MVP-4030574)
- [copilotReportRoot: getMicrosoft365CopilotUsageUserDetail](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/reports/copilotreportroot-getmicrosoft365copilotusageuserdetailbydate?WT.mc_id=AZ-MVP-4030574)
- [copilotReportRoot: getMicrosoft365CopilotUsageUserDetailByDate (preview)](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/reports/copilotreportroot-getmicrosoft365copilotusageuserdetailbydate?WT.mc_id=AZ-MVP-4030574)

Note: Check out the **Agent 365 API** at [Agent 365 Package Management API overview](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/overview?WT.mc_id=AZ-MVP-4030574).

### Create an App

Create an app registration in Microsoft Entra ID and grant the required Microsoft Graph application permissions, see [Register an application with the Microsoft identity platform](https://learn.microsoft.com/en-us/graph/auth-register-app-v2?WT.mc_id=AZ-MVP-4030574).

Use the application's credentials to authenticate against Microsoft Graph and retrieve Copilot usage data, as demonstrated in the following example.

~~~json
{
  "type": "Http",
  "inputs": {
    "uri": "https://graph.microsoft.com/v1.0/copilot/reports/getMicrosoft365CopilotUsageUserDetail(period='D7')",
    "method": "GET",
    "headers": {
      "Content-Type": "application/json"
    },
    "authentication": {
      "audience": "https://graph.microsoft.com/",
      "authority": "https://login.microsoft.com",
      "clientId": "[your-appid]",
      "secret": "[your-secret]",
      "tenant": "[your-tenantid]",
      "type": "ActiveDirectoryOAuth"
    }
  }
}
~~~

The following request requires the *Reports.Read.All* permission and returns usage data of uisers for the last 7 days:

> GET https://graph.microsoft.com/v1.0/copilot/reports/getMicrosoft365CopilotUsageUserDetail(period='D7')

The supported values for the period are *D7, D30, D90, D180*, and *ALL* (where *ALL* equals *D180*). The response looks similar as here:

~~~json
{
    "value": [
        {
            "reportRefreshDate": "2026-10-22",
            "userPrincipalName": "AdeleV@mytenant.onmicrosoft.com",
            "displayName": "Adele Vance",
            "lastActivityDate": "2026-10-21",
            "copilotChatLastActivityDate": "",
            "microsoftTeamsCopilotLastActivityDate": "",
            "wordCopilotLastActivityDate": "",
            "excelCopilotLastActivityDate": "",
            "powerPointCopilotLastActivityDate": "",
            "outlookCopilotLastActivityDate": "2026-10-21",
            "oneNoteCopilotLastActivityDate": "",
            "loopCopilotLastActivityDate": "",
            "copilotActivityUserDetailsByPeriod": [
                { "reportPeriod": 7 }
            ]
        },
        {
            [..next user...]
        }
    ]
}
~~~

This provides the latest activity data for users who have used the listed Microsoft 365 Copilot apps. But there is a catch.

### Organizational Reports Settings

As an administrator of a Microsoft 365 tenant, we have the ability to enable the obfuscation of user data in reports. This setting can be managed directly within the Admin portal, in *Settings / Org settngs / Reports*, as here (see also Governance Toolkit 365-Turn off obfuscation).

![Organizational report settings](organization-report-conceal-users.png)

The switch *"Display concealed user, group, and site names in all reports"* controls if usernames are visible or obfuscated:

- ON: Show anonymized usernames
- OFF: Show usernames

Many organizations leave anonymization active. This means that anonymous usernames are displayed in reports, as below.

### Report Copilot Usage with anonymized usernames

When the setting above is enabled, the Graph query returns random user data like in this sample: the userPrinicipalName and displayName properties are random numbers instead of useful names.

~~~json
{
    "value": [
        {
            "reportRefreshDate": "2026-10-22",
            "userPrincipalName": "04ED172AFFD17C931C567960999335F9",
            "displayName": "55F1D13D475D53DD4FA55E740CDD4032",
            "lastActivityDate": "2026-10-21",
            ...,
            "copilotActivityUserDetailsByPeriod": [
                { "reportPeriod": 7 }
            ]
        },
        {
            [..next anonymized user...]
        }
    ]
}
~~~

We cannot draw any conclusions about the users, their company, department or region. So, we need an alternative method here.

## Using the Microsoft 365 Security Audit Logs

To our rescue: The Microsoft 365 Security Audit Logs provide a comprehensive view of user activities, including interactions with Copilot. These logs capture detailed information about each interaction, such as the user involved, the time of the interaction, and the specific actions taken. This level of detail is essential for administrators who need to monitor usage patterns, identify potential issues, and ensure compliance with organizational policies. Thankfully, access to M365 Copilot can also be found here.

See a description at [Use Microsoft 365 audit logs with Microsoft Graph Data Connect](https://learn.microsoft.com/en-us/graph/microsoft365-audit-logs?WT.mc_id=AZ-MVP-4030574).

### Search in the Purview Portal

To do this interactively, an administrator can open the Microsoft Purview portal and the *Audit / Search* menu at https://purview.microsoft.com/audit/auditlogsearch. We can select the date and time range, and search for the *"Copilot activities"*. We select *"Interacted with Copilot"*, as here.

![Purview search filter](purview-search-copilot-filter.png)

When you click the Search button, the search is added to a queue and the form is reset. It may take some time for the search to be processed.

![Purview search query](purview-search-copilot-query.png)

When the search is completed, we should find matching records. In this sample, a user used the Copilot Web search. The data can be exported as CSV file (and this takes a while to be generated as well).

![Purview search result](purview-search-result.png)

The key benefits of using security audit logs are:

- Detailed User Information: Unlike anonymized Graph Reports, Security Audit Logs provide specific user details, allowing administrators to track individual usage patterns and identify high-value users or potential misuse.
- Comprehensive Activity Tracking: Audit logs capture a wide range of activities, including interactions with Copilot, making it easier to understand how users are leveraging the tool across different services.
- Compliance and Security: Detailed logs help organizations meet compliance requirements by providing a clear record of user activities, which is essential for audits and security investigations.

The disadvantages of using security audit logs are:

- Time-Consuming Search Queries: Search queries in Security Audit Logs can take a long time to process. This delay can hinder timely access to critical information.
- High Processing Costs: The processing of useful data from Security Audit Logs can be very costly. This includes both computational resources and the time required to analyze the data effectively.

Unfortunately, there is currently no ready-to-use connector to feed that data into another storage, like an Azure Log Analytics workspace, or similar. The M365 Sentinel data connector does not include audit log data with Copilot usage.

However, here we get Copilot usage data, even if the org settings obfuscation report settings are enabled. Therefore, it is legitimate to use this data for reports on the use of Copilot. This can be used to encourage users to use Copilot better or to optimize licenses.

### Access the Security Audit Logs from Graph

To access and filter the Security Audit Logs for Copilot interactions, you can use the Microsoft Graph API, too. This method is currently only available in Graph Beta. This endpoint requires the AuditLogsQuery.Read.All permission. The concept is the same as in the Purview portal: Create a new query, and check the status of the job. When the result is generated, you can access it. You can find the documentation at

- [auditLogQuery resource type](https://learn.microsoft.com/en-us/graph/api/resources/security-auditlogquery?view=graph-rest-beta&WT.mc_id=AZ-MVP-4030574)
- [Create auditLogQuery](https://learn.microsoft.com/en-us/graph/api/security-auditlogquery-get?view=graph-rest-1.0&tabs=http&WT.mc_id=AZ-MVP-4030574)
- [List auditLogQueries](https://learn.microsoft.com/en-us/graph/api/security-auditcoreroot-list-auditlogqueries?view=graph-rest-beta&tabs=http&WT.mc_id=AZ-MVP-4030574)
- [Get auditLogQuery](https://learn.microsoft.com/en-us/graph/api/security-auditlogquery-get?view=graph-rest-beta&tabs=http&WT.mc_id=AZ-MVP-4030574)
- [List auditLogRecords](https://learn.microsoft.com/en-us/graph/api/security-auditlogquery-list-records?view=graph-rest-beta&tabs=http&WT.mc_id=AZ-MVP-4030574)

Here's an example how to work with search queries in Graph. Create a new search query:

> POST https://graph.microsoft.com/v1.0/security/auditLog/queries

~~~json
{
  "filterStartDateTime": "2026-10-01T00:00:00Z",
  "filterEndDateTime": "2026-11-01T00:00:00Z",
  "operationFilters": [
    "copilotinteraction",
    "configuredcopilot"    
  ]
}
~~~

Once this is done: Get a list of search queries including their status:
> GET https://graph.microsoft.com/v1.0/security/auditLog/queries

Get the status of one specific search query:
> GET https://graph.microsoft.com/v1.0/security/auditLog/queries/<queryid> 

Get the result of a search query (when "status": "succeeded"):
> GET https://graph.microsoft.com/v1.0/security/auditLog/queries/<queryid>/records 

Here´s a (shortened) sample result. Note that the including data depends on the service itself, so the auditData can look completely different for various services.

~~~json
{
    "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#security/auditLog/queries('1177737b-a8ed-4e8c-acb8-d4c2201f2af5')/records",
    "@odata.count": 2,
    "@microsoft.graph.tips": "Use $select ...: GET security/auditLog/queries('<guid>')/records?$select=administrativeUnits,auditData",
    "value": [
        {
            "id": "<someid>",
            "createdDateTime": "2026-10-02T16:23:43Z",
            "operation": "CopilotInteraction",
            "userId": "<userid>",
            "userPrincipalName": "AdeleV@mytenant.onmicrosoft.com",
            "clientIp": null,
            "administrativeUnits": [ "" ],
            "auditData": {
                "Operation": "CopilotInteraction",
                ...
                "CopilotEventData": {
                    "AppHost": "Outlook",
                    "ThreadId": "<someid>@thread.v2",
                    "Messages": [
                        {
                            "Id": "1736612623080",
                            "isPrompt": true
                        },
                        {
                            "Id": "1736612623381",
                            "isPrompt": false
                        }
                    ],
                    "AccessedResources": [
                        {
                            "Action": "Read",
                            "SiteUrl": "https://outlook.office365.com/owa/?ItemID=<someid>&exvsurl=1&viewmodel=ReadMessageItem",
                            "Type": "http://schema.skype.com/HyperLink"
                        },
                        {
                            "Action": "Read",
                            "SiteUrl": "https://outlook.office365.com/owa/?ItemID=<someid>&exvsurl=1&viewmodel=ReadMessageItem",
                            "Type": "http://schema.skype.com/HyperLink"
                        }
                    ]
                }
            }
        },
        {
            [...next item...]
        }
    ]
}
~~~

The result therefore provides more or less at least information about the users and the type of copilot request.

## Conclusion

Microsoft Graph Reports are a useful source for analyzing Microsoft 365 Copilot adoption and usage. However, report anonymization can limit user-level insights.

Microsoft Purview Audit logs provide an alternative for analyzing Copilot activity at a more granular level. This enables administrators to better understand adoption, optimize license utilization, and support governance and compliance requirements.

Use the examples in this repository to explore Copilot usage in your own environment.

## Get the insights without building the solution

Want these insights without implementing and maintaining the reporting yourself? [Governance Toolkit 365](https://governancetoolkit365.com/) provides ready-to-use insights into your Microsoft 365 tenant, including Copilot usage and adoption.

![Governance Toolkit 365](gt365solution.png)

See what's happening in your Microsoft 365 tenant and make your data actionable.

[Governance Toolkit 365](https://governancetoolkit365.com/).
