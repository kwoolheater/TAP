'use strict';

const functions = require('firebase-functions'),
	admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const stripe = require('stripe')(functions.config().stripe.token);


// When a user is created, register them with Stripe
exports.createStripeCustomer = functions.auth.user().onCreate(event => {
	const user = event.data;
	const uid = user.uid;
	return stripe.customers.create({
		email: user.email
	}).then (customer => {
		var stripeDatabase = admin.database().ref('/stripe_customers/');
		var idChild = stripeDatabase.child(uid);
		idChild.set ({
			email: user.email,
			customer_id: customer.id
		})
    	return admin.database().ref(`/stripe_customers/${user.uid}/customer_id`).set(customer.id);
	});
	console.log("Successful key created");
});

//make key 
exports.ephemeralKey = functions.database.ref('/stripe_customers').onWrite(event =>{
	const user = event.data;
	admin.database().ref('/stripe_customers/newKey').set(user);
});

// Make key for ephemeral key through Stripe
exports.createEphemeralKeys = functions.https.onRequest((req, res) => {
	var api_version = req.body.api_version;
	var customerId = req.body.customerId;

	if (!api_version) {
  		res.status(400).end();
 	 	return;
	}

	stripe.ephemeralKeys.create(
  		{ customer: customerId },
  		{ stripe_version: api_version }, 

 	function(err, key) {
 		console.log(key)
    	return res.send(key);
 	});   

});
//problem is that the user id is unset...on write function needs to be called after...need it to be some sort of post method
/*exports.getKey = functions.database.ref('/stripe_customers/${user.uid}/ephemeral_keys').onWrite(event => {
  	const stripe_version = admin.database().ref('/stripe_customers/${user.uid}/ephemeral_keys');
  	if (!stripe_version) {
    	return;
  	}
  	stripe.ephemeral_keys.create(
    	{customer: admin.database().ref('/stripe_customers/${user.uid}/customer_id')},
    	{stripe_version: stripe_version}
  	).then((key) => {
  		admin.database.ref('/stripe_customers/${user.uid}/customer_id')
 	});
});*/