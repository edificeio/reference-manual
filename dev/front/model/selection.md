---
title: selection
id: selection
---
The selection tool is a basic utility to make working with lists of selectable items easier. It works by simply passing an array to a new Selection:

``` typescript
import { Selection } from ‘entcore-toolkit’;

const selection = new Selection(myArray);
```

The objects inside the Array should implement Selectable, which simply means they have a selected property. The selected property will be true when an user has selected the item, false otherwise.

The selection can then be used for various operations:

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
<td><p>Get all selected items</p></td>
<td><p><code>selection.selected</code></p></td>
</tr>
<tr class="even">
<td><p>Select all items</p></td>
<td><p><code>selection.selectAll();</code></p></td>
</tr>
<tr class="odd">
<td><p>Deselect all items</p></td>
<td><p><code>selection.deselectAll();</code></p></td>
</tr>
<tr class="even">
<td><p>Number of selected items</p></td>
<td><p><code>selection.length</code></p></td>
</tr>
<tr class="odd">
<td><p>Number of items in the whole collection</p></td>
<td><p><code>selection.colLength</code></p></td>
</tr>
<tr class="even">
<td><p>Select items matching predicate</p></td>
<td><p><code>selection.select(e ⇒ e.name === ‘match’)</code></p></td>
</tr>
<tr class="odd">
<td><p>Remove selected items from the whole collection</p></td>
<td><p><code>selection.removeSelection()</code></p></td>
</tr>
</tbody>
</table>


