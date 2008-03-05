== Description of Directories ==

wimas3
    The core communications library for connecting to AIM in AS3.

wimas3_testing
    Stuff for testing wimas3.swc.

wimas3 Unit Testing
    FlexUnit (http://code.google.com/p/as3flexunitlib/) unit tests.  
    These really need to be fleshed out.  How embarrassing.  

wimas3_mock_server
    If you don't want to or can't connect to a real server, use the Mock Server.  
    It's also used for unit testing.

Wimas3 Test Client
    A Flex-based test client.  It's very incomplete (no support for sending IMs).  
    We use it mostly for connectivity sanity checks.  The actual client we're 
    working on is pure AS3.  Also, 

== Build Notes ==

We are all using Eclipse with the Flex Builder 3 plugin.  While we've checked 
in the .project files, i think you may still need to edit the project
properties and re-add the wimas3.swc dependencies.

== Requirements == 

In order to connect to the AIM network, you need a developer ID.  You get 
those from http://developer.aim.com/wimReg.jsp.

== Feedback ==

Hound us!  Gripe!  Join up!  http://groups.google.com/group/wimas3

== Contributions ==

Folks with a proven track record will be promoted to committers.   You can
prove your skillz by submitting patches to the group or by having some
other evidence that you can play nicely with others and know your AS3 (like
good karma on some other AS3 project).  You know how these things go.  We 
want to strike a balance between being open and making sure that committers
are good stewards of the codebase.