
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
    },
    error: function(error) {
        console.log("Object retreival failed with error: " + error.code + " " + error.message);
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
      for (var i = 0; i < users.length; i++) {
        var user = users[i];
        var eventsAttending = new Array( user.get("eventsAttending"));
        for (var i = 0; i < eventsAttending.length; i++) {
          var objectID = eventsAttending[i];
          eventQuery.get(objectID, {
          success: function(object) {
            // The object was retrieved successfully. Do nothing
          },
          error: function(object, error) {
            //Object does not exist, must be deleted
            if (error.code == "101"){
              user.remove("eventsAttending", objectID);
              console.log("Object deleted");
            } 
          }
          });
        };
        var eventsCreated = new Array(user.get("eventsCreated"));
        for (var i = 0; i < eventsCreated.length; i++) {
          var objectID = eventsCreated[i];
          eventQuery.get(objectID, {
          success: function(object) {
            // The object was retrieved successfully. Do nothing
          },
          error: function(object, error) {
            //Object does not exist, must be deleted
            if (error.code == "101"){
              user.remove("eventsCreated", objectID);
              console.log("Object deleted");
            } 
          }
          });
        };
      }
    },
    error: function(object, error){
      console.log("Object retreival failed with error: " + error.code + " " + error.message);
    }
  });
});