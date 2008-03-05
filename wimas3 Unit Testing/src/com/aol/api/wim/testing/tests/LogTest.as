package com.aol.api.wim.testing.tests
{
    import com.aol.api.logging.LogEventLevel;
    import com.aol.api.wim.testing.mockobjects.MockLog;
    
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    public class LogTest extends TestCase {
        public function LogTest(methodName:String=null) {
            super(methodName);
        }
        
        private var log:MockLog = new MockLog();
        
        public static function suite():TestSuite {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new LogTest("testVersion"));
            ts.addTest(new LogTest("testFatal"));
            ts.addTest(new LogTest("testError"));
            ts.addTest(new LogTest("testWarn"));
            ts.addTest(new LogTest("testInfo"));
            ts.addTest(new LogTest("testDebug"));
            ts.addTest(new LogTest("testDebugObject"));
            ts.addTest(new LogTest("testLog"));
            ts.addTest(new LogTest("testLogInvalid"));
            return ts;
        }
        
        public function testVersion():void {
        	log.debug("the library version should print out right before this");
        	log.warn("but it should only print once"); 
        }
        
        public static function fatalAssertions(date:String, levelName:String, message:String):void {
            assertTrue(message == "fatal testFatal (com.aol.api.wim.testing.tests::LogTest)");
            assertTrue(levelName == "[FATAL]");
        }
        
        public function testFatal():void {
            log.assertions = fatalAssertions;
            log.fatal("fatal {0}", this);
        }

        public static function warnAssertions(date:String, levelName:String, message:String):void {
            assertTrue(message == "warn testWarn (com.aol.api.wim.testing.tests::LogTest) with logger [object MockLog]");
            assertTrue(levelName == "[WARN]");
        }
 
        public function testWarn():void {
            log.assertions = warnAssertions;
            log.warn("warn {0} with logger {1}", this, log);
        }

        public static function errorAssertions(date:String, levelName:String, message:String):void {
            assertTrue(message == "error testError (com.aol.api.wim.testing.tests::LogTest) by [object MockLog] with [object Object]");
        }
 
        public function testError():void {
            log.assertions = errorAssertions;
            log.error("error {0} by {1} with {2}", this, log, new Object());
        }

        public static function debugAssertions(date:String, levelName:String, message:String):void {
            assertTrue(message == "debug kahn, no really, kahn, dude, kahn ... actually, kirk");
            assertTrue(levelName == "[DEBUG]");
        }

        public function testDebug():void {
            log.assertions = debugAssertions;
            log.debug("debug {0}, no really, {0}, dude, {0} ... actually, {1}", "kahn", "kirk");
        }

         public static function debugObjectAssertions(date:String, levelName:String, message:String):void {
         	// It appears that object properties are printed in a non-deterministic order so it's impossible to test this.  Please manually check the trace file.
         	
         	//var output:String = "debug this object \r\n    number (int): 43\r\n    foo (String): fooness\r\n    bar (String): barness\r\n    thingus (Object):\r\n        bid (String): bidness\r\n        baz (String): bazness";
            // trace(output);
            //assertTrue(message == output);
            assertTrue(levelName == "[DEBUG]");
        }

        public function testDebugObject():void {
            log.assertions = debugObjectAssertions;
            var o:Object = {foo:"fooness", bar:"barness", thingus:{baz:"bazness", bid:"bidness"}, number:43};
            log.debug("debug this object {0}", o);
        }

        public static function infoAssertions(date:String, levelName:String, message:String):void {
            assertTrue(message == "info");
            assertTrue(levelName == "[INFO]");
        }

        public function testInfo():void {
            log.assertions = infoAssertions;
            log.info("info");
        }

        public static function logAssertions(date:String, levelName:String, message:String):void {
            assertTrue(message == "manual level debug");
            assertTrue(levelName == "[DEBUG]");
        }

        public function testLog():void {
            log.log(LogEventLevel.DEBUG, "manual level debug", this, log);
        }
        
        public function testLogInvalid():void {
            try {
                // Disallowed level value...
                log.log(0, "manual level 0");
                fail("shouldn't get here, should have thrown an exception");
            } catch(err:ArgumentError) {
            }
        }
 
    }
}