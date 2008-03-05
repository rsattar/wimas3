/* 
Copyright (c) 2008 AOL LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the AOL LCC nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
*/

package com.aol.api.wim.events
{
    import com.aol.api.logging.ILog;
    import com.aol.api.logging.Log;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IEventDispatcher;

    /**
     * The AIM Event Controller provides us with a single point to register and dispatch events that are
     * capturable and cancellable without requiring client side code to exist in a Flash display list.
     * 
     * <p>
     * It achieves this by internally creating two <code>Sprite</code>s and adding them to a supplied parent
     * <code>DisplayObjectContainer</code>. The UI hierarchy is abstracted out so that someone using this
     * class can listen for events as normal with or without setting the <code>useCapture</code> flag set to
     * true when calling addEventListener.
     * </p>
     * 
     * <p>
     * You may ask, why does this "non-ui" library have an object on the display list?  Events propogate 
     * though the display list in three phases:  Capture, Target, and Bubble.  There's a great diagram of this
     * on http://www.adobe.com/devnet/actionscript/articles/event_handling_as3_03.html.  The event drills down
     * to the target through its parents on the Capture phase, then it hits the target, then it bubbles back
     * up through the targets parents on the Bubble phase.  Here's an example:
     * </p>
     * 
     * <p>
     * <strong>Capture Phase</strong><br/>
     * Event goes through the Stage.<br/>
     * Event goes through the target's parent.<br/>
     * </p>
     * 
     * <p>
     * <strong>Target Phase</strong><br/>
     * Event arrives at the target, the target performs the default action for this event.
     * </p>
     * 
     * <p>
     * <strong>Bubble Phase</strong><br/>
     * Event goes back through the target's parent.<br/>
     * Event goes back through the Stage.<br/>
     * </p>
     * 
     * <p>
     * If you call addEventListener with only two arguments, your listener will be called 
     * during the Bubble phase, after the target has performed the default action for the event.  However,
     * if a listener sets the third parameter of addEventListener to <code>true</code>, the
     * listener will be called <i>before</i> the target gets the event.  This lets listeners to intercept
     * events before they reach their targets.
     * </p>
     * 
     * <p>
     * For this class, all events listeners are registered in the "parent" sprite, while all events are actually dispatched from
     * the internal "child" sprite. By keeping all listeners at one step above the dispatcher, they can easily
     * register to "capture" events and potentially modify data / cancel the event.  This is important for integrators
     * and for plugins which we're planning to support in the future. 
     * </p>
     * 
     * Examples:<br/>
     * <p>
     * Say you want to translate outgoing IMs to a particular person into French.  You would capture the IMEvent.IM_SENDING 
     * event and set <code>useCapture</code> to <code>true</code>.  You could them modify the actual
     * text of the IM contained in the event, and then send it on it's way.  When it reaches its target,
     * the library will actually send the IM.
     * </p>
     * <p>
     * Say you want to strip out bad words incoming IMs.  You would capture the IMEvent.IM_RECIEVED event before
     * it hits its target.  You'd modify the text if necessary and then let the event proceed.
     * </p>
     * <p>
     * Say you want to know when a new buddy is added to the buddy list but you don't need to modify it
     * before it happens.  In that case, you could call <code>addEventListener(BuddyListEvent.BUDDY_ADDED, yourListener)</code>.  
     * Because you used only two arguments, your listener will be called after the buddy is added to the users
     * buddy list. 
     * </p>
     * 
     * @see http://www.adobe.com/devnet/actionscript/articles/event_handling_as3_03.html
     */
    public class EventController implements IEventDispatcher
    {
        internal var parent:Sprite          =   null;
        internal var dispatchSprite:Sprite  =   null;
        internal var container:DisplayObjectContainer   =   null;
        // Logging object
        private var _logger:ILog              =   null;
        
        
        public function EventController(displayContainer:DisplayObjectContainer, logger:ILog=null):void {
            
            container = displayContainer;
            // Create a parent sprite and a inner sprite... the inner sprite dispatches events
            parent = new Sprite();
            dispatchSprite = new Sprite();
            parent.addChild(dispatchSprite);
            
            _logger = logger ? logger : new Log("AIMEventController");
            if(!container) {
                _logger.warn("No stage or container was supplied. " + 
                            "you will not be able " + 
                            "to receive any events!");
            } else {
                container.addChild(parent);
            }
            // Event model structure (capture through bubble):
            // displayContainer --> [Capture] parent --> [At Target] dispatch --> [Bubble] parent --> displayContainer
        }
        
        /**
         * Registers a listener at one layer ABOVE the dispatchSprite. This is so the 'capture' phase can be
         * correctly listened for. Non 'capture'-phase events technically listen at the 'bubble' phase. Events are only
         * ever dispatched from the inner <code>dispatchSprite</code>, which means that all registered listeners will correctly
         * receive an 'at target' phase once we bubble to the parent sprite (where all the listeners are registered).
         */
        public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
            // always add to parent
            parent.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
            parent.removeEventListener(type, listener, useCapture);
        }
        
        public function dispatchEvent(event:Event):Boolean {
            // Always fire the event from the inner child (so we get a proper "bubble" phase, which to our listeners is the 'at target' phase)
            return dispatchSprite.dispatchEvent(event);
        }
        
        public function hasEventListener(type:String):Boolean {
            return parent.hasEventListener(type);
        }
        
        public function willTrigger(type:String):Boolean {
            return parent.hasEventListener(type);
        }
        
    }
}