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
    import com.aol.api.wim.data.BuddyList;
    import com.aol.api.wim.data.Group;
    import com.aol.api.wim.data.User;
    
    import flash.events.Event;

    /**
     * The <code>BuddyListEvent</code> is fired when either groups or users are 
     * added, removed, or moved on the buddy list. 
     */

    public class BuddyListEvent extends Event
	{
        /**
         * This event fires when a full buddy list is received. 
         */
	    public static const LIST_RECEIVED:String = "buddyListReceived";
	    
	    /**
	     * This event is fired before a buddy is added to the buddy list.
	     */
        public static const BUDDY_ADDING:String = "buddyAdding"; 
        /**
         * The value for the type property of a buddy added event object. 
         */
        public static const BUDDY_ADD_RESULT:String = "buddyAddResult";
        /**
         * This event is fired before a buddy is removed from the buddy list.
         */
        public static const BUDDY_REMOVING:String = "buddyRemoving"; 
        /**
         * The value for the type property of a buddy removed event object. 
         */
        public static const BUDDY_REMOVE_RESULT:String = "buddyRemoved";

        /**
         * The value for the type property of a group added event object. 
         */
        public static const GROUP_ADD_RESULT:String = "groupAddResult";
        /**
         * The value for the type property of a group removed event object. 
         */
        public static const GROUP_REMOVE_RESULT:String = "groupRemoveResult";

        /**
         * The buddy associated with the event. Only valid for buddy added, buddy moved, and buddy removed events.
         * This is null for group events and the LIST_RECEIVED event.
         * 
         * For the BUDDY_ADDING event, the only property that is set on the user object is the aimId.
         */
        public var buddy:User;

        /**
         * The group associated with the event. If it is a buddy related event, it represents that buddy's group. 
         * This is null for the LIST_RECEIVED event.
         */        
        public var group:Group;
        
        /**
         * This property is only valid for LIST_RECEIVED events, and it represents the user's
         * entire buddy list. 
         */
        public var buddyList:BuddyList;
        
        public function BuddyListEvent(type:String, buddy:User, group:Group, buddyList:BuddyList=null, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            this.buddy = buddy;
            this.group = group;
            this.buddyList = buddyList;
        }

        override public function clone():Event
        {
            return new BuddyListEvent(type, buddy, group, buddyList, bubbles, cancelable);
        }
        
        override public function toString():String
        {
            var output:String = "[BuddyListEvent." + this.type + 
                                " buddy=" + buddy.toString() + 
                                ", group=" + group.toString() +
                                ", buddyList" + buddyList.toString() + 
                                "]";
            return output; 
        }
    }
}