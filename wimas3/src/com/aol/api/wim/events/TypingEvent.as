package com.aol.api.wim.events {
    
    import com.aol.api.wim.data.ResultData;
    
    import flash.events.Event;

    public class TypingEvent extends Event {
        
        // Capturable 
        /**
         * This event fires when our identity's information is updated. 
         */
        public static const TYPING_STATUS_SENDING:String          = "typingStatusSending";
        
        // Bubble phase
        /**
         * An event to communicate the result of trying to set typing status, whether it 
         * was successful or not. If setting the typing status was successful, the statusCode will
         * be 200.
         */
        public static const TYPING_STATUS_SEND_RESULT:String = "typingStatusSendResult";
        
        /**
         * This event fires when our identity's information is updated. 
         */
        public static const TYPING_STATUS_RECEIVED:String          = "typingStatusReceived";
        
        /**
         * Represents the typing status of the user. 
         */        
        public var typingStatus:String;
        /**
         * Represents the id of the user relevant to the type of event.
         * For TYPING_STATUS_SENDING, it represents, the destination id.
         * For TYPING_STATUS_RECEIVED, it represents the source id. 
         */        
        public var aimId:String;
        
        /**
         * This represents the result data from trying to set typing status. Only valid
         * for the TYPING_STATUS_SEND_RESULT event.  
         */        
        public var resultData:ResultData;

        /**
         * Create a typing event. 
         * @param type The type of the event (e.g. <code>TYPING_STATUS_RECEIVED</code>)
         * @param typingStatus The typing status. Valid values are in <code>TypingStatus</code>
         * @param sourceAimId
         * @param bubbles
         * @param cancelable
         * 
         */        
        public function TypingEvent(type:String, typingStatus:String, aimId:String, bubbles:Boolean=false, cancelable:Boolean=false) {
            
            //TODO: implement function
            super(type, bubbles, cancelable);
            this.typingStatus = typingStatus;
            this.aimId = aimId;
        }
        
    }
}