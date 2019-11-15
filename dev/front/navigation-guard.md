# Navigation guards

This module let the user aborts the navigation if some content has been edited and not saved.

This module is composed of:
- navigationGuardService
- navigation listeners
- navigation guards

## navigationGuardService

The *navigationGuardService* is a singleton that expose the following methods:

```ts

export const navigationGuardService = {
    generateID(): string //an ID generator for guards
    registerGuard(rootID: string, guard: INavigationGuard) //lets register a guard related to a groupId
    unregisterGuard(rootID: string, guard: INavigationGuard)//lets unregister a guard related to a groupId
    unregisterRoot(rootID: string) //lets register all guards related to a groupId
    registerIndependantGuard(guard: INavigationGuard)//lets register a guard that is not part of any group
    unregisterIndependantGuard(guardID: string)//lets unregister a guard not related to a group
    registerListener(listener: INavigationListener) //register a navigation listener
    unregisterListener(listener: INavigationListener)//unresgiter a navigation listener
    tryNavigate(navigation: INavigationInfo)//check if content has been saved before navigating
    reset(rootID: string)//reset guard related to rootId (if so the content inside the form rootId has been saved or modification has been canceled)
    resetAll() //reset ALL guard related to rootId (if so the content of ALL forms has been saved or modification has been canceled)
}
```

The service is used by directives to :
- register/unregister guards
- register/unregister listener
- reset guards
- trigger navigation if needed

## Navigation Listeners

Listeners are in charge of detecting navigation event. They have the following interface:

```ts
export interface INavigationListener {
    onChange: Subject<INavigationInfo>; //a stream that emit event on navigation detected
    start(): void; //called when listener is registered to navigationGuardService
    stop(): void;//called when listener is unregistered from navigationGuardService
}
```

Today we have the following listeners:
- AngularJSRouteChangeListener: it detects angular route changes
- DOMRouteChangeListener: it detects DOM navigation changed (browser URL change or tab closed...)
- TemplateRouteChangeListener: it detects when template.open is called (so the view changes)

## Navigation Guards

Guards are responsible of detecting changes. They have the following interface:

```ts
export interface INavigationGuard {
    reset(): void; //called to tell the guard that the current state has been saved
    canNavigate(): boolean; //lets know if content has changed (whether we ask the user in case of navigation)
}
```

Today we have the followings guards:
- InputGuard<T>: A generic guard that compare the current value to the reference value. It accepts a custom comparator as argument.
    - The reference value is computed from the initial value or when the guard is resetted (reset => reference=currentValue)
    - The current value is a getter that lets fetch the current value of an input
- ObjectGuard: A guard that use a model to check if content has changed. The model must implement IObjectGuardDelegate. It has the following interface:

```ts
export interface IObjectGuardDelegate {
    guardObjectIsDirty(): boolean;
    guardObjectReset(): void;
}
```

## Directives

The module exposes the following directives that make easy to use all concept above.

### guard-root

It an attribute directive generally put on body tag or on form tag.
It is responsible of:
- initting listeners (if needed)
- define a group of guard (each distinct form in the page define its own guard-root to isolate forms)

```html
<form guard-root>
    <!--...-->
</form>
```

Optionally, you may force the root ID like so:

```html
<form guard-root="myRoot">
    <!--...-->
</form>
```

This will allow you to interact with this root even if your directive is outside of it. See the reset-guard-id option of reset-guard below for more info.

### reset-guard

It is an attribute directive that receive an expression as param.
The expression must return a Promise.
In the following example the save methods return a promise:

```html
<form reset-guard="onsave()"></form>
<button reset-guard="save()"></button>
```

The directive listen 2 dom events:
- submit: if the tag is a "form"
- click: for any other tag

If you need to listen to an event other than these, you may specify the reset-guard-event option:

```html
<editor reset-guard="saveChanges()" reset-guard-event="change"/>
```

The directive wait that the promise resolved (so the save succeed) and then it reset guards relative to its groups (=relative to its form).

The reset-guard will reset its closest-parent guard-root, or all guards on the page if none is found.
If you need to put a reset-guard outside of the guard-root you wish to reset, you may use the reset-guard-id option:

```html
<button reset-guard="save()" reset-guard-id="myRoot"></button>
<form root-guard="myRoot">
    <!--...-->
</form>
```

### guard-ignore-template

It is an attribute directive that can be put in 2 place:
- in the same tag as guard-root => in this case all template.open are ignored by default
- in a "container" tag => the view change occured in this container are ignored (it overrides the default value)

```html
<form reset-guard="onsave()" guard-ignore-template></form>
<container guard-ignore-template name="mainContainer"></container>
```

### guard-trigger-template

It is an attribute directive that can be put in 2 place:
- in the same tag as guard-root => in this case all template.open trigger navigation changes by default
- in a "container" tag => the view change occured in this container triggers navigation changes (it overrides the default value)

```html
<form reset-guard="onsave()" guard-trigger-template></form>
<container guard-trigger-template name="mainContainer"></container>
```

### input-guard

It uses the ngModel value of an input to detect change and prevent navigation

```html
<input ng-model="myModel" input-guard/>
```

### dirty-guard

It uses the ngModel DIRTY flag of an input to detect change and prevent navigation

```html
<input ng-model="myModel" dirty-guard/>
```

### document-guard

The same as input-guard but it considers that the model value is a Document (media-library for example)

```html
<input ng-model="myModel" document-guard/>
```

### custom-guard

The same as input-guard but it considers that the model value is a custom object implementing IObjectGuardDelegate (mindmap use it)

```html
<input ng-model="myModel" custom-guard/>
```

### navigation-trigger

It is an attribute directive that trigger navigation change on click. It accept an expression as params, this expression is evaluated if the user accept to continue the navigation.

```html
<button navigation-trigger="nexStep()"></button>
```