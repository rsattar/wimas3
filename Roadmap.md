# Current State #

The parts of the library which are implemented (logging in, sending IMs, some Buddy List management) work fine.  We aren't using all of the WIM API yet in our client but we are getting there.  We build it out as we go.  If folks want to help out with that effort, we'll gladly accept!  In time, though, we will cover the whole API.

# Near Term Plans #

  * Expand the number of transactions to cover all of the WIM API.
  * Build out the Unit Tests.
  * More sample code.
  * build.xml files and ant integration.

# Longer Term #

  * Build out a plugin API.  WIMAS3 is designed so that you can use as much or as little of it as you need.  Ideally, we'd like for folks to be able to provide Flash plugins which could be mixed in to any app using WIMAS3.
  * Add an option for the logger to write to local connection.