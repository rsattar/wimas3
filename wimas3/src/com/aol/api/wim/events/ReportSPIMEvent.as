package com.aol.api.wim.events
{
    import flash.events.Event;

    /**
     * This event fires on the result of a call to report SPIM
     *  
     */
    public class ReportSPIMEvent extends Event
    {
        public static var REPORT_SPIM_RESULT:String = "reportSpimResult";
        
        /**
         * The status code result from the request. 200 means success. 
         */
        public var statusCode:String;
        
        /**
         * The aimId of the user who is being reported. 
         */
        public var aimId:String;
        /**
         * The type of spim...see the <pre>data.types.SPIMType</pre> class for the various types. 
         */
        public var spimType:String;
        /**
         * What caused the report to happen. Right now is only "user". 
         */
        public var spimEvent:String;
        
        public function ReportSPIMEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
        
    }
}