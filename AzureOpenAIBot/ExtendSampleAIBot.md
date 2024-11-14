# Sample code to work with Azure AI search

This sample is based on the Bot Framework State management Bot from the BotBuilder-Samples on GitHub:  
https://github.com/Microsoft/BotBuilder-Samples/blob/main/README.md#getting-the-samples  
The code example below extends this bot with Azure AI Search an Azure Open AI and was initially developed by our colleague [Peter Hödl](https://github.com/peterhoedl), atwork.at.

## Basis for your Bot (Agent)

Navigate to the Bot Framework Samples repository on GitHub and clone the repository to your local machine. This sample is based on the **State management bot**.  
https://github.com/Microsoft/BotBuilder-Samples/blob/main/README.md#getting-the-samples 

## Code snippte to extend a bot with Azure AI Search and Azure Open AI

```csharp
protected override async Task OnMessageActivityAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
{
    // Get the state properties from the turn context, and store the history of the conversation.

    // ...

    //Azure Cognitive Search Extension for Azure OpenAI Chat, Field Mappings
    AzureSearchIndexFieldMappingOptions azFieldConfig = new AzureSearchIndexFieldMappingOptions();
    azFieldConfig.ContentFieldNames.Add("content");
    azFieldConfig.TitleFieldName = "filename";
    azFieldConfig.UrlFieldName = "url";
    azFieldConfig.VectorFieldNames.Add("contentVector");

    AzureSearchChatExtensionConfiguration ExtensionConfig = new()
    {
        SearchEndpoint = _endpoint,
        IndexName = _indexName,
        SemanticConfiguration = _semanticConfig,
        Authentication = new OnYourDataApiKeyAuthenticationOptions(Startup.botConfiguration.searchKey),
        QueryType = AzureSearchQueryType.VectorSemanticHybrid,
        FieldMappingOptions = azFieldConfig,
        ShouldRestrictResultScope = false,
        VectorizationSource = new OnYourDataDeploymentNameVectorizationSource(_oaiVectorizer),
        DocumentCount = _maxResults,
        Strictness = _strictness
    };

    // Create Azure OpenAI Chat 
    ChatCompletionsOptions chatCompletionsOptions = new()
    {
        DeploymentName = _oaiModell,
        // The addition of AzureChatExtensionsOptions enables the use of Azure OpenAI capabilities that add to
        // the behavior of Chat Completions, here the "using your own data" feature to supplement the context
        // with information from an Azure Cognitive Search resource with documents that have been indexed.
        AzureExtensionsOptions = new AzureChatExtensionsOptions()
        {
            Extensions = { ExtensionConfig }
        }
    };

    // Use an Adaptive Card to send back the result
    AdaptiveCard card = new AdaptiveCard(new AdaptiveSchemaVersion(1, 3));

    // ...

    // Send Adaptive Card
    var adaptiveCardAttachment = new Attachment()
    {
        ContentType = "application/vnd.microsoft.card.adaptive",
        Content = JsonConvert.DeserializeObject(card.ToJson()),
    };
    var reply = MessageFactory.Attachment(adaptiveCardAttachment);
    await turnContext.SendActivityAsync(reply, cancellationToken);

    // ...

    }
    catch (Exception ex)
    {
        replyText = ex.Message;
        await turnContext.SendActivityAsync(replyText);
    }
}
```

## Explanation of the code snippet extensions in the State management bot

This C# method, [`OnMessageActivityAsync`], is an asynchronous method that is triggered when a message activity is received from the user. It's part of a chatbot built using the Microsoft Bot Framework and Azure Cognitive Search Extension for Azure OpenAI Chat.

The method starts by retrieving the state properties from the turn context. The turn context is an object that encapsulates all the information about the current turn of conversation with the user. The state properties are used to manage and persist data specific to a user and conversation.

The user's message is then added to the conversation history. The conversation history is stored in the conversation data object, which is part of the conversation state.

Next, an `OpenAIClient` object is created. This client is used to interact with the Azure OpenAI service. The client is configured with the OpenAI endpoint and key.

The method then sets up the Azure Cognitive Search Extension for Azure OpenAI Chat. This is done by creating an `AzureCognitiveSearchIndexFieldMappingOptions` object and setting its properties to map the fields of the Azure Cognitive Search index. An `AzureCognitiveSearchChatExtensionConfiguration` object is then created and configured with the search endpoint, index name, semantic configuration, key, query type, and field mapping options.

A `ChatCompletionsOptions` object is then created and configured with the deployment name and Azure extensions options. The Azure extensions options are set to use the Azure Cognitive Search Extension. The conversation history is then added to the `Messages` property of the `chatCompletionsOptions` object.

The method then creates an `AdaptiveCard` object. This is a card that can contain a mix of text, speech, images, buttons, and input fields.

The method then tries to get chat completions from the Azure OpenAI service using the `GetChatCompletionsAsync` method of the `OpenAIClient` object. The first choice of the response is then added to the body of the adaptive card. If the response used extensions, the method also adds context information to the adaptive card.

If an exception occurs while getting the chat completions, the method sends the exception message to the user.

Finally, the method creates an attachment with the adaptive card and sends it to the user. The user's message and the bot's response are then added to the conversation history.
