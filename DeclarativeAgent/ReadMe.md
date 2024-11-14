# DeclarativeAgent

Declarative agents are customized versions of Microsoft 365 Copilot that enable customers to create personalized experiences that run in Microsoft 365 Copilot.  
Therefore, end users require a Copilot license.  Users can build declarative agents with capabilities and instructions on their purpose and behavior. Users can also add the option to access enterprise knowledge (including SharePoint and Graph Connectors).  
End users can see declarative agents on the right side panel under Copilot.

## Resources

- https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/overview-declarative-agent
- https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/transparency-faq-declarative-agent
- https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/build-declarative-agents?tabs=ttk
- https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/declarative-agent-manifest#web-search-object
- https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/build-declarative-agents?tabs=ttk&tutorial-step=5&source=docs

## Start

Start by using VSCode and the Teams Toolkit to create a new project.
Follow the steps described at https://microsoft.github.io/copilot-camp/#hands-on-labs.

## Capabilities object

The capabilities object serves as the foundational type within the capabilities property of the declarative agent manifest object. The potential object types include:

- Web search object
- OneDrive and SharePoint object
- Microsoft Graph Connectors object

~~~json
{ …
    "capabilities": [
        {
            "name": "WebSearch",
            "search_terms": [ "M365 Compliance Center", … ]

        },
        {
            "name": "OneDriveAndSharePoint",
            "items_by_url": [
                {"url": "${{SP_SITE_URL}}" }, … 
            ]
        },
        {
            "name": "GraphConnectors",
            "connections": [
                { "connection_id": "Conference" }
            ]
        }
    ]
}
~~~



