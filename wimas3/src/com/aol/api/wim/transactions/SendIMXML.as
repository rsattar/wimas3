package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    import com.aol.api.wim.events.IMEvent;
    
    import flash.events.Event;
    import flash.net.URLLoader;

    /**
     * A version of the SendIM class which uses an XML response, so ComScore
     * will count these IMs. I've jumped through the hoops, can I get my 
     * fish now? ><)))'>
     */
    public class SendIMXML extends SendIM
    {
        // Ensure namespace is set (for this class) or E4X won't work.
        private namespace imNS             = "http://developer.aim.com/xsd/im.xsd";
        use namespace imNS;

        override protected function get format():String { return "xml"; }
        
        public function SendIMXML(session:Session)
        {
            super(session);
        }
        
        override protected function requestComplete(evt:Event):void
        {
            //don't use the session to get the response object since
            //we are using XML
            _response = parseXML(URLLoader(evt.target).data);
            handleResponse();
        }
        
        protected function parseXML(data:Object):Object
        {
            var obj:Object = new Object;
            var xml:XML = new XML(String(data));
            obj.statusCode       = String(xml.statusCode.text());
            obj.requestId        = String(xml.requestId.text());
            obj.statusText       = String(xml.statusText.text());
            return obj;
        }
    }
}