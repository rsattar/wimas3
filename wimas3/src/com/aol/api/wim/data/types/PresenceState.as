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

package com.aol.api.wim.data.types {
    
	/**
	 * The presence state values of an AIM ID. An AIM ID can be in any one
	 * of these states.
	 */
	final public class PresenceState {
	    
		/**
		 * User is online and available to IM.
		 */
		public static const AVAILABLE:String = "online";

		/**
		 * Invisible - Only valid in myInfo objects.
		 * Definition of invisibility is TBD.
		 */
		public static const INVISIBLE:String = "invisible";

		/**
		 * For email lookups the address wasn't found.
		 */
		public static const NOT_FOUND:String = "notFound";

		/**
		 * User is online but either not at the computer or not interacting with the IM client.
		 * Idle is set by the client and different clients will set the state to idle under 
		 * different circumstances.
		 */
		public static const IDLE:String = "idle";

		/**
		 * User is online but away.
		 */
		public static const AWAY:String = "away";

		/**
		 * IMs will go to the user's mobile device.
		 */
		public static const MOBILE:String = "mobile";

		/**
		 * User is completely offline.
		 */
		public static const OFFLINE:String = "offline";
		
		/**
		 * User is online but not available to IM at the momment.
		 */
	    public static const NOT_AVAILABLE:String = "na";
	    
	    /**
	     * User is online but busy with another activity.
	     */ 
	    public static const BUSY:String = "busy";
	    
	    public static const BLOCKED:String = "blocked";
	    /**
	     * A request has been sent to add the user but the user hasn't responded yet.
	     * Historically, this state was only part of the ICQ process for adding buddies.
	     * This state does not historically exist in AIM clients.  Historically.  Like, 
	     * in history, yo.
	     */
	    public static const UNKNOWN:String = "unknown";
	    
	    /**
	     * User has something better to do than talk to you.
	     */
	    public static const OCCUPIED:String = "occupied";      

	}
}
