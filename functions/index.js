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

exports.getKey = functions.database.ref('/stripe_customers/${user.uid}/ephemeral_keys').onWrite(event => {
  	const stripe_version = admin.database().ref('/stripe_customers/${user.uid}/ephemeral_keys');
  	if (!stripe_version) {
    	return;
  	}
  	stripe.ephemeral_keys.create(
    	{customer: admin.database().ref('/stripe_customers/${user.uid}/customer_id')},
    	{stripe_version: stripe_version}
  	).then
});