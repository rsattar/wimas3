package com.aol.api.wim.events{
	
	import flash.events.Event;
	
	public class LifestreamEvent extends Event{
		
		public static const STREAMRECEIVED:String = "streamreceived";
		
		public static const ACTIVITYRECEIVED:String = "activityreceived";
		
		public static const DATAREADY:String = "dataloaded";
		
		public static const SVCICON_READY:String = "serviceiconready";
		
		public var data:Object;
		
		public function LifestreamEvent(type:String, _data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
            if(_data != null) {
    			this.data = _data;
            }
		}
	}
}