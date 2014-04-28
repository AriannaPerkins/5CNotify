
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.job("eventDeletion", function(request, status) {
  // Query for user events that end earlier than the current time.
  Parse.Cloud.useMasterKey();
  var UserEvents = Parse.Object.extend("UserEvents");
  var query = new Parse.Query(UserEvents);
  var d = new Date();
  query.lessThan("endTime", d);
  query.find( {
      success: function(results) {
        alert("Successfully retrieved " + results.length + " events");
        //Delete all events that have already occured
        for (var i = 0; i < results.length; i++) { 
            var object = results[i];
            object.destroy({
            success: function(object) {
                console.log("Object deleted");
            },
            error: function(object, error) {
                console.log("Delete failed with error: " + error.code + " " + error.message);
            }
            });
        }
        status.success("Events Deleted");
    },
    error: function(error) {
        console.log("Object retreival failed with error: " + error.code + " " + error.message);
        status.error("Events Not Deleted, Error occured");
    }
  });
});

Parse.Cloud.job("userEventArrayCleanup", function(request, status){
  Parse.Cloud.useMasterKey();
  // Query for all users
  var userQuery = new Parse.Query(Parse.User);
  //Query for all events
  var userEvents = Parse.Object.extend("UserEvents");
  var eventQuery = new Parse.Query(userEvents);

  //Go through each user and remove events that no longer exist
  // in both eventsAttending and eventsCreated
  userQuery.limit(1000);
  userQuery.find( {
    success: function(users){
      var userEvents = Parse.Object.extend("UserEvents");
      var eventQuery = new Parse.Query(userEvents);
      eventQuery.limit(1000);
      eventQuery.find({
        success: function(events){
          var eventIDs = new Array();
          for (var i = 0; i < events.length; i++) {
            var theEvent = events[i];
            var objectID = theEvent.get("objectId")
            eventIDs.push(objectId); 
          };
          for (var i = 0; i < users.length; i++) {
            var user = users[i];
            var eventsAttending = new Array( user.get("eventsAttending"));
            for (var i = 0; i < eventsAttending.length; i++) {
              var objectID = eventsAttending[i];
              var eventExists = false;
              for (var i = 0; i < eventIDs.length; i++) {
                if (eventIDs[i] == objectID){
                  eventExists = true;
                  break;
                }
              };
              if (!eventExists)
                user.remove("eventsAttending", objectID);
            };
            var eventsCreated = new Array(user.get("eventsCreated"));
            for (var i = 0; i < eventsCreated.length; i++) {
              var objectID = eventsCreated[i];
              var eventExists = false;
              for (var i = 0; i < eventIDs.length; i++) {
                if (eventIDs[i] == objectID){
                  eventExists = true;
                  break;
                }
              }
              if (!eventExists)
                user.remove("eventsCreated", objectID);
            }
          }
          status.success("Events Deleted");
      },
      error: function(events, error){
        console.log("Object retreival failed with error: " + error.code + " " + error.message);
        status.error("Events Not Deleted, Error occured");
      }
    });
    },
    error: function(users, error){
        console.log("Object retreival failed with error: " + error.code + " " + error.message);
        status.error("Users not found");
      }
  });
});