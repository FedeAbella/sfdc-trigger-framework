# Salesforce Trigger Framework

A lightweight, modular, easy to use Trigger Framework for Salesforce development. Quick to start working with, and helps keep your triggers clean, happy, and easy to create!

## Where do I start? (How to Use)

The core framework happens in 3 Apex classes:

- [`TriggerDispatcher.cls`](/force-app/main/default/classes/TriggerDispatcher/TriggerDispatcher.cls) handles all trigger routing for you. No more writing `if/else` logic in your handlers (or heavens forbid, in the `.trigger` file!), or checking whether it is an Before Insert, or After Delete. Just focus on what matters: the actual business logic.
- [`ITriggerValidatorInterface.cls`](/force-app/main/default/classes/ITriggerValidatorInterface/ITriggerValidatorInterface.cls) gives you an interface to work with if you want the ability to dynamically decide whether a given trigger should actually run. [`TriggerDispatcher.cls`](/force-app/main/default/classes/TriggerDispatcher/TriggerDispatcher.cls) will call on an implementation of this before each run to know whether it should go ahead with the trigger logic. We've all seen trigger helpers with `static Boolean` flags so you can avoid calling some logic when some conditions are set. Well, let the Validator Interface handle that and stop dealing with random stray flags all over the place.
- [`ITriggerHandlerInterface.cls`](/force-app/main/default/classes/ITriggerHandlerInterface/ITriggerHandlerInterface.cls) gives you the backbone for all your Trigger Handlers. All you need to do to create a new Trigger Handler is create a class that implements the interface, and make sure you've got one method to call for each Trigger Operation (`beforeInsert()`, `afterInsert()`, and so on). You're probably already doing this, so even changing an existing project to use this should be quick and easy!

With this, your triggers should only have one line like:

```apex
new TriggerDispatcher().run(<ITriggerHandlerInterface implementation>, <ITriggerValidatorInterface implementation>);
```

And that's it. Easy, right?

## Wait, I need to implement interfaces? I thought this was easy!

Don't worry, I got you! I wouldn't just dump this on you and make you do work! Ugh.

I've already gone ahead and taken care of a few implementations for you. Feel free to start with these, or create your own.

### Trigger Handlers

- [`TriggerHandler.cls`](/force-app/main/default/classes/TriggerHandlers/TriggerHandler.cls) is an abstract class that implements `ITriggerHandlerInterface`. With it, all you need to do is have your own Trigger Handlers extend this class (don't even need to implement the interface!), and you've already got:

  - All trigger context methods required by the interface already implemented. No need to write methods that you won't use. Just `override` the ones you need, and you're done!
  - Some helpful methods that are already implemented, and you can simply call from within your own Trigger Handlers, without needing to go around repeating code. (e.g.: say you create `AccountTriggerHandler` which `extends TriggerHandler`, you can simply call `this.isInsert()` from within your `AccountTriggerHandler` without doing any further work)

- Do you want all the pre-built context methods, but none of the overhead of the utility methods? Take [`TriggerHandler_NoUtils.cls`](/force-app/main/default/classes/TriggerHandlers/TriggerHandler_NoUtils.cls) instead! This will give you just the barebones methods for Trigger Handlers, no extra cheese. (Just, you know, you might want to rename that class)

### Trigger Validators

- [`TriggerValidator.cls`](/force-app/main/default/classes/TriggerValidators/TriggerValidator.cls) gives you full control on when your triggers will run, both dynamic and declaratively! The class itself comes with methods for bypassing a trigger during a transaction, or even a particular trigger context (i.e.: you may choose to bypass Account `after insert` triggers, while still having the `before insert` logic run). This also gives you access to [`Trigger_Setting__mdt`](/force-app/main/default/objects/Trigger_Setting__mdt), a Custom Metadata Type which lets you declaratively disable (turn off entirely) either all triggers for a given object, or particular trigger operations. All from the Salesforce Setup using with clicks, not code! Use it just when you need to disable a trigger. Create a `Trigger_Setting__mdt` record, choose the object, check some checkboxes, and _presto_! You don't even need to create records for triggers you don't want to turn off.

- Uncle Ben did say _"With great power comes great responsibility"_, and giving admins full access to disabling triggers from the Setup is for some, admittedly, **too much** power. I've run into situations which could've benefitted from it, but it's a power to be used sparely, if at all. And if you're the kind of person that thinks it's better not to have that option even laying around, then just take the [`TriggerValidator_NoMetadata.cls`](/force-app/main/default/classes/TriggerValidators/TriggerValidator_NoMetadata.cls) class instead. You'll still get all the benefits of being able to bypass triggers just during a transaction, without exposing anything in the Setup. (Again, you might want to rename things, but who am I to judge?)

- Does none of those fit your needs? Then by all means, go ahead an create your own implementation of `ITriggerValidatorInterface`, give it the logic your org and/or business needs, and you're set to go.

And the good thing is, you'll probably ever going to need only a single implementation of each interface. So if you're taking one of each of the implementations above, you don't need to do anything else.

## Is this all properly tested? How do I know this works?

Of course it's tested! We're all very thorough in testing as much of our code as possible, right? _Right?_ Good!

Here's the Apex coverage as it stands on 2023-10-13 (I'll do my best to update this if and when anything changes):

