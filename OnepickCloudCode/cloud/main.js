
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("deliveryPriceSystem", function(request, response) {
	var distanceSystem = "1000 2000 3000 4000 5000 6000 7000";
	var priceSystem = "#10 20 30 40 50 60 70";
	response.success(distanceSystem+priceSystem);
});

Parse.Cloud.define("minimumVersion", function(request, response) {
	response.success("1.0");
});