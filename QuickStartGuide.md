# Overview #

**wimas3** is a set of ActionScript 3.0 libraries which handle integration with the [Web AIM API](http://developer.aim.com/ref_api) (WIM). The core class for the wimas3 library is the session. The session handles sign on and also maintains the connection with the server. All calls to WIM will go through the session. Likewise, the session will fire events to represent events from the server. Since the session handles sign in and sign out, you will most likely only need to create the session once during the lifetime of your app.

This example assumes you are familiar with working with AS3, and already know to build the UI for your client. The purpose of this tutorial is to explain how to get online and listen for events, so you can "bring your UI to life!"

## Creating a Session ##

To create a session, the following parameters must be passed in:
  * The stage. This is required so the session can add itself to the display list.
  * The developer ID you have obtained from [AIM WIM Registration](http://developer.aim.com/wimReg.jsp)
    * When you register your key, be sure to select **No** for "Referrer Check" and **Yes** for "Client Login".

The following parameters are optional, but recommended:
  * A string representing the name of your client
  * A string representing the version of your client

There are more parameters available. For a full list of parameters please see the reference documentation.

Instantiating a session would look something like this:
```
import com.aol.api.wim.Session;
...
var devId:String = "xxxxxxxxxxxxxxxxx";
var session:Session = new Session(this.stage, devId, "WIM Test Client", ".1");
```

You do NOT need to create a new session every time you log in to WIM. See the next section on log-in.

## Logging in to AIM ##

Once the session is created, signing in is as simple as calling `signOn`. The important parameters are:
  * The user's login ID
  * The user's password
  * The challenge answer (this is only required if you are responding to an auth challenge).
It takes only one line of code to sign in and start the events loop with the server:
```
session.signOn("aimuser", "password");
```
During the sign on process, there will be a few events fired by the Session. The important one to listen to is the `SessionEvent.STATE_CHANGED` event. This will be called with various states as the sign in process progresses. Once sign in is complete, a `BuddyListEvent` will fire and provide the user's buddy list. See the next section, "Listening for Events" for more information.

To sign in with a different user, just call signOff and then call signOn again. There is no need to re-create the session object every time you want to log in with a different user. The session object allows for one user to be logged in at a time.

## Listening for Events ##

Once the session is created, you need to listen for events if you want your app to do anything. :) Here are some some events which you might want to listen for:
  * `SessionEvent.STATE_CHANGED`: Fired when the session's state changes. For a full list of session states, see the SessionState class in the reference documentation. A few important session states are:
    * `SessionState.OFFLINE`
    * `SessionState.ONLINE`
    * `SessionState.AUTHENTICATION_CHALLENGED`
    * `SessionState.AUTHENTICATION_FAILED`
    * `SessionState.DISCONNECTED`
  * `UserEvent.MY_INFO_UPDATED`: This will provide you with a `User` data object representing the signed in user.
  * `BuddyListEvent.LIST_RECEIVED`: When you sign in, this will provide you with a `BuddyList` data object. This event will provide a new buddy list after making any calls which affect the buddy list (add / removing buddies, etc.).
  * `IMEvent.IM_RECEIVED`: Provides an `IM` data object when an IM is received.
  * `IMEvent.IM_SEND_RESULT`: Provides you the result of a send IM call. If the `.statusCode` property is 200, that means the IM was sent succesfully.
  * `AuthChallengeEvent.AUTHENTICATION_CHALLENGED`: Fired when the user gets an authentication challenge. This can include SecureID passcodes, a CAPTCHA challenge, and a couple other challenges. Until we have further documentation on the AuthChallenge Event, please see the reference documentation for `AuthChallengeType`.

As an example, setting up a client to show a buddy list would look something like this:

```
import com.aol.api.wim.events.BuddyListEvent;
...
session.addEventListener(BuddyListEvent.LIST_RECEIVED, onBLReceived);

protected function onBLReceived(event:BuddyListEvent):void
{
    displayBuddyList(event.buddyList);
}

protected function displayBuddyList(bl:BuddyList):void
{
    //parse the buddy list and display it here.
}
```

There are quite a few events available which you might need to provide the desired functionality. See the `com.aol.api.wim.events` package for a full list of events.

## Sending and Receiving IMs ##

Sending and receiving IMs is quite simple. To send an IM, just call `sendIMToBuddy` with the buddy name and the message. To send an offline message if the buddy is not available, the fourth parameter must be true. See the documentation for more details.

Once the IM is sent, an `IMEvent.IM_SEND_RESULT` event will fire. Check the `statusCode` property for 200 to make sure that the send was successful. This would be the best time to show the IM in your IM history window.

```
import com.aol.api.wim.events.IMEvent;
...
//this is in session creation
session.addEventListener(IMEvent.IM_SEND_RESULT, onIMSendResult);
...
//send the IM
session.sendIMToBuddy("chattingchuck", "Hey, how is it going?");
...
//when IMs are sent
protected function onIMSendResult(evt:IMEvent):void
{
    //check evt.im.recipient and evt.im.sender to make sure you want to listen for the event
    if(evt.statusCode == 200)
    {
        //im was sent succesfully. Now would be a good time to show the message in 
        //the message history.
    }
}
```

To receive IMs, all you have to do is listen to the `IMEvent.IM_RECEIVED` event. Note that if the IM is an offline IM, most of the user information will be empty and you will need to make a `requestBuddyInfo` call to get the sender's presence information.
```
session.addEventListener(IMEvent.IM_RECEIVED, onIMReceived);
...
protected function onIMReceived(evt:IMEvent):void
{
    //do something here.
}
```

## Getting Buddy Info ##

When you sign in, the `BUDDY_LIST_RECEIVED` event will give you presence information for all the users on the buddy list. In addition, `UserEvent.BUDDY_PRESENCE_UPDATED` events will automatically fire when the presence changes for users on the buddy list. If you wish to receive presence information for other users, you can call `requestBuddyInfo`. Once the information is retrieved, a `UserEvent.BUDDY_PRESENCE_UPDATED` event will fire for that user. If you pass an array of screennames to `requestBuddyInfo`, you will get one event per screenname.

```
import com.aol.api.wim.events.UserEvent;
...
//add the event listener only once 
session.addEventListener(UserEvent.BUDDY_PRESENCE_UPDATED, onPresenceUpdated);
...
//request the buddy information. Either pass a string or an array of strings.
session.requestBuddyInfo("chattingchuck");
...
//listen for the presence updated event
protected function onPresenceUpdated(evt:UserEvent):void 
{
    //update your display here
}
```

`requestBuddyInfo` only returns a limited amount of information with the default options. You can pass it an object with optional parameters to get more data. See the API Reference Documentation for more details.