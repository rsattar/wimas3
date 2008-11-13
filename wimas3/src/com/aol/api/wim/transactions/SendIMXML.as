package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    
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
            _logger.debug("SendIMXML response: \n{0}", xml.toString());
            obj.statusCode       = String(xml.statusCode.text());
            obj.requestId        = String(xml.requestId.text());
            obj.statusText       = String(xml.statusText.text());

            var dataList:XMLList = xml..data;
            if(dataList.length() > 0)
            {
                // We have a data section
                obj.data = {};
                    
                var subCodeList:XMLList = xml..subCode;
                if(subCodeList.length() > 0)
                {
                    var subCode:XML = subCodeList[0];
                    obj.data.subCode = {};
                    // subCode (and reason) are sent down to provide more detailed
                    // information.  Presently we are aware of 
                    // subCode=2 which indicates that the person is on your local 
                    // permit/deny list
                    obj.data.subCode.error          = String(subCode.error.text());
                    obj.data.subCode.reason         = String(subCode.reason.text());
                    obj.data.subCode.subError       = String(subCode.subError.text());
                    obj.data.subCode.subReason      = String(subCode.subReason.text());
                }
    
                var smsCodeList:XMLList = xml..smsCode;
                if(smsCodeList.length() > 0)
                {
                    var smsCode:XML = smsCodeList[0];
                    obj.data.smsCode = {};
                    
                    obj.data.smsCode.smsError = Number(smsCode.smsError.text());
                    obj.data.smsCode.smsReason = String(smsCode.smsReason.text());
                    obj.data.smsCode.smsCarrierID = Number(smsCode.smsCarrierID.text());
                    obj.data.smsCode.smsRemainingCount = Number(smsCode.smsRemainingCount.text());
                    obj.data.smsCode.smsMaxAsciiLength = Number(smsCode.smsMaxAsciiLength.text());
                    obj.data.smsCode.smsMaxUnicodeLength = Number(smsCode.smsMaxUnicodeLength.text());
                    obj.data.smsCode.smsCarrierName = String(smsCode.smsCarrierName.text());
                    obj.data.smsCode.smsCarrierUrl = String(smsCode.smsCarrierUrl.text());
                    obj.data.smsCode.smsBalanceGroup = String(smsCode.smsBalanceGroup.text());
                }
            }
            return obj;
        }
    }
}