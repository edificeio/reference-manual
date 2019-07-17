The eventer is a simple publish-subscribe messaging system. Unlike native CustomEvents, it doesn’t have to be called from a DOM element, but can be used anywhere in your code.

It allows triggering and listening to custom messages.

``` typescript
import { Eventer } from ‘entcore-toolkit’;

const eventer = new Eventer();
```

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Description</th>
<th>Member</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Listen to an event</p></td>
<td><p><code>eventer.on(‘myevent’, () ⇒ console.log(‘event’));</code></p></td>
</tr>
<tr class="even">
<td><p>Stop listening</p></td>
<td><p><code>eventer.on(‘myevent’);</code></p></td>
</tr>
<tr class="odd">
<td><p>Stop listening for a specific function</p></td>
<td><p><code>const myFunc = () ⇒ console.log(‘f’);</code></p>
<p><code>eventer.on(‘myevent’, myFunc);</code> <code>eventer.off(‘myevent’, myFunc);</code></p></td>
</tr>
<tr class="even">
<td><p>Listen only once</p></td>
<td><p><code>eventer.once(‘myevent’, myFunc);</code></p></td>
</tr>
<tr class="odd">
<td><p>Trigger event</p></td>
<td><p><code>eventer.trigger(‘myevent’);</code></p></td>
</tr>
<tr class="even">
<td><p>Listen to an event with data</p></td>
<td><p><code>eventer.on(‘myevent’, (data) ⇒ console.log(‘event’ + data.message));</code></p></td>
</tr>
<tr class="odd">
<td><p>Trigger event with data</p></td>
<td><p><code>eventer.trigger(‘myevent’, {“message” : “hello !”});</code></p></td>
</tr>
</tbody>
</table>


