
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.job("eventDeletion", function(request, status) {
  // Set up to modify user data
  Parse.Cloud.useMasterKey();
  var UserEvents = Parse.Object.extend("UserEvents");
  var query = new Parse.Query(UserEvents);
  var d = new Date();
  query.lessThan("endTime", d);
  query.find( {
      success: function(results) {
        alert("Successfully retrieved " + results.length + " events");
        // Do something with the returned Parse.Object values
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