| CLASSES                     | PERCENT | UNCOVERED LINES |
| --------------------------- | ------- | --------------- |
| TriggerValidator            | 94%     | 153,154,155     |
| TriggerDispatcher           | 100%    |                 |
| TriggerHandler_NoUtils      | 100%    |                 |
| TriggerValidator_NoMetadata | 100%    |                 |
| TriggerHandler              | 98%     | 155             |

Now, you may be asking what test classes you'll need to take if you're only picking and choosing some Handler, Validator, or none at all. Here's the rundown:

- For the core components ([`TriggerDispatcher.cls`](/force-app/main/default/classes/TriggerDispatcher/TriggerDispatcher.cls), [`ITriggerHandlerInterface.cls`](/force-app/main/default/classes/ITriggerHandlerInterface/ITriggerHandlerInterface.cls), and [`ITriggerValidatorInterface.cls`](/force-app/main/default/classes/ITriggerValidatorInterface/ITriggerValidatorInterface.cls)), you'll need:
  - [`ITriggerHandlerStub.cls`](/force-app/main/default/classes/ITriggerHandlerInterface/ITriggerHandlerStub.cls) and [`ITriggerValidatorStub.cls`](/force-app/main/default/classes/ITriggerValidatorInterface/ITriggerValidatorStub.cls) provide the necessary stubs so you can run...
  - ... [`TriggerDispatcherTest.cls`](/force-app/main/default/classes/TriggerDispatcher/TriggerDispatcherTest.cls) without needing to even have interface implementations.
- For any of the [`TriggerValidators`](/force-app/main/default/classes/TriggerValidators), simply take the matching test class of the same name. All good to go!
- Same goes for [`TriggerHandlers`](/force-app/main/default/classes/TriggerHandlers), you just need the matching test class. Except for, if you're using [`TriggerHandler.cls`](/force-app/main/default/classes/TriggerHandlers/TriggerHandler.cls), you'll also need to take the [`TriggerHandlerMock.cls`](/force-app/main/default/classes/TriggerHandlers/TriggerHandlerMock) class with you, so everything is properly tested.

## What about X functionality?

Trigger Handlers can go from very simple to full of bells and whistles, and do all kinds of things for you. At time of writing this (2023), I've got about 2 years in Salesforce, and decided to start small(-ish). Focus on doing a couple of things _well_, rather than overextending, and keep it simple, and easy to use.

That being said, there's definitely a lot more that these classes could do, and I'd be happy to consider what you think would be a good addition to them. Feel free to [open a new issue](https://github.com/FedeAbella/sfdc-trigger-framework/issues/new) and let me know.

Found any bugs, or places this could be done better? Also, please let me know and I'll happily improve this as much as possible.
