ODE framework comes with a asynchronous and customizable CAS Server. The identity attributes pass in <https://github.com/apereo/cas/blob/4.2.x/cas-server-documentation/protocol/CAS-Protocol-Specification.md#252-response> \[/serviceValidate\] can be changed by exttending the *DefaultRegisteredService* Java’s class.

> **Note**
>
> take a look at <https://github.com/web-education/cas-server-async> to deep into our cas server impleentation.

# Specific CAS ticket

The **org.entcore.cas.services** package contains services which output custom attributes to the CAS ticket. It’s usefull to integrate third-party application that need extra identity attributes.

## Specific SAML CAS ticket

<table>
<caption>prepareUser contract</caption>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th>Param</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>user</p></td>
<td><p>fr.wseduc.cas.entities.User</p></td>
<td><p>Cas ticket</p></td>
</tr>
<tr class="even">
<td><p>userId</p></td>
<td><p>String</p></td>
<td><p>Graph user Id</p></td>
</tr>
<tr class="odd">
<td><p>service</p></td>
<td><p>String</p></td>
<td><p>Service URI</p></td>
</tr>
<tr class="even">
<td><p>data</p></td>
<td><p>JsonObject</p></td>
<td><p>User data, see registered service example for more details</p></td>
</tr>
</tbody>
</table>

**Basic example:** default identifier as the value for the user tag and the PROFIL attribute as additional attributes

``` java
package org.entcore.cas.services;

import ...

public class $YourName$RegisteredService extends DefaultRegisteredService {

    protected static final String PROFILE = "PROFILS";

    @Override
    public void configure(org.vertx.java.core.eventbus.EventBus eb, Map<String,Object> conf){
        super.configure(eb, conf);
    }

    @Override
    protected void prepareUser(User user, String userId, String service, JsonObject data) {
        user.setUser(principalAttributeName);
        user.setAttributes(new HashMap<String, String>());

        // Profile example
        JsonArray profiles = data.getArray("type", new JsonArray());
        if (profiles.contains("Teacher")) {
            user.getAttributes().put(PROFILE, "National_3");
        } else if (profiles.contains("Student")) {
            user.getAttributes().put(PROFILE, "National_1");
        }
    }
}
```

> **Note**
>
> $YourName$ must be replaced by the name of your regitered service. **principalAttributeName** has by default "login" value, but it’s possbile to configure.

## Specific CAS 2 ticket

<table>
<caption>prepareUser contract</caption>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th>Param</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>user</p></td>
<td><p>fr.wseduc.cas.entities.User</p></td>
<td><p>Cas ticket</p></td>
</tr>
<tr class="even">
<td><p>userId</p></td>
<td><p>String</p></td>
<td><p>Graph user Id</p></td>
</tr>
<tr class="odd">
<td><p>service</p></td>
<td><p>String</p></td>
<td><p>Service URI</p></td>
</tr>
<tr class="even">
<td><p>data</p></td>
<td><p>JsonObject</p></td>
<td><p>User data, see registered service example for more details</p></td>
</tr>
<tr class="odd">
<td><p>doc</p></td>
<td><p>org.w3c.dom.Document</p></td>
<td><p>xml doc</p></td>
</tr>
<tr class="even">
<td><p>additionnalAttributes</p></td>
<td><p>List&lt;org.w3c.dom.Element&gt;</p></td>
<td><p>xml element</p></td>
</tr>
</tbody>
</table>

**Basic example:** default identifier as the value for the user tag and the UID attribute as additional attributes

``` java
package org.entcore.cas.services;

import ...

public class $YourName$RegisteredService extends AbstractCas20ExtensionRegisteredService {

    protected static final String UID = "uid";

    @Override
    public void configure(org.vertx.java.core.eventbus.EventBus eb, java.util.Map<String,Object> conf) {
        super.configure(eb, conf);
    };

    @Override
    protected void prepareUserCas20(User user, String userId, String service, JsonObject data, Document doc, List<Element> additionnalAttributes) {
        user.setUser(data.getString(principalAttributeName));

        try {
            // Uid
            if (data.containsField("externalId")) {
                additionnalAttributes.add(createTextElement(UID, data.getString("externalId"), doc));
            }

        } catch (Exception e) {
            log.error("Failed to transform User for Uid service", e);
        }
    }

}
```

> **Note**
>
> $YourName$ must be replaced by the name of your regitered service. **principalAttributeName** has by default "login" value, but it’s possbile to configure.
