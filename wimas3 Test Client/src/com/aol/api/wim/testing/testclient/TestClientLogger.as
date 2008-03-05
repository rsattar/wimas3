package com.aol.api.wim.testing.testclient
{
    import com.aol.api.logging.Log;
    
    import mx.controls.TextArea;

    public class TestClientLogger extends Log
    {
        private var _textArea:TextArea;
                        
        public function TestClientLogger(category:String, output:TextArea)
        {
            super(category);
            _textArea = output;
        }
        
        override protected function write(date:String, levelName:String, message:String):void
        {
            var newLine:String = "<b>" + date + "</b>" + fieldSeparator + 
                                 "<font color=\"#606060\">" + levelName + "</font>" + fieldSeparator +
                                 entitizeXML(message);
            _textArea.htmlText = _textArea.htmlText + newLine + "<br>";
            _textArea.verticalScrollPosition = int.MAX_VALUE;
        }
        
        private function entitizeXML(s:String):String
        {
            s = s.replace(/</g,"&lt;");
            s = s.replace(/>/g,"&gt;");
            return s;   
        }
    }
}