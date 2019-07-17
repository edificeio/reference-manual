The workspace exposes some utilities to create and save files. This can be very useful if you want to save or export the user’s creations in a file for instance, saving as an image or as text some content they’re working on.

We usually make any file generated on the platform available in the workspace.

``` typescript
import { workspace, Document, quota } from ‘entcore’;

// The user’s total allocated space
quota.max
// Space used
quota.used

// Upload a file:
const doc = await workspace.upload(files[i]);
// Upload a blob:
const doc = await workspace.upload(myBlob);
// Upload a public - this will make the file visible the unregistered users:
const doc = await workspace.upload(myBlob, ‘public’);
```
