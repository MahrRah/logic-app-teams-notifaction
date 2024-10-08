
# Deploy Automated Teams Alerting

Tags: #IAC, #Teams,# Azure, #Tutorial
TL;DR: Two ways to configure your solution to send alerts to a Teams channel and their pros and cons.

How many of you work on projects where you have alerts set up, but since they're in your Azure portal, they mostly just collect dust and sometimes even auto-resolve without a developer ever looking at them?

Sound familiar?

A good solution would be to reroute the alerts to something like Teams. We spend most of our time on tools like Teams anyway, so why not use it to our advantage and have it display the alerts our different environments send?

Now, you might say, "Well, if they auto-resolve, why should I care?"

I would say you should. More often than not, some transient errors are recurring. They won't just go away if you keep ignoring them. So getting properly notified whenever one of them occurs gives you the chance to avoid forgetting about them in the heap of 'resolved-but-ignored' alerts.

## Option 1: Teams Connector on Azure Logic Apps

Use the logic Apps Teams Action to post messages into a teams channel
![alt text](teams-action.png)

### Known Issues

#### Manual Authorization step

#### Authorization to different User via Portal

Authorization step in the Azure portal always used logged in user for authentication, no matter which one is being selected in the log in wizard. See [response to post here](https://stackoverflow.com/questions/53530638/how-do-you-authenticate-a-logic-app-microsoft-web-connections-connection-with-co)

#### Token timeout

> TBD
> Notes: [Re-auth Azure Monitor Logs API connection](https://learn.microsoft.com/en-us/answers/questions/241612/azure-monitor-logs-api-connection)

#### Manual Authorization needed and technical User

## Option 2: Teams Webhook

Use the Teams Webhook feature to send a action card via a POST request.
![alt text](teams-webhook.png)

## WIP: Resources

- [MS Teams Power Platform docs](https://learn.microsoft.com/en-us/connectors/teams/?tabs=text1%2Cdotnet)
- [Teams webhook docs](https://learn.microsoft.com/en-us/connectors/teams/?tabs=text1%2Cdotnet#microsoft-teams-webhook)
