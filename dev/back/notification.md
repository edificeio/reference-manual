ODE framework provides an user’s notification system. It’s enable any application to send or bradcast notifications about key events (from the user’s point of view). Notifications can be deliver through 3 channels :

-   INTERNAL : display on user timeline’s screen

-   EXTERNAL : send by email

-   PUSH NOTIFICATION : send via mobile platform messaging system

> **Note**
>
> This section focuses on notification’s developement. Refer to [Advanced topics](../../ops/advanced-topics/index.md) to learn how to configure the platform’s notification policy

# Internal Notification

# Email Notification

# Push Notification

In ODE Framework, Push Notification are enable through FCM [1]. It provides a de facto standard for messaging and cross-platform capabilities.

## Configure

### FMC

1.  Create a google service account and get a private key : <https://developers.google.com/identity/protocols/OAuth2ServiceAccount>

2.  Activate FCM on [Cloud Platform Console](https://support.google.com/cloud/answer/6158841?hl=en)

### ODE

In ${}

    pushNotif = {
        "uri": "https://accounts.google.com:443",
        "tokenUrn": "/o/oauth2/token",
        "scope": "https://www.googleapis.com/auth/firebase.messaging",
        "url": "https://fcm.googleapis.com/v1/projects/{{project_id}}/messages:send",
        "client_mail": {{client_mail}},
        "aud": "https://accounts.google.com/o/oauth2/token",
        "key": {{private_key}}
    }

[1] [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging/)
